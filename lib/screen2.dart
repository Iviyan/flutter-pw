import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
        Text(text)
      ),
    );
  }
}