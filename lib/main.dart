// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ocr/authentication/authentication.dart';
import 'package:ocr/authentication/login_data.dart';
import 'package:ocr/components/scaner.dart';
import 'package:ocr/home/home_page.dart';
import 'package:ocr/pages/image_to_doc.dart';
import 'package:ocr/pages/image_to_text.dart';
import 'package:ocr/pages/pdf_to_doc.dart';
import 'package:ocr/pages/pdf_to_image.dart';
import 'package:ocr/pages/table_Extraction.dart';
import 'package:ocr/testhome/testhome.dart';
import 'package:ocr/theme/light_mode.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // hive data call in app start

  await Hive.initFlutter();
  Hive.registerAdapter(LoginDataAdapter());
  await Hive.openBox<LoginData>('loginDataBOX');

  final box = Hive.box<LoginData>('loginDataBOX');
  final loggedInUser = box.get('currentUser');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<LoginData>('loginDataBOX');
    final loggedInUser = box.get('currentUser');

    return MaterialApp(
      title: 'RAN',
      home: loggedInUser != null ? HomePage() : Authentication(),
      theme: lightMode,
    );
  }
}
