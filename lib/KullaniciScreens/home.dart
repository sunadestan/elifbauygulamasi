import 'package:elifbauygulamasi/KullaniciScreens/ayarlar.dart';
import 'package:elifbauygulamasi/KullaniciScreens/dersmenü.dart';
import 'package:elifbauygulamasi/KullaniciScreens/oyunmenü.dart';
import 'package:elifbauygulamasi/data/googlesign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../LoginScreens/login_page.dart';
import '../data/dbHelper.dart';
import '../models/Log.dart';
import '../models/game.dart';
import '../models/letter.dart';
import '../models/user.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key? key,
      required this.user,
      required this.letter,
      required this.game,
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
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _advancedDrawerController = AdvancedDrawerController();
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  var dbhelper = DbHelper();
  final log = Log();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await _showResendDialog();
        return exit;
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
          key: _scaffoldKey,
          appBar: AppBar(
            key: _formKey,
            backgroundColor: Color(0xFF975FD0),
            title: Text(
              'Merhaba' + "  " + '${widget.user.name}',
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
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
                  image: AssetImage("assets/images/homee.jpg"),
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5), BlendMode.darken),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: _title(),
                    top: 20,
                    left: 30,
                    right: 30,
                  ),
                  Positioned(
                    child: not(),
                    top: 100,
                    left: 30,
                    right: 30,
                  ),
                  Positioned(
                    child: birinciListe(),
                    top: 360,
                    left: 100,
                  ),
                  Positioned(
                    child: ikinciListe(),
                    top: 430,
                    left: 100,
                  ),
                  Positioned(
                    child: dorduncuListe(),
                    top: 500,
                    left: 100,
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
                                  ))).then((value) => Navigator.pop(context));
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
                                  ))).then((value) => Navigator.pop(context));
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
                      _showResendDialog();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    print(widget.user.id);
    super.initState();
  }

  Widget not() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      decoration: BoxDecoration(
        //color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [Color(0xffbea1ea), Color(0xffad80ea)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              textAlign: TextAlign.center,
              'Hoş Geldin ' + (widget.name) + (widget.user.name),
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              textAlign: TextAlign.center,
              'Bu uygulama ile Kuran harflerini öğrenirken çok eğleneceksin! '
              'Harfleri öğrenmek için derslere girebilir, oyunlar oynayabilir, eşleştirme yapabilir veya sorular çözebilirsin.',
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              textAlign: TextAlign.center,
              'Hadi Başlayalım...',
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget birinciListe() {
    return Container(
      width: 200,
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
            onPressed: () {
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
                        )),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dersler',
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

  Widget ikinciListe() {
    return Container(
      width: 200,
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
              bool gameExists = await dbhelper.checkGameExists(widget.user.id!);
              if (!gameExists) {
                await dbhelper.insertGame(Game(
                    seviyeKilit: 1,
                    durum: 0,
                    level: "1",
                    kullaniciId: widget.user.id));
                await dbhelper.insertGame(Game(
                    seviyeKilit: 0,
                    durum: 0,
                    level: "2",
                    kullaniciId: widget.user.id));
                await dbhelper.insertGame(Game(
                    seviyeKilit: 0,
                    durum: 0,
                    level: "3",
                    kullaniciId: widget.user.id));
                await dbhelper.insertGame(Game(
                    seviyeKilit: 0,
                    durum: 0,
                    level: "4",
                    kullaniciId: widget.user.id));
                await dbhelper.insertGame(Game(
                    seviyeKilit: 0,
                    durum: 0,
                    level: "5",
                    kullaniciId: widget.user.id));
              }
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
                        )),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Alıştırmalar',
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

  Widget ucuncuListe() {
    return Container(
      width: 200,
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
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sureler',
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

  Widget dorduncuListe() {
    return Container(
      width: 200,
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AyarlarPage(
                          user: widget.user,
                          letter: widget.letter,
                          name: widget.name,
                          username: widget.username,
                          lastname: widget.lastname,
                          email: widget.email,
                          game: widget.game,
                        )),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ayarlar',
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

  Widget kutu(Widget child) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Color(0xffbea1ea),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[child],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  Widget resim() {
    var f = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(
        top: 110,
      ),
      //padding: EdgeInsets.symmetric(vertical: 150, horizontal: 10),
      height: f * .35,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage("assets/images/kurann.png")),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Elif',
          style: GoogleFonts.comicNeue(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Color(0xff935ccf),
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: Colors.grey,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
          children: [
            TextSpan(
              text: '-',
              style: GoogleFonts.comicNeue(
                color: Color(0xffad80ea),
                fontSize: 40,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.grey,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            TextSpan(
              text: 'Ba',
              style: GoogleFonts.comicNeue(
                color: Color(0xff935ccf),
                fontSize: 40,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.grey,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Widget customSizedBox() => SizedBox(
        height: 20,
      );

  Future _showResendDialog() {
    return showDialog(
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
                      List<Log> logList = await dbhelper.getLog();
                      if (logList.isNotEmpty) {
                        Log existingLog = logList.first;
                        existingLog.durum = 0;
                        existingLog.cikisTarih = formattedDateTime;
                        existingLog.girisTarih;
                        await dbhelper.updateLog(existingLog);
                        print(existingLog);
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

  void logOut() {
    setState(() {
      if (GoogleSignInApi != null) {
        GoogleSignInApi.logout();
      }
    });
  }
}
