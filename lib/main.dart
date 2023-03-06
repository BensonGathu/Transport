import 'package:flutter/material.dart';
import 'package:transportapp/responsive/mobile_screen_layout.dart';
import 'package:transportapp/screens/homepage.dart';
import 'package:transportapp/screens/logInScreen.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:transportapp/screens/testMap2.dart';

import 'package:transportapp/screens/testMaps.dart';


void main() {
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
     
        primarySwatch: Colors.blue,
      ),

      home: LoginScreen(),

    );
  }
}

