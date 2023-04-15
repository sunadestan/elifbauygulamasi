import 'package:elifbauygulamasi/LoginScreens/login_page.dart';
import 'package:elifbauygulamasi/models/letter.dart';
import 'package:elifbauygulamasi/models/user.dart';
import 'package:flutter/material.dart';

import 'KullaniciScreens/oyun/ses.dart';
import 'KullaniciScreens/oyun/sesleeslestirme.dart';
import 'KullaniciScreens/oyun/soruoyunu.dart';
import 'deneme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Letter letter = Letter(imagePath: "");
    User user =User("", "", "", "", "", "", "", isadmin: 0);
    var deneme;
    String temp="d";
    return MaterialApp(
      title: "LOGİN",
      debugShowCheckedModeBanner: false,
      home: SoruSayfasi(),

    );
  }
}
