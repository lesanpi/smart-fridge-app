import 'dart:async';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:wifi_led_esp8266/model/connection_info.dart';
import 'package:wifi_led_esp8266/model/fridge_info.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';

class LocalRepository {
  // Local Connection status
  bool connected = false;
  final StreamController<bool> _connectionStatusStreamController =
      new StreamController.broadcast();
  Stream<bool> get connectedStream => _connectionStatusStreamController.stream;

  final StreamController<ConnectionInfo?> _connectionInfoStreamController =
      new StreamController.broadcast();
  Stream<ConnectionInfo?> get connectionInfoStream =>
      _connectionInfoStreamController.stream;
  ConnectionInfo? connectionInfo;

  final StreamController<List<FridgeState?>> _fridgesStateStreamController =
      new StreamController.broadcast();
  Stream<List<FridgeState?>> get fridgesStateStream =>
      _fridgesStateStreamController.stream;
  List<FridgeState?> _fridgesState = [];
  // Fridges's connected.
  List<String> fridgesId = [];
  // MQTT Client
  MqttServerClient client = MqttServerClient('192.168.4.1', '');

  void init() {
    client = MqttServerClient('192.168.4.1', '');

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
    connected = false;
    connectionInfo = null;
    _fridgesState = [];

    _connectionStatusStreamController.add(connected);
    _connectionInfoStreamController.add(connectionInfo);
    _fridgesStateStreamController.add(_fridgesState);
  }

  Future<bool> connect(String id, String password) async {
    if (connectionInfo != null) return true;
    init();
    try {
      print("Trying to connect...");
      final MqttClientConnectionStatus? connectionStatus =
          await client.connect(id, password);
      print("Connection ${connectionStatus?.state}");

      /// Check we are connected
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        _connectionStatusStreamController.add(true);
        connected = true;
        initSubscription();
        print('conected');
        return connected;
      }

      print('disconnected');
      client.disconnect();
      return false;
    } on Exception catch (e) {
      print('disconnected por excepcion');
      print(e);
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
      final int _indexOfFridge =
          _fridgesState.indexWhere((state) => state?.id == id);

      if (_indexOfFridge == -1) {
        _fridgesState.add(_newFridgeState);
      } else {
        _fridgesState[_indexOfFridge] = _newFridgeState;
      }

      _fridgesStateStreamController.add(_fridgesState);
      return;
    }
  }

  FridgeState? getFridgeStateById(String id) {
    // final int _indexOfFridge =
    //     _fridgesState.map((e) => e.id).toList().indexOf(_newFridgeState.id);

    return _fridgesState.firstWhere((fridgeState) => fridgeState?.id == id,
        orElse: () => null);
  }

  void onInformationUpdate(Map<String, dynamic> json) {
    // print("new info");
    // print("ssid ${json["ssid"]} ${json["id"]}");
    connectionInfo = ConnectionInfo.fromJson(json);
    _connectionInfoStreamController.add(connectionInfo);
  }

  void toggleLight(String fridgeId) {
    dynamic data = jsonEncode({
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
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/' + fridgeId,
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }
}