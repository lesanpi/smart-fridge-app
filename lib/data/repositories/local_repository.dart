import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';
import 'package:wifi_led_esp8266/models/device_configuration.dart';
import 'package:wifi_led_esp8266/models/device_message.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:network_info_plus/network_info_plus.dart';

class LocalRepository {
  final StreamController<ConnectionInfo?> _connectionInfoStreamController =
      StreamController.broadcast();
  Stream<ConnectionInfo?> get connectionInfoStream =>
      _connectionInfoStreamController.stream;
  ConnectionInfo? connectionInfo;

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
  MqttServerClient client = MqttServerClient.withPort('192.168.0.1', '', 1883);

  Future<void> init(
      {String server = '192.168.0.1', String identifier = ''}) async {
    // client = MqttServerClient(server, '');
    client = MqttServerClient.withPort(server, identifier, 1883);

    /// Set the correct MQTT protocol for mosquito
    client.setProtocolV311();

    /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    client.keepAlivePeriod = 60;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password and clean session,
    /// an example of a specific one below.
    final connMess = MqttConnectMessage()
        .withClientIdentifier(identifier)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMess;

    // connect();
  }

  void onDisconnected() {
    fridgeSelected = null;
    connectionInfo = null;
    fridgesState = [];

    _connectionInfoStreamController.add(connectionInfo);
    _fridgesStateStreamController.add(fridgesState);
    _fridgeSelectedStreamController.add(fridgeSelected);
  }

  Future<bool> connect(String id, String password,
      {String server = Consts.mqttDefaultCoordinatorIp}) async {
    if (client.connectionStatus?.state == MqttConnectionState.connected ||
        client.connectionStatus?.state == MqttConnectionState.connecting) {
      client.disconnect();
    }

    log('📶 Starting MQTT connection, with server $server');
    log('Id: $id Password $password');
    await Future.delayed(const Duration(seconds: 1));

    if (connectionInfo != null) return true;

    await init(
      server: server,
      identifier: id,
    );

    try {
      final MqttClientConnectionStatus? connectionStatus =
          await client.connect(id, '');

      /// Check we are connected
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        initSubscription();
        return true;
      }

      client.disconnect();
      return false;
    } on SocketException catch (e) {
      if (e.osError?.errorCode == 113 &&
          server == Consts.mqttDefaultCoordinatorIp) {
        final String? wifiIp = await NetworkInfo().getWifiIP();
        if (wifiIp != null) {
          log('❌ MQTT connection failed with server $server');
          final splittedIp = wifiIp.split('.');
          splittedIp.removeLast();
          final serverIp = '${splittedIp.join('.')}.200';
          return await connect(id, password, server: serverIp);
        }

        return false;
      }
      client.disconnect();
      return false;
    } on Exception catch (e) {
      log('❌ MQTT connection failed', error: e);

      client.disconnect();
      return false;
    }
  }

  void initSubscription() {
    client.subscribe('information', MqttQos.atMostOnce);
    client.subscribe('state/#', MqttQos.atMostOnce);
    client.subscribe('message/#', MqttQos.exactlyOnce);
    client.subscribe('error/#', MqttQos.exactlyOnce);
    client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? message) async {
      final recMess = message![0].payload as MqttPublishMessage;
      final topic = message[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      Map<String, dynamic>? jsonDecoded;
      try {
        jsonDecoded = json.decode(payload);
      } catch (e) {
        return;
      }

      if (jsonDecoded == null) return;

      /// The information of the connection was updated
      if (topic == "information") onInformationUpdate(jsonDecoded);

      final List<String> topicSplitted = topic.split('/');

      /// A state was updated
      if (topicSplitted[0] == "state") {
        final id = topicSplitted[1];
        onStateUpdate(jsonDecoded, id);
      }

      if (topicSplitted[0] == "error") {
        /// Error message
        try {
          log('Device error message received');
          final deviceMessage = DeviceMessage.fromMap(jsonDecoded, true);
          _deviceErrorMessageStreamController.add(deviceMessage);
        } catch (_) {}
      }

      if (topicSplitted[0] == "message") {
        /// Message
        try {
          final deviceMessage = DeviceMessage.fromMap(jsonDecoded, false);
          log('Device message received $deviceMessage');
          _deviceMessageStreamController.add(deviceMessage);
        } catch (_) {}
      }
    });
  }

  void onStateUpdate(Map<String, dynamic> json, String id) {
    if (json.isEmpty) return;
    final FridgeState newFridgeState = FridgeState.fromJson(json);

    if (connectionInfo == null) return;

    if (connectionInfo!.standalone && id == connectionInfo!.id) {
      fridgeSelected = newFridgeState;
      _fridgeSelectedStreamController.add(fridgeSelected);

      final int indexOfFridge =
          fridgesState.indexWhere((state) => state.id == id);

      if (indexOfFridge == -1) {
        fridgesState.add(newFridgeState);
      } else {
        fridgesState[indexOfFridge] = newFridgeState;
      }

      _fridgesStateStreamController.add(fridgesState);
      return;
    }

    if (!connectionInfo!.standalone) {
      final int indexOfFridge =
          fridgesState.indexWhere((state) => state.id == id);

      if (fridgeSelected != null && newFridgeState.id == fridgeSelected?.id) {
        fridgeSelected = newFridgeState;
        _fridgeSelectedStreamController.add(fridgeSelected);
      }

      if (indexOfFridge == -1) {
        fridgesState.add(newFridgeState);
      } else {
        fridgesState[indexOfFridge] = newFridgeState;
      }

      // fridgesState.map((e) => e.toJson()).toList().toString());

      _fridgesStateStreamController.add(fridgesState);
      return;
    }
  }

  void onInformationUpdate(Map<String, dynamic> json) {
    connectionInfo = ConnectionInfo.fromJson(json);
    _connectionInfoStreamController.add(connectionInfo);
  }

  FridgeState? getFridgeStateById(String id) {
    // final int _indexOfFridge =
    //     _fridgesState.map((e) => e.id).toList().indexOf(_newFridgeState.id);

    // ignore: unnecessary_cast
    return (fridgesState as List<FridgeState?>)
        .firstWhere((fridgeState) => fridgeState?.id == id, orElse: () => null);
  }

  void selectFridge(FridgeState fridgeSelected) {
    fridgeSelected = fridgeSelected;
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
    if (connectionInfo == null) return;

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
    if (connectionInfo!.standalone) {
      client.disconnect();
    }

    fridgesState =
        fridgesState.where((element) => element.id != fridgeId).toList();
    if (fridgeSelected?.id == fridgeId) {
      fridgeSelected = null;
    }

    _fridgeSelectedStreamController.add(fridgeSelected);
    _fridgesStateStreamController.add(fridgesState);
  }

  void factoryRestoreCoordinator() {}

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
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/$fridgeId',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
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

  void configureController(DeviceConfiguration configuration, String userId) {
    if (connectionInfo == null) return;
    if (!connectionInfo!.configurationMode) return;
    if (!connectionInfo!.standalone) return;

    final data = jsonEncode(
      {
        'action': 'configureDevice',
        // 'id': id,
        'userId': userId,
        ...configuration.toMap(),
      },
    );
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);

    client.publishMessage(
      'action/${connectionInfo!.id}',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void configureCoordinator(
      DeviceConfiguration configuration, String userId, String id) {
    if (connectionInfo == null) return;
    if (!connectionInfo!.configurationMode) return;
    if (connectionInfo!.standalone) return;

    final data = jsonEncode(
      {
        'action': 'configureCoordinator',
        ...configuration.toMap(),
        'id': id,
        'userId': userId,
      },
    );
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);

    client.publishMessage(
      'action/${connectionInfo!.id}',
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }
}
