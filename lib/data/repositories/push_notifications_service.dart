import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wifi_led_esp8266/firebase_options.dart';

const channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

class NotificationMessage {
  const NotificationMessage({required this.title, required this.body});
  final String title;
  final String body;
}

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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

    final notification = message.notification;
    final android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            icon: android.smallIcon,
            // other properties...
          ),
        ),
      );
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
    final notification = message.notification;
    final android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            icon: android.smallIcon,
            // other properties...
          ),
        ),
      );
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

    final notification = message.notification;
    final android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            icon: android.smallIcon,
            // other properties...
          ),
        ),
      );
    }
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();

// Local Notifications
    const initializationSettingsAndroid = AndroidInitializationSettings('logo');
    const initializationSettingsDarwin = IOSInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  // Apple / Web
  static requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static closeStreams() {
    _messageStream.close();
  }
}
