import 'package:flutter/material.dart';
import 'package:push_notifications/screens/screens.dart';
import 'package:push_notifications/services/push_notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationsService.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();

    PushNotificationsService.messagesStream.listen((product) {
      //navegacion
      navigatorKey.currentState?.pushNamed('/message', arguments: product);

      //snackbar
      final snackBar = SnackBar(content: Text(product));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, //Navegar
      scaffoldMessengerKey: messengerKey, //Snack
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/home',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/message': (_) => const MessageScreen()
      },
    );
  }
}
