import 'package:elifbauygulamasi/KullaniciScreens/resimeslestirme.dart';
import 'package:elifbauygulamasi/LoginScreens/login_page.dart';
import 'package:elifbauygulamasi/models/letter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Letter letter = Letter(imagePath: "");
    return MaterialApp(
      title: "LOGİN",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
