import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elifbauygulamasi/AdminScreens/admin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../LoginScreens/login_page.dart';
import '../data/dbHelper.dart';
import '../hakkimizda.dart';
import '../models/Log.dart';
import '../models/game.dart';
import '../models/letter.dart';
import '../models/user.dart';
import 'harfeklememenü.dart';
import 'listemenü.dart';

class LogGiris extends StatefulWidget {
  LogGiris(
      {Key? key,
      required this.user,
      required this.deneme,
      required this.denemeiki,
      required this.log})
      : super(key: key);
  User user;
  final int deneme;
  final int denemeiki;
  Log log;
  @override
  State<LogGiris> createState() => _LogState();
}

class _LogState extends State<LogGiris> {
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  final game = Game(durum: 0, kullaniciId: 0, seviyeKilit: 0);
  final _advancedDrawerController = AdvancedDrawerController();
  var dbHelper = DbHelper();
  late Future<List<Log>> _logFuture;

  @override
  void initState() {
    super.initState();
    _logFuture = liste();
  }

  Future<List<Log>> liste() async {
    final result = await dbHelper.getLog();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => AdminPage(
                    user: widget.user,
                    deneme: widget.deneme,
                    denemeiki: widget.denemeiki,
                    log: widget.log,
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
            title: Text("Giriş Bilgileri",
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
                  /*image: DecorationImage(
                  image: AssetImage("assets/images/home.jpg"),
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5), BlendMode.darken),
                  fit: BoxFit.cover,
                ),*/
                  ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: FutureBuilder<List<Log>>(
                      future: _logFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final log = snapshot.data;
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            //height: double.infinity,
                            //width: double.infinity,
                            child: GridView.count(
                              crossAxisCount: 1,
                              childAspectRatio: 2,
                              shrinkWrap: true,
                              children: List.generate(
                                log!.length,
                                (index) => card(log[index]),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Hata: ${snapshot.error}'),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
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
                            builder: (context) => AdminPage(
                                user: widget.user,
                                deneme: widget.deneme,
                                log: widget.log,
                                denemeiki: widget.denemeiki)),
                      );
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
                            builder: (context) => ListeMenu(
                                  user: widget.user,
                                  deneme: widget.deneme,
                                  denemeiki: widget.denemeiki,
                                  log: widget.log,
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
                                  user: widget.user,
                                  deneme: widget.deneme,
                                  log: widget.log,
                                  denemeiki: widget.denemeiki,
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

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'HARFLERİ ',
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
              text: 'LİSTELE',
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

  Widget card(Log log) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffbea1ea),
      ),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // Adjust content padding as needed
          leading: Icon(
            log.durum != 0 ? Icons.check_circle : Icons.remove_circle,
            color: log.durum != 0 ? Colors.green : Colors.red,
          ),
          title: Text('ID: ${log.id}',style: GoogleFonts.comicNeue(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ad: ${log.name}',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Soyad: ${log.lastname}',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Kullanıcı Adı: ${log.username}',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Giriş Tarihi: ${log.girisTarih}',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Çıkış Tarihi: ${log.cikisTarih}',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Kayıt Tarihi: ${log.kayitTarih}',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Yapılan İşlem: ${log.yapilanIslem}',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Yapılan İşlem: ${log.yapilanIslemders}',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Yapılan İşlem: ${log.yapilanIslemoyun}',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
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
