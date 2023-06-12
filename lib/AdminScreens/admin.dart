import 'package:elifbauygulamasi/LoginScreens/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/dbHelper.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../hakkimizda.dart';
import '../models/Log.dart';
import '../models/game.dart';
import 'harfeklememenü.dart';
import 'listemenü.dart';
import 'log.dart';

class AdminPage extends StatefulWidget {
  AdminPage(
      {Key? key,
      required this.user,
      required this.deneme,
      required this.denemeiki,
      required this.log})
      : super(key: key);
  final user;
  Log log;
  final int deneme;
  final int denemeiki;

  @override
  State<AdminPage> createState() => _AdminState();
}

class _AdminState extends State<AdminPage> {
  var dbHelper = DbHelper();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _advancedDrawerController = AdvancedDrawerController();
  final game = Game(durum: 0, kullaniciId: 0, seviyeKilit: 0);

  /*0xFFA07BC9*/
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
              'Hoş geldin' +
                  "  " +
                  '${widget.user.name} ${widget.user.lastname}',
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
                    child: birinciListe(),
                    top: 200,
                    left: 100,
                  ),
                  Positioned(
                    child: ikinciListe(),
                    top: 270,
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
                            builder: (context) => ListeMenu(
                                  log: widget.log,
                                  user: widget.user,
                                  deneme: widget.deneme,
                                  denemeiki: widget.denemeiki,
                                )),
                      );
                    },
                    leading: Icon(Icons.list),
                    title: Text(
                      'Harfleri Listele',
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
                            builder: (context) => HarfeklemeMenu(
                                  log: widget.log,
                                  denemeiki: widget.denemeiki,
                                  user: widget.user,
                                  deneme: widget.deneme,
                                )),
                      );
                    },
                    leading: Icon(Icons.add),
                    title: Text(
                      'Harf Ekle',
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
                            builder: (context) => LogGiris(
                                  user: widget.user,
                                  deneme: widget.deneme,
                                  denemeiki: widget.denemeiki,
                                  log: widget.log,
                                )),
                      );
                    },
                    leading: Icon(Icons.verified_user_outlined),
                    title: Text(
                      'Giriş Bilgileri',
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Hakkimizda()),
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
                    builder: (context) => ListeMenu(
                          user: widget.user,
                          deneme: widget.deneme,
                          denemeiki: widget.denemeiki,
                          log: widget.log,
                        )),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Harfleri Listele',
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HarfeklemeMenu(
                        user: widget.user,
                        deneme: widget.deneme,
                        log: widget.log,
                        denemeiki: widget.denemeiki)),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' Harf Ekle',
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
                    onPressed: () {
                      dbHelper.getCurrentUser().then((currentUser) {
                        if (currentUser != null) {
                          dbHelper
                              .updateUserhesapById(widget.user.id!, 0)
                              .then((_) {
                            setState(() {});
                          });
                        } else {
                          setState(() {});
                        }
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(
                                    game: game,
                                    user: widget.user,
                                    log: widget.log,
                                  )),
                          (route) => false);
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
}
