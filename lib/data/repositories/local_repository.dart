import 'dart:async';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';
import 'package:wifi_led_esp8266/models/fridge_info.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';

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
  MqttServerClient client = MqttServerClient('192.168.0.1', '');

  void init() {
    client = MqttServerClient('192.168.0.1', '');

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

  Future<bool> connect(String id, String password) async {
    if (client.connectionStatus?.state == MqttConnectionState.connected ||
        client.connectionStatus?.state == MqttConnectionState.connecting) {
      client.disconnect();
    }
    await Future.delayed(Duration(seconds: 1));
    print('Connecting..');

    if (connectionInfo != null) return true;

    init();
    try {
      print("Trying to connect...");
      final MqttClientConnectionStatus? connectionStatus =
          await client.connect(id, password);
      print("Connection ${connectionStatus?.state}");

      /// Check we are connected
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        initSubscription();
        print('conected');
        return true;
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

      print(jsonDecoded);
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
    print("new info");
    print(json);
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
    print(data);
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(data);
    client.publishMessage(
      'action/' + fridgeId,
      MqttQos.atLeastOnce,
      payloadBuilder.payload!,
    );
  }
}
