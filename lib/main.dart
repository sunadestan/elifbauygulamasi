import 'package:elifbauygulamasi/models/user.dart';
import 'package:flutter/material.dart';
import 'LoginScreens/login_page.dart';
import 'models/letter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Letter letter = Letter(imagePath: "");
    User user =User("", "", "", "", "", "", "", isadmin: 0);
    return MaterialApp(
      title: "LOGİN",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}