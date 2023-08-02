import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Pages/login_page.dart';
import 'package:network/Pages/registration_page.dart';
import 'package:network/Screens/HomeScreen.dart';

import 'Screens/LoginScreen.dart';

late Box box1;

Future<void> main() async {
  await Hive.initFlutter();
  box1 = await Hive.openBox('logindata'); //init hive
  WidgetsFlutterBinding.ensureInitialized();

  // cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: "Futura",
          primaryColor: Colors.green,
          accentColor: Color.fromRGBO(19, 30, 52, 1),
        ),
        home: box1.get('isLogged', defaultValue: false)
            ? HomeScreen()
            : Login_Page());
  }
}
