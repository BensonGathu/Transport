import 'package:flutter/material.dart';
import 'package:transportapp/responsive/mobile_screen_layout.dart';
import 'package:transportapp/screens/homepage.dart';
import 'package:transportapp/screens/mainpage.dart';

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
      home:  MobileScreenLayout(),
    );
  }
}
