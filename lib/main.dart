// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ocr/home/home_page.dart';
import 'package:ocr/theme/light_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAN',
      home: HomePage(),
      theme: lightMode,
    );
  }
}
