import 'package:elifbauygulamasi/KullaniciScreens/dersler/bitisik.dart';
import 'package:elifbauygulamasi/KullaniciScreens/dersler/harfler.dart';
import 'package:elifbauygulamasi/KullaniciScreens/dersler/yazilis.dart';
import 'package:elifbauygulamasi/KullaniciScreens/ayarlar.dart';
import 'package:elifbauygulamasi/KullaniciScreens/oyunmen%C3%BC.dart';
import 'package:elifbauygulamasi/models/bitisik.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../LoginScreens/login_page.dart';
import '../data/dbHelper.dart';
import '../data/googlesign.dart';
import '../hakkimizdaiki.dart';
import '../models/Log.dart';
import '../models/game.dart';
import '../models/letter.dart';
import '../models/user.dart';
import 'dersler/esre.dart';
import 'dersler/otre.dart';
import 'dersler/ustun.dart';
import 'home.dart';
import 'package:intl/intl.dart';

class Dersler extends StatefulWidget {
  Dersler(
      {Key? key,
      required this.user,
      required this.game,
      required this.letter,
      required this.name,
      required this.email,
      required this.lastname,
      required this.username})
      : super(key: key);
  User user;
  Letter letter;
  Game game;
  final name;
  final username;
  final lastname;
  final email;

  @override
  State<Dersler> createState() => _DerslerState();
}

class _DerslerState extends State<Dersler> {
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  final _advancedDrawerController = AdvancedDrawerController();
  final log = Log();
  var dbhelper = DbHelper();

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
                    game: widget.game,
                    email: widget.email,
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
            title: Text("Dersler",
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
                  image: AssetImage("assets/images/home.jpg"),
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5), BlendMode.darken),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: _title(),
                    top: 40,
                    left: 30,
                    right: 30,
                  ),
                  Positioned(
                    child: birinciDers(),
                    top: 200,
                    left: 90,
                  ),
                  Positioned(
                    child: ikinciDers(),
                    top: 270,
                    left: 90,
                  ),
                  Positioned(
                    child: ucuncuDers(),
                    top: 340,
                    left: 90,
                  ),
                  Positioned(
                    child: dorduncuDers(),
                    top: 410,
                    left: 90,
                  ),
                  Positioned(
                    child: besinciDers(),
                    top: 480,
                    left: 90,
                  ),
                  Positioned(
                    child: altinciDers(),
                    top: 550,
                    left: 90,
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
                                    letter: widget.letter,
                                    name: widget.user,
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
                                    user: widget.user,
                                    letter: widget.letter,
                                    name: widget.name,
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
                                    letter: widget.letter,
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

  Widget birinciDers() {
    return Container(
      width: 230,
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffbea1ea),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              DateTime now = DateTime.now();
              String formattedDateTime =
              DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
              List<Log> logList = await dbhelper.getLogusername(widget.user.username!);
              if (logList.isNotEmpty) {
                Log existingLog = logList.first;
                existingLog.durum = 1;
                existingLog.cikisTarih;
                existingLog.girisTarih;
                existingLog.yapilanIslemders = "1.Ders";
                await dbhelper.updateLog(existingLog);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => kullaniciHarfler(
                            letter: letter,
                            user: widget.user,
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
                  '1.Ders:',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ' Harfler',
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

  Widget ikinciDers() {
    return Container(
      width: 230,
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffbea1ea),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              DateTime now = DateTime.now();
              String formattedDateTime =
              DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
              List<Log> logList = await dbhelper.getLogusername(widget.user.username!);
              if (logList.isNotEmpty) {
                Log existingLog = logList.first;
                existingLog.durum = 1;
                existingLog.cikisTarih;
                existingLog.girisTarih;
                existingLog.yapilanIslemders = "2.Ders";
                await dbhelper.updateLog(existingLog);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => kullaniciHarflerustun(
                            letter: letter,
                            user: widget.user,
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
                  '2.Ders:',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ' Üstün',
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

  Widget ucuncuDers() {
    return Container(
      width: 230,
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffbea1ea),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              DateTime now = DateTime.now();
              String formattedDateTime =
              DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
              List<Log> logList = await dbhelper.getLogusername(widget.user.username!);
              if (logList.isNotEmpty) {
                Log existingLog = logList.first;
                existingLog.durum = 1;
                existingLog.cikisTarih;
                existingLog.girisTarih;
                existingLog.yapilanIslemders = "3.Ders";
                await dbhelper.updateLog(existingLog);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => kullaniciHarfleresre(
                            letter: letter,
                            user: widget.user,
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
                  '3.Ders:',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ' Esre',
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

  Widget dorduncuDers() {
    return Container(
      width: 230,
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffbea1ea),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              DateTime now = DateTime.now();
              String formattedDateTime =
              DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
              List<Log> logList = await dbhelper.getLogusername(widget.user.username!);
              if (logList.isNotEmpty) {
                Log existingLog = logList.first;
                existingLog.durum = 1;
                existingLog.cikisTarih;
                existingLog.girisTarih;
                existingLog.yapilanIslemders = "4.Ders";
                await dbhelper.updateLog(existingLog);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => kullaniciHarflerotre(
                            letter: letter,
                            user: widget.user,
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
                  '4.Ders:',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ' Ötre',
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

  Widget besinciDers() {
    return Container(
      width: 230,
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffbea1ea),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              DateTime now = DateTime.now();
              String formattedDateTime =
              DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
              List<Log> logList = await dbhelper.getLogusername(widget.user.username!);
              if (logList.isNotEmpty) {
                Log existingLog = logList.first;
                existingLog.durum = 1;
                existingLog.cikisTarih;
                existingLog.girisTarih;
                existingLog.yapilanIslemders = "5.Ders";
                await dbhelper.updateLog(existingLog);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => kullaniciHarfleryazilis(
                            letter: letter,
                            user: widget.user,
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
                  '5.Ders:',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ' Harflerin Yazılışı',
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

  Widget altinciDers() {
    return Container(
      width: 230,
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffbea1ea),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              DateTime now = DateTime.now();
              String formattedDateTime =
              DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
              List<Log> logList = await dbhelper.getLogusername(widget.user.username!);
              if (logList.isNotEmpty) {
                Log existingLog = logList.first;
                existingLog.durum = 1;
                existingLog.cikisTarih;
                existingLog.girisTarih;
                existingLog.yapilanIslemders = "6.Ders";
                await dbhelper.updateLog(existingLog);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BitisikDers(
                            letter: letter,
                            user: widget.user,
                            name: widget.name,
                            harf: harf,
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
                  '6.Ders:',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ' Bitişik Harfler',
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

  var harf = BitisikHarfler();

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'HADİ ',
          style: GoogleFonts.comicNeue(
            fontSize: 38,
            fontWeight: FontWeight.w900,
            color: Color(0xff935ccf),
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: Colors.grey,
                offset: Offset(3.0, 3.0),
              ),
            ],
          ),
          children: [
            TextSpan(
              text: 'ÖĞRENMEYE',
              style: GoogleFonts.comicNeue(
                color: Color(0xff935ccf),
                fontSize: 38,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.grey,
                    offset: Offset(3.0, 3.0),
                  ),
                ],
              ),
            ),
            TextSpan(
              text: 'BAŞLAYALIM',
              style: GoogleFonts.comicNeue(
                color: Color(0xff935ccf),
                fontSize: 38,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.grey,
                    offset: Offset(3.0, 3.0),
                  ),
                ],
              ),
            ),
          ]),
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
                      List<Log> logList = await dbhelper.getLogusername(widget.user.username!);
                      if (logList.isNotEmpty) {
                        Log existingLog = logList.first;
                        existingLog.durum = 0;
                        existingLog.cikisTarih = formattedDateTime;
                        existingLog.girisTarih;
                        existingLog.yapilanIslem="Çıkış";
                        await dbhelper.updateLog(existingLog);
                      }
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(
                                    user: widget.user,
                                    game: widget.game,log: log,
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

  void _handleMenuButtonPressed() {
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void logOut() {
    if (GoogleSignInApi != null) {
      GoogleSignInApi.logout();
    }
    dbhelper.getCurrentUser().then((currentUser) {
      if (currentUser != null) {
        dbhelper.updateUserhesapById(widget.user.id!, 0).then((_) {
          setState(() {});
        });
      } else {
        setState(() {});
      }
    });
  }
}
