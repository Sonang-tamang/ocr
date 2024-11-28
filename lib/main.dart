// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ocr/authentication/authentication.dart';
import 'package:ocr/home/home_page.dart';
import 'package:ocr/pages/image_to_doc.dart';
import 'package:ocr/pages/image_to_text.dart';
import 'package:ocr/pages/pdf_to_doc.dart';
import 'package:ocr/pages/pdf_to_image.dart';
import 'package:ocr/testhome/testhome.dart';
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
      home: ImageToText(),
      theme: lightMode,
    );
  }
}
