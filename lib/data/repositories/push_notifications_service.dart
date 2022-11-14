import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wifi_led_esp8266/firebase_options.dart';

class NotificationMessage {
  const NotificationMessage({required this.title, required this.body});
  final String title;
  final String body;
}

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static final StreamController<NotificationMessage>
      _notificationMessageStream = StreamController.broadcast();
  static Stream<NotificationMessage> get notificationMessagesStream =>
      _notificationMessageStream.stream;

  static NotificationMessage? _getNotifcationMessage(RemoteMessage message) {
    if (message.notification?.title == null) return null;
    if (message.notification?.body == null) return null;

    return NotificationMessage(
      title: message.notification!.title!,
      body: message.notification!.body!,
    );
  }

  static Future _backgroundHandler(RemoteMessage message) async {
    log('background message ${message.data}');
    log('background message ${message.notification?.title}');
    log('background message ${message.notification?.body}');

    _messageStream.add(message.data['product'] ?? 'No data');
    final notificationMessage = _getNotifcationMessage(message);
    if (notificationMessage != null) {
      _notificationMessageStream.add(notificationMessage);
    }
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    log('on message ${message.data}');
    log('on message ${message.notification?.title}');
    log('on message ${message.notification?.body}');
    _messageStream.add(message.data['product'] ?? 'No data');
    final notificationMessage = _getNotifcationMessage(message);
    if (notificationMessage != null) {
      _notificationMessageStream.add(notificationMessage);
    }
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    log('_onMessageOpenApp message ${message.data}');
    log('_onMessageOpenApp message ${message.notification?.title}');
    log('_onMessageOpenApp message ${message.notification?.body}');
    _messageStream.add(message.data['product'] ?? 'No data');
    final notificationMessage = _getNotifcationMessage(message);
    if (notificationMessage != null) {
      _notificationMessageStream.add(notificationMessage);
    }
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();

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
  }

  static closeStreams() {
    _messageStream.close();
  }
}
