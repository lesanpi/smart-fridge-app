import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wifi_led_esp8266/firebase_options.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    // print( 'onBackground Handler ${ message.messageId }');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print( 'onMessage Handler ${ message.messageId }');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print( 'onMessageOpenApp Handler ${ message.messageId }');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // Local Notifications
  }

  // Apple / Web
  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    _messageStream.close();
  }
}
