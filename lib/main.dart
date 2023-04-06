
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pembayaran_kas/view/home.dart';
import 'package:pembayaran_kas/view/root_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); 
  await Hive.openBox('startButtonState');
  await Hive.openBox('payment');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent, 
));

  runApp(const MyApp());
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
    return  MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          titleMedium: TextStyle(color: Colors.black,fontSize: 14),
          displayLarge: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600)
        ),
        brightness: Brightness.light,
        primaryColor: const Color(0xFF4273FF),
        colorScheme:const ColorScheme.light(
          primary: Color(0xFF4273FF),
          tertiary: Color(0xFFFFF32B),
          secondary: Color(0xFF4273FF)
          
          
        ) 

      ),
      home: const RootPage(),
    );
  }
}
