import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/auth_repository.dart';
import 'package:wifi_led_esp8266/models/device_message.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';

class CloudRepository {
  CloudRepository(this._authRepository);
  final AuthRepository _authRepository;
  bool conected = false;

  final StreamController<List<FridgeState>> _fridgesStateStreamController =
      StreamController.broadcast();
  Stream<List<FridgeState>> get fridgesStateStream =>
      _fridgesStateStreamController.stream;
  List<FridgeState> fridgesState = [];

  /// Device message
  final StreamController<DeviceMessage> _deviceMessageStreamController =
      StreamController.broadcast();
  Stream<DeviceMessage> get deviceMessageStream =>
      _deviceMessageStreamController.stream;

  /// Device error message
  final StreamController<DeviceMessage> _deviceErrorMessageStreamController =
      StreamController.broadcast();
  Stream<DeviceMessage> get deviceErrorMessageStream =>
      _deviceErrorMessageStreamController.stream;

  // Fridge selected.
  final StreamController<FridgeState?> _fridgeSelectedStreamController =
      StreamController.broadcast();
  Stream<FridgeState?> get fridgeSelectedStream =>
      _fridgeSelectedStreamController.stream;
  FridgeState? fridgeSelected;

  // MQTT Client
  MqttServerClient client =
      MqttServerClient.withPort(Consts.mqttCloudUrl, '', 8883);

  Future<void> init({String server = Consts.mqttCloudUrl}) async {
    client = MqttServerClient.withPort(Consts.mqttCloudUrl, '', 8883);

    /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    client.keepAlivePeriod = 30;
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password and clean session,
    /// an example of a specific one below.
    final connMess = MqttConnectMessage()
        .withClientIdentifier(_authRepository.currentUser!.id)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.exactlyOnce);
    client.connectionMessage = connMess;
  }

  void onDisconnected() {
    fridgeSelected = null;
    fridgesState = [];

    _fridgesStateStreamController.add(fridgesState);
    _fridgeSelectedStreamController.add(fridgeSelected);
    conected = false;
  }

  Future<bool> connect(
      {String id = 'testUser',
      String password = 'testUser',
      String server = Consts.mqttCloudUrl}) async {
    if (client.connectionStatus?.state == MqttConnectionState.connected ||
        client.connectionStatus?.state == MqttConnectionState.connecting) {
      client.disconnect();
    }
    await Future.delayed(const Duration(seconds: 1));

    await init(server: server);

    try {
      final MqttClientConnectionStatus? connectionStatus =
          await client.connect(id, password);

      /// Check we are connected
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        log('✅ Cloud connected', name: 'CloudRepository.connect');

        initSubscription();
        conected = true;
        return true;
      }

      client.disconnect();
      conected = false;
      return false;
    } on SocketException {
      client.disconnect();
      conected = false;

      return false;
    } on Exception {
      client.disconnect();
      conected = false;

      return false;
    }
  }

  void initSubscription() {
    if (_authRepository.currentUser == null) {
      return;
    }
    final fridges = _authRepository.currentUser!.fridges;

    log(
      '🔥 Init subscription for ${fridges.length} fridges',
      name: 'CloudRepository.initSubscription',
    );
    // client.subscribe('state/#', MqttQos.exactlyOnce);
    // client.subscribe('state/62f90f52d8f2c401b58817e3', MqttQos.exactlyOnce);

    // client.subscribe('state/6312c34b49d3ac2f30375872', MqttQos.exactlyOnce);
    for (var element in fridges) {
      client.subscribe('state/$element', MqttQos.exactlyOnce);
      client.subscribe('message/$element', MqttQos.exactlyOnce);
      client.subscribe('error/$element', MqttQos.exactlyOnce);
    }
    client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? message) async {
      final recMess = message![0].payload as MqttPublishMessage;
      final topic = message[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      Map<String, dynamic> jsonDecoded;
      try {
        jsonDecoded = json.decode(payload);
      } catch (e) {
        return;
      }

      // if (jsonDecoded == null) return;

      /// The information of the connection was updated
      final List<String> topicSplitted = topic.split('/');

      /// A state was updated
      if (topicSplitted[0] == "state") {
        final id = topicSplitted[1];
        log(
          '🧊 Update state received from device [$id]',
          name: 'CloudRepository.state',
        );
        try {
          onStateUpdate(jsonDecoded, id);
        } catch (e) {
          log(
            '❌ Error updating state [$id]',
            name: 'CloudRepository.state',
            error: e,
          );
        }
      }

      if (topicSplitted[0] == "error") {
        log(
          '❌ Error received from device [$topic]',
          name: 'CloudRepository.error',
        );

        /// Error message
        try {
          log('Device error message received');
          final deviceMessage = DeviceMessage.fromMap(jsonDecoded, true);
          _deviceErrorMessageStreamController.add(deviceMessage);
        } catch (_) {}
      }

      if (topicSplitted[0] == "message") {
        log(
          '📦 Message received from device [$topic]',
          name: 'CloudRepository.message',
        );

        /// Message
        final deviceMessage = DeviceMessage.fromMap(jsonDecoded, false);
        log('Device message received $deviceMessage');
        _deviceMessageStreamController.add(deviceMessage);
      }
    });
  }

  void onStateUpdate(Map<String, dynamic> json, String topicId) {
    final FridgeState newFridgeState = FridgeState.fromJson(json);

    final id = newFridgeState.id;
    final int indexOfFridge =
        fridgesState.indexWhere((state) => state.id == id);
    if (fridgeSelected != null && newFridgeState.id == fridgeSelected?.id) {
      fridgeSelected = newFridgeState;
      _fridgeSelectedStreamController.add(fridgeSelected);
    }
    if (indexOfFridge == -1) {
      // fridgesState.add(_newFridgeState);

      if (_authRepository.currentUser!.fridges
          .any((element) => id == element)) {
        fridgesState.add(newFridgeState);
      }
    } else {
      fridgesState[indexOfFridge] = newFridgeState;
    }

    // fridgesState.map((e) => e.toJson()).toList().toString());

    _fridgesStateStreamController.add(fridgesState);
    return;
  }

  FridgeState? getFridgeStateById(String id) {
    // final int _indexOfFridge =
    //     _fridgesState.map((e) => e.id).toList().indexOf(_newFridgeState.id);

    // ignore: unnecessary_cast
    return (fridgesState as List<FridgeState?>)
        .firstWhere((fridgeState) => fridgeState?.id == id, orElse: () => null);
  }

  void selectFridge(FridgeState fridgeSelected) {
    log(
      '✅ Selecting fridge $FridgeState',
      name: 'CloudRepository.selectFridge',
    );

    this.fridgeSelected = fridgeSelected;
    _fridgeSelectedStreamController.add(fridgeSelected);
  }

  void unselectFridge() {
    fridgeSelected = null;
    _fridgeSelectedStreamController.add(fridgeSelected);
  }

  void changeName(String fridgeId, String name) {
    final data = jsonEncode({
      'action': 'changeName',
      'name': name,
    });
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void toggleLight(String fridgeId) {
    final data = jsonEncode({
      'action': 'toggleLight',
    });
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void muteAlerts(String fridgeId) {
    final data = jsonEncode({
      'action': 'muteAlerts',
    });
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void factoryRestore(String fridgeId) {
    final data = jsonEncode({
      'action': 'factoryRestore',
    });
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );

    client.unsubscribe('state/$fridgeId');

    fridgesState =
        fridgesState.where((element) => element.id != fridgeId).toList();
    if (fridgeSelected?.id == fridgeId) {
      fridgeSelected = null;
    }

    _fridgeSelectedStreamController.add(fridgeSelected);
    _fridgesStateStreamController.add(fridgesState);
  }

  void setDesiredTemperature(String fridgeId, int desiredTemperature) {
    final data = jsonEncode({
      'action': 'setDesiredTemperature',
      'temperature': desiredTemperature,
    });
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void setMaxTemperature(String fridgeId, int maxTemperature) {
    final data = jsonEncode({
      'action': 'setMaxTemperature',
      'maxTemperature': maxTemperature,
    });
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void setMinTemperature(String fridgeId, int minTemperature) {
    final data = jsonEncode({
      'action': 'setMinTemperature',
      'minTemperature': minTemperature,
    });

    log('setMinTemperature value: $minTemperature, id: $fridgeId',
        name: 'CloudRepository.setMinTemperature');
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void setCompressorMinutes(String fridgeId, int minutes) {
    final data = jsonEncode({
      'action': 'changeMinutesToWait',
      'minutes': minutes,
    });
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void setStandaloneMode(String fridgeId, String ssid) {
    final data = jsonEncode({
      'action': 'setStandaloneMode',
      'ssid': ssid,
    });
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void setCoordinatorMode(String fridgeId, String ssid, String password) {
    final data = jsonEncode({
      'action': 'setCoordinatorMode',
      'ssid': ssid,
      'password': password,
    });

    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void setInternet(String fridgeId, String ssid, String password) {
    final data = jsonEncode({
      'action': 'setInternet',
      'ssid': ssid,
      'password': password,
    });

    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }
}
