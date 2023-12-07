import 'package:flutter/material.dart';
import 'login_view.dart';
import 'signup_view.dart';
// import 'home.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Home(),
      home: LoginPage(),
    );
  }
}