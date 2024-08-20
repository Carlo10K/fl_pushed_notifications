import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:push_notifications/firebase_options.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _streamController =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _streamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    //print('onBackground handler ${message.messageId}');
    _streamController.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print('onMessage handler ${message.messageId}');
    _streamController.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print('onMessageOpenApp handler ${message.messageId}');
    _streamController.add(message.data['product'] ?? 'No data');
  }

  static Future initializeApp() async {
    //push
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await messaging.requestPermission(provisional: true);

    token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print(token);
    }

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //local
  }

  static closeStream() {
    _streamController.close();
  }
}
