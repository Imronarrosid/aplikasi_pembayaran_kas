import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pembayaran_kas/firebase_options.dart';
import 'package:pembayaran_kas/model/repository/authentication_repository/authentication_repository.dart';
import 'package:pembayaran_kas/service/notification.dart';
import 'package:pembayaran_kas/view/root_page.dart';
import 'package:pembayaran_kas/view_model/bloc/authentication_bloc.dart';
import 'package:pembayaran_kas/view_model/routes/route.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Notif().initNotification();
  await Hive.initFlutter();
  await Hive.openBox('startButtonState');
  await Hive.openBox('payment');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));
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
    return RepositoryProvider(
      create: (context) => AuthenticationRepository(),
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context)),
        child: MaterialApp(
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
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return InitialScreen(state: state);
            },
          ),
        ),
      ),
    );
  }
}
