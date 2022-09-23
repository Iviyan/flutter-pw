import 'package:flutter/material.dart';
import 'package:pw/screen2.dart';
import 'package:pw/screen3.dart';
import 'package:pw/screen4.dart';

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
          Screen2(),
          Screen3(),
          Screen4(),
        ]
      )
    );
  }
}