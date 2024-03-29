import 'package:elifbauygulamasi/KullaniciScreens/oyun/bitisikoyun.dart';
import 'package:elifbauygulamasi/KullaniciScreens/oyun/resimeslestirme.dart';
import 'package:elifbauygulamasi/KullaniciScreens/oyun/resimeslestirmeiki.dart';
import 'package:elifbauygulamasi/KullaniciScreens/oyun/resimeslestirmeuc.dart';
import 'package:elifbauygulamasi/KullaniciScreens/oyun/soruoyunu.dart';
import 'package:elifbauygulamasi/models/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import '../LoginScreens/login_page.dart';
import '../data/dbHelper.dart';
import '../data/googlesign.dart';
import '../hakkimizdaiki.dart';
import '../models/Log.dart';
import '../models/letter.dart';
import '../models/user.dart';
import 'package:elifbauygulamasi/KullaniciScreens/dersmenü.dart';
import 'ayarlar.dart';
import 'home.dart';
import 'package:intl/intl.dart';

class OyunSinifi extends StatefulWidget {
  OyunSinifi({
    Key? key,
    required this.user,
    required this.game,
    required this.letter,
    required this.name,
    required this.email,
    required this.lastname,
    required this.username,
  }) : super(key: key);
  User user;
  Letter letter;
  final name;
  final username;
  final lastname;
  final email;
  Game game;

  @override
  State<OyunSinifi> createState() => _OyunSinifiState();
}

class _OyunSinifiState extends State<OyunSinifi> {
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  final _advancedDrawerController = AdvancedDrawerController();
  late AudioPlayer _audioPlayer;
  var dbHelper = DbHelper();
  final log = Log();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    user: widget.user,
                    letter: widget.letter,
                    name: widget.name,
                    username: widget.username,
                    lastname: widget.lastname,
                    email: widget.email,
                    game: widget.game,
                  )),
          (route) => false,
        );
        return false; // Geri tuşu işleme alınmadı
      },
      child: AdvancedDrawer(
        backdropColor: Color(0xffad80ea),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 0.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Harfler",
                style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900)),
            backgroundColor: Color(0xFF975FD0),
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ),
          ),
          body: Container(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/renkli.jpg"),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.darken),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: birinciOyun(),
                    right: 120,
                    top: 20,
                  ),
                  Positioned(
                    child: ikinciOyun(),
                    right: 10,
                    top: 90,
                  ),
                  Positioned(
                    child: ucuncuOyun(),
                    left: 130,
                    top: 160,
                  ),
                  Positioned(
                    child: dorduncuOyun(),
                    right: 10,
                    top: 230,
                  ),
                  Positioned(
                    child: besinciOyun(),
                    right: 120,
                    top: 300,
                  ),
                  Positioned(
                    child: altinciOyun(),
                    right: 10,
                    top: 370,
                  ),
                  Positioned(
                    child: yedinciOyun(),
                    left: 130,
                    top: 440,
                  ),
                  Positioned(
                    child: sekizinciOyun(),
                    right: 10,
                    top: 510,
                  ),
                  Positioned(
                    child: dokuzuncuOyun(),
                    right: 120,
                    top: 590,
                  ),
                  Positioned(
                    child: onuncuOyun(),
                    right: 10,
                    top: 650,
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: SafeArea(
          child: Container(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 300.0,
                    height: 200.0,
                    margin: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 64.0,
                      right: 10,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/resim/Elif-Baa.png'),
                        fit: BoxFit.cover,
                      ),
                      //color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    user: widget.user,
                                    letter: letter,
                                    name: widget.name,
                                    username: widget.username,
                                    lastname: widget.lastname,
                                    email: widget.email,
                                    game: widget.game,
                                  ))).then((value) => Navigator.pop(context));
                    },
                    leading: Icon(Icons.home),
                    title: Text(
                      'Ana Sayfa',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dersler(
                                    user: widget.user,
                                    letter: widget.letter,
                                    name: widget.name,
                                    username: widget.username,
                                    lastname: widget.lastname,
                                    email: widget.email,
                                    game: widget.game,
                                  ))).then((value) => Navigator.pop(context));
                    },
                    leading: Icon(Icons.play_lesson),
                    title: Text(
                      'Dersler',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OyunSinifi(
                                    name: widget.name,
                                    user: widget.user,
                                    letter: widget.letter,
                                    username: widget.username,
                                    lastname: widget.lastname,
                                    email: widget.email,
                                    game: widget.game,
                                  )));
                    },
                    leading: Icon(Icons.extension),
                    title: Text(
                      'Alıştırmalar',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AyarlarPage(
                                    letter: letter,
                                    user: widget.user,
                                    name: widget.name,
                                    username: widget.username,
                                    lastname: widget.lastname,
                                    email: widget.email,
                                    game: widget.game,
                                  )));
                    },
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Ayarlar',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _showResendDialogg();
                    },
                    leading: Icon(Icons.power_settings_new),
                    title: Text(
                      'Çıkış Yap',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Spacer(),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Hakkimizdaiki(

                              )),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        child: Text(
                          'Hizmet Şartları | Gizlilik Politikası',
                          style: GoogleFonts.comicNeue(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Game? game;
  int? deneme;
  Color? butonRenk1;
  Color? butonRenk2;
  Color? butonRenk3;
  Color? butonRenk4;
  Color? butonRenk5;

  Future<int?> getGame(String temp) async {
    final result =
        await dbHelper.getGameStatusByUserIdAndLevel(widget.user.id!, temp);
    return result;
  }

  Future<void> updateButtonColors() async {
    butonRenk1 = await changeColor("1");
    butonRenk2 = await changeColor("2");
    butonRenk3 = await changeColor("3");
    butonRenk4 = await changeColor("4");
    butonRenk5 = await changeColor("5");
    setState(() {}); // Rebuild the widget tree to reflect the new colors
  }

  Future<Color?> changeColor(String x) async {
    Color? butonRenk;
    int? temp;
    temp = await dbHelper.getGameStatusByUserIdAndLevel(widget.user.id!, x);
    print("temp" + "${temp}");
    if (temp == null) {
      butonRenk = Color(0xFFD399EA);
    } else {
      if (temp == 0) {
        butonRenk = Color(0xFFD399EA);
      } else if (temp == 1) {
        butonRenk = Colors.blue;
      } else if (temp == 2) {
        butonRenk = Colors.green;
      } else {
        butonRenk = Color(0xFFD399EA);
      }
    }
    return butonRenk;
  }

  @override
  void initState() {
    updateButtonColors();
    super.initState();
  }

  Widget birinciOyun() {
    return FutureBuilder<Color?>(
      future: changeColor("1"),
      builder: (BuildContext context, AsyncSnapshot<Color?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for the color
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          butonRenk1 = snapshot.data;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 120),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: butonRenk1,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    String formattedDateTime =
                        DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
                    List<Log> logList = await dbHelper.getLogusername(widget.user.username!);
                    if (logList.isNotEmpty) {
                      Log existingLog = logList.first;
                      existingLog.durum = 1;
                      existingLog.cikisTarih;
                      existingLog.girisTarih;
                      existingLog.yapilanIslemoyun = "1.Seviye oyun";
                      await dbHelper.updateLog(existingLog);
                    }
                    updateButtonColors();
                    Game updatedGame = Game(
                      seviyeKilit: 1,
                      durum: 1,
                      kullaniciId: widget.user.id,
                      level:
                          "1", // Provide the appropriate value for the level field
                    );
                    dbHelper.updateGame1(updatedGame, "1");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResimEslestirmeiki(
                          user: widget.user,
                          letter: letter,
                          name: widget.name,
                          username: widget.username,
                          lastname: widget.lastname,
                          email: widget.email,
                          game: widget.game,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1. Seviye',
                        style: GoogleFonts.comicNeue(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget ikinciOyun() {
    return FutureBuilder<Color?>(
      future: changeColor("2"),
      builder: (BuildContext context, AsyncSnapshot<Color?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for the color
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 120),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: butonRenk2,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    String formattedDateTime =
                        DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
                    List<Log> logList = await dbHelper.getLogusername(widget.user.username!);
                    if (logList.isNotEmpty) {
                      Log existingLog = logList.first;
                      existingLog.durum = 1;
                      existingLog.cikisTarih;
                      existingLog.girisTarih;
                      existingLog.yapilanIslemoyun = "2.Seviye oyun";
                      await dbHelper.updateLog(existingLog);
                    }
                    updateButtonColors();
                    Game updatedGame = Game(
                      seviyeKilit: 1,
                      durum: 1,
                      kullaniciId: widget.user.id,
                      level: "2",
                    );
                    await dbHelper.updateGame1(updatedGame, "2");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResimEslestirmeuc(
                          user: widget.user,
                          letter: letter,
                          name: widget.name,
                          username: widget.username,
                          lastname: widget.lastname,
                          email: widget.email,
                          game: widget.game,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '2. Seviye',
                        style: GoogleFonts.comicNeue(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget ucuncuOyun() {
    return FutureBuilder<Color?>(
      future: changeColor("3"),
      builder: (BuildContext context, AsyncSnapshot<Color?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for the color
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 120),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: butonRenk3,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    String formattedDateTime =
                        DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
                    List<Log> logList = await dbHelper.getLogusername(widget.user.username!);
                    if (logList.isNotEmpty) {
                      Log existingLog = logList.first;
                      existingLog.durum = 1;
                      existingLog.cikisTarih;
                      existingLog.girisTarih;
                      existingLog.yapilanIslemoyun = "3.Seviye oyun";
                      await dbHelper.updateLog(existingLog);
                    }
                    Game updatedGame = Game(
                      seviyeKilit: 0,
                      durum: 1,
                      kullaniciId: widget.user.id,
                      level: "3",
                    );
                    dbHelper.updateGame1(updatedGame, "3");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResimEslestirme(
                          user: widget.user,
                          letter: letter,
                          name: widget.name,
                          username: widget.username,
                          lastname: widget.lastname,
                          email: widget.email,
                          game: widget.game,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '3. Seviye',
                        style: GoogleFonts.comicNeue(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget dorduncuOyun() {
    return FutureBuilder<Color?>(
      future: changeColor("4"),
      builder: (BuildContext context, AsyncSnapshot<Color?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for the color
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 120),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: butonRenk4,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    String formattedDateTime =
                        DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
                    List<Log> logList = await dbHelper.getLogusername(widget.user.username!);
                    if (logList.isNotEmpty) {
                      Log existingLog = logList.first;
                      existingLog.durum = 1;
                      existingLog.cikisTarih;
                      existingLog.girisTarih;
                      existingLog.yapilanIslemoyun = "4.Seviye oyun";
                      await dbHelper.updateLog(existingLog);
                    }
                    Game updatedGame = Game(
                      seviyeKilit: 0,
                      durum: 1,
                      kullaniciId: widget.user.id,
                      level:
                          "4", // Provide the appropriate value for the level field
                    );
                    dbHelper.updateGame1(updatedGame, "4");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SoruOyunu(
                                  user: widget.user,
                                  letter: widget.letter,
                                  name: widget.name,
                                  username: widget.username,
                                  lastname: widget.lastname,
                                  email: widget.email,
                                  game: widget.game,
                                ))).then((value) => Navigator.pop(context));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '4. Seviye',
                        style: GoogleFonts.comicNeue(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget besinciOyun() {
    return FutureBuilder<Color?>(
      future: changeColor("5"),
      builder: (BuildContext context, AsyncSnapshot<Color?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for the color
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 120),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: butonRenk5,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    String formattedDateTime =
                        DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
                    List<Log> logList = await dbHelper.getLogusername(widget.user.username!);
                    if (logList.isNotEmpty) {
                      Log existingLog = logList.first;
                      existingLog.durum = 1;
                      existingLog.cikisTarih;
                      existingLog.girisTarih;
                      existingLog.yapilanIslemoyun = "5.Seviye oyun";
                      await dbHelper.updateLog(existingLog);
                    }
                    Game updatedGame = Game(
                      seviyeKilit: 0,
                      durum: 1,
                      kullaniciId: widget.user.id,
                      level:
                          "5", // Provide the appropriate value for the level field
                    );
                    dbHelper.updateGame1(updatedGame, "5");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BitisikOyun(
                                  user: widget.user,
                                  letter: widget.letter,
                                  name: widget.name,
                                  username: widget.username,
                                  lastname: widget.lastname,
                                  email: widget.email,
                                  game: widget.game,
                                ))).then((value) => Navigator.pop(context));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '5. Seviye',
                        style: GoogleFonts.comicNeue(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget altinciOyun() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 120),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFD399EA),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              _yakindaSizinle();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '6. Seviye',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget yedinciOyun() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 120),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFD399EA),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              _yakindaSizinle();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '7. Seviye',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sekizinciOyun() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 120),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFD399EA),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              _yakindaSizinle();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '8. Seviye',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dokuzuncuOyun() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 120),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFD399EA),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              _yakindaSizinle();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '9. Seviye',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget onuncuOyun() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 120),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFD399EA),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              _yakindaSizinle();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '10. Seviye',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showResendDialogg() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.lightBlueAccent,
            width: 2,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Güvenli Çıkış Yapın!',
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 24),
              Divider(
                color: Colors.white,
                thickness: 2,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'Hayır',
                      style: GoogleFonts.comicNeue(
                        fontWeight: FontWeight.w600,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      String formattedDateTime =
                          DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
                      List<Log> logList = await dbHelper.getLogusername(widget.user.username!);
                      if (logList.isNotEmpty) {
                        Log existingLog = logList.first;
                        existingLog.durum = 0;
                        existingLog.cikisTarih = formattedDateTime;
                        existingLog.girisTarih;
                        existingLog.yapilanIslem="Çıkış";
                        await dbHelper.updateLog(existingLog);
                      }
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(
                                    user: widget.user,
                                    game: widget.game,
                                    log: log,
                                  )),
                          (route) => false);
                      logOut();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Evet',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _yakindaSizinle() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.lightBlueAccent,
            width: 2,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Çok Yakında...',
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 24),
              Divider(
                color: Colors.white,
                thickness: 2,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Tamam',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  void logOut() {
    if (GoogleSignInApi != null) {
      GoogleSignInApi.logout();
    }
    dbHelper.getCurrentUser().then((currentUser) {
      if (currentUser != null) {
        dbHelper.updateUserhesapById(widget.user.id!, 0).then((_) {
          setState(() {});
        });
      } else {
        setState(() {});
      }
    });
  }
}
