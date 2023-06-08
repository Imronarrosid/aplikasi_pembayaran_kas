import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pembayaran_kas/firebase_options.dart';
import 'package:pembayaran_kas/service/notification.dart';
import 'package:pembayaran_kas/screen/root_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  WidgetsFlutterBinding.ensureInitialized();
  Notif().initNotification();
  await Hive.initFlutter();
  await Hive.openBox('startButtonState');
  await Hive.openBox('payment');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await initializeDateFormatting('id_ID', null).then((_) => 
  runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
              titleMedium: TextStyle(color: Colors.black, fontSize: 14),
              displayLarge: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          brightness: Brightness.light,
          primaryColor: const Color(0xFF4273FF),
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF4273FF),
              tertiary: Color(0xFFFFF32B),
              secondary: Color(0xFF4273FF))),
      home: const RootPage(),
    );
  }
}
