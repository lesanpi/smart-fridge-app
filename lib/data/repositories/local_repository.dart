import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';
import 'package:wifi_led_esp8266/models/controller_configuration.dart';
import 'package:wifi_led_esp8266/models/coordinator_configuration.dart';
import 'package:wifi_led_esp8266/models/device_configuration.dart';
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

  // Fridge selected.
  final StreamController<FridgeState?> _fridgeSelectedStreamController =
      StreamController.broadcast();
  Stream<FridgeState?> get fridgeSelectedStream =>
      _fridgeSelectedStreamController.stream;
  FridgeState? fridgeSelected;

  // MQTT Client
  MqttServerClient client = MqttServerClient.withPort('192.168.0.1', '', 1883);

  Future<void> init({String server = '192.168.0.1'}) async {
    // client = MqttServerClient(server, '');
    client = MqttServerClient.withPort(server, '', 1883);

    /// Set the correct MQTT protocol for mosquito
    client.setProtocolV311();

    /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    client.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password and clean session,
    /// an example of a specific one below.
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueIdWildcard')
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
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
    await Future.delayed(const Duration(seconds: 1));

    if (connectionInfo != null) return true;

    await init(server: server);
    print('Inicializado');
    try {
      final MqttClientConnectionStatus? connectionStatus =
          await client.connect(id, password);

      print('Connection status: $connectionStatus');

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
          final splittedIp = wifiIp.split('.');
          splittedIp.removeLast();
          final serverIp = splittedIp.join('.') + '.200';
          return await connect(id, password, server: serverIp);
        }

        return false;
      }
      client.disconnect();
      return false;
    } on Exception catch (e) {
      client.disconnect();
      return false;
    }
  }

  void initSubscription() {
    client.subscribe('information', MqttQos.atMostOnce);
    client.subscribe('state/#', MqttQos.atMostOnce);
    client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? message) async {
      final recMess = message![0].payload as MqttPublishMessage;
      final topic = message[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      final jsonDecoded = json.decode(payload);

      if (jsonDecoded == null) return;

      /// The information of the connection was updated
      if (topic == "information") onInformationUpdate(jsonDecoded);

      final List<String> topicSplitted = topic.split('/');

      /// A state was updated
      if (topicSplitted[0] == "state") {
        final id = topicSplitted[1];
        onStateUpdate(jsonDecoded, id);
      }
    });
  }

  void onStateUpdate(Map<String, dynamic> json, String id) {
    final FridgeState _newFridgeState = FridgeState.fromJson(json);
    // print(_newFridgeState.temperature);

    if (connectionInfo == null) return;

    if (connectionInfo!.standalone && id == connectionInfo!.id) {
      fridgeSelected = _newFridgeState;
      _fridgeSelectedStreamController.add(fridgeSelected);

      final int _indexOfFridge =
          fridgesState.indexWhere((state) => state.id == id);

      if (_indexOfFridge == -1) {
        fridgesState.add(_newFridgeState);
      } else {
        fridgesState[_indexOfFridge] = _newFridgeState;
      }

      _fridgesStateStreamController.add(fridgesState);
      return;
    }

    if (!connectionInfo!.standalone) {
      final int _indexOfFridge =
          fridgesState.indexWhere((state) => state.id == id);

      if (fridgeSelected != null && _newFridgeState.id == fridgeSelected?.id) {
        fridgeSelected = _newFridgeState;
        _fridgeSelectedStreamController.add(fridgeSelected);
      }

      // print(_indexOfFridge);
      if (_indexOfFridge == -1) {
        // print('Agrego nuevo estado a la lista');
        fridgesState.add(_newFridgeState);
      } else {
        // print('Sustituyo estado existente');
        // print(_newFridgeState.temperature);
        fridgesState[_indexOfFridge] = _newFridgeState;
      }
      // print('Finalmente' +
      // fridgesState.map((e) => e.toJson()).toList().toString());

      _fridgesStateStreamController.add(fridgesState);
      return;
    }
  }

  void onInformationUpdate(Map<String, dynamic> json) {
    // print("ssid ${json["ssid"]} ${json["id"]}");
    connectionInfo = ConnectionInfo.fromJson(json);
    _connectionInfoStreamController.add(connectionInfo);
  }

  FridgeState? getFridgeStateById(String id) {
    // final int _indexOfFridge =
    //     _fridgesState.map((e) => e.id).toList().indexOf(_newFridgeState.id);

    return (fridgesState as List<FridgeState?>)
        .firstWhere((fridgeState) => fridgeState?.id == id, orElse: () => null);
  }

  void selectFridge(FridgeState _fridgeSelected) {
    fridgeSelected = _fridgeSelected;
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
      'action/' + fridgeId,
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
      'action/' + fridgeId,
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
      'action/' + fridgeId,
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
      'action/' + fridgeId,
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
      'action/' + fridgeId,
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
    print(data);
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/' + fridgeId,
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }

  void configureController(
      DeviceConfiguration configuration, String userId, String id) {
    if (connectionInfo == null) return;
    if (!connectionInfo!.configurationMode) return;
    if (!connectionInfo!.standalone) return;

    final data = jsonEncode(
      {
        'action': 'configureDevice',
        ...configuration.toMap(),
        'id': id,
        'userId': userId,
      },
    );
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);

    client.publishMessage(
      'action/' + connectionInfo!.id,
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
      'action/' + connectionInfo!.id,
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }
}
