import 'dart:async';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:wifi_led_esp8266/model/connection_info.dart';
import 'package:wifi_led_esp8266/model/fridge.dart';
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
  late ConnectionInfo? _connectionInfo;

  final StreamController<List<FridgeState>> _fridgesStateStreamController =
      new StreamController.broadcast();
  Stream<List<FridgeState>> get fridgesStateStream =>
      _fridgesStateStreamController.stream;
  List<FridgeState> _fridgesState = [];
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

    connect();
  }

  void onDisconnected() {
    connected = false;
    _connectionInfo = null;
    _fridgesState = [];

    _connectionStatusStreamController.add(connected);
    _connectionInfoStreamController.add(_connectionInfo);
    _fridgesStateStreamController.add(_fridgesState);
  }

  void connect() async {
    try {
      print("Trying to connect...");
      final MqttClientConnectionStatus? connectionStatus =
          await client.connect();
      print("Connection ${connectionStatus?.state}");

      /// Check we are connected
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        _connectionStatusStreamController.add(true);
        connected = true;
        initSubscription();
      } else {
        client.disconnect();
      }
    } on Exception catch (e) {
      client.disconnect();
    }
  }

  void initSubscription() {
    client.subscribe('#', MqttQos.atMostOnce);
    client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? message) async {
      final recMess = message![0].payload as MqttPublishMessage;
      final topic = message[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      final jsonDecoded = json.decode(payload);
      print("Received $topic " + "Payload $payload");

      /// The information of the connection was updated
      if (topic == "information") onInformationUpdate(jsonDecoded);

      final List<String> topicSplitted = topic.split('/');

      /// A state was updated
      if (topicSplitted[0] == "state") {
        String? _fridgeId = topicSplitted[1];
        if (_connectionInfo!.standalone && _fridgeId == _connectionInfo!.id) {
          final FridgeState _newFridgeState = FridgeState.fromJson(jsonDecoded);

          try {
            final int _indexOfFridge = _fridgesState
                .map((e) => e.id)
                .toList()
                .indexOf(_newFridgeState.id);
            if (_indexOfFridge == -1) {
              _fridgesState.add(_newFridgeState);
            } else {
              _fridgesState[_indexOfFridge] = _newFridgeState;
            }
            _fridgesStateStreamController.add(_fridgesState);
          } catch (e) {
            print("error");
            print(e);
          }
        }
      }
    });
  }

  void onInformationUpdate(Map<String, dynamic> json) {
    // print("new info");
    // print("ssid ${json["ssid"]} ${json["id"]}");
    _connectionInfo = ConnectionInfo.fromJson(json);
    _connectionInfoStreamController.add(_connectionInfo);
  }
}
