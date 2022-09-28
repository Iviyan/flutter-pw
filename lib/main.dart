import 'package:flutter/material.dart';
import 'package:pw/meditate_screen.dart';
import 'package:pw/meditate2_screen.dart';
import 'package:pw/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Plus Jakarta Sans"
      ),
      home: PageView(
        children: const [
          MeditateScreen(),
          Meditate2Screen(),
          WelcomeScreen(),
        ]
      )
    );
  }
}