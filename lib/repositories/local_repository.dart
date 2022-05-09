import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LocalRepository {
  // Local Connection status
  bool connected = false;
  final StreamController<bool> _connectionStatusStreamController =
      new StreamController.broadcast();
  Stream<bool> get connectedStream => _connectionStatusStreamController.stream;

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
    _connectionStatusStreamController.add(false);
    connected = false;
    fridgesId = [];
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
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? message) {
      final recMess = message![0].payload as MqttPublishMessage;
      final topic = message[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print("Received $topic");
      print("Payload $payload");
    });
  }
}
