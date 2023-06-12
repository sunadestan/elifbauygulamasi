import 'package:elifbauygulamasi/AdminScreens/admin.dart';
import 'package:elifbauygulamasi/KullaniciScreens/home.dart';
import 'package:elifbauygulamasi/data/dbHelper.dart';
import 'package:elifbauygulamasi/models/Log.dart';
import 'package:elifbauygulamasi/models/user.dart';
import 'package:flutter/material.dart';
import 'LoginScreens/login_page.dart';
import 'models/game.dart';
import 'models/letter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  var dbHelper = DbHelper();
  Widget kontrolet(BuildContext context) {
    Letter letter = Letter(imagePath: "");
    var user = dbHelper.autoLoginCompany();
    var userr =User(hesapAcik: 0,isVerified: 0,isadmin: 0,);
    var game = Game(durum: 0, kullaniciId: 0, seviyeKilit: 0);
    var log = Log();
    return FutureBuilder(
      future: Future.wait([
        dbHelper.autoLoginCompany(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> _snapshot) {
        if (_snapshot.hasData) {
          final user = _snapshot.data![0] as User?;
          if (user != null) {
            if (user.email!.endsWith("@elifba.com") && user.hesapAcik == 1) {
              return AdminPage(user: user, deneme: 1, denemeiki: 1, log: log);
            } else {
              return HomePage(
                username: user.username,
                user: user,
                letter: letter,
                game: game,
                name: user.name,
                email: user.email,
                lastname: user.lastname,
              );
            }
          }
        }

        return LoginPage(user: userr, game: game, log: log);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LOGİN",
      debugShowCheckedModeBanner: false,
      home: kontrolet(context),
    );
  }
}
