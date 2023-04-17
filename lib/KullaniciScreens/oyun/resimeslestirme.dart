import 'package:elifbauygulamasi/KullaniciScreens/home.dart';
import 'package:elifbauygulamasi/KullaniciScreens/oyunmenü.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../../LoginScreens/login_page.dart';
import '../../models/letter.dart';
import '../../models/user.dart';
import '../ayarlar.dart';
import '../dersmenü.dart';

class ResimEslestirme extends StatefulWidget {
  ResimEslestirme({Key? key, required this.user, required this.letter})
      : super(key: key);
  User user;
  Letter letter;
  @override
  _ResimEslestirmeState createState() => _ResimEslestirmeState();
}

class _ResimEslestirmeState extends State<ResimEslestirme> with TickerProviderStateMixin {
  int seciliIndex = -1;
  bool eslesmeTamamlandi = false;
  int _secondsLeft = 120;
  int _pausedTime = 0;
  bool _isPaused = false;
  late Timer _timer;
  late AnimationController _animationController;
  final _advancedDrawerController = AdvancedDrawerController();
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  //var userr = User("", "", "", "", "", "", "", isadmin: 0);

  List<String> resimler = [
    'assets/elifba/elif.png',
    'assets/elifba/elif.png',
    'assets/elifba/be.png',
    'assets/elifba/be.png',
    'assets/elifba/te.png',
    'assets/elifba/te.png',
    'assets/elifba/peltekSe.png',
    'assets/elifba/peltekSe.png',
    'assets/elifba/cim.png',
    'assets/elifba/cim.png',
    'assets/elifba/ha.png',
    'assets/elifba/ha.png',
    'assets/elifba/ğhı.png',
    'assets/elifba/ğhı.png',
    'assets/elifba/dal.png',
    'assets/elifba/dal.png',
    'assets/elifba/zel.png',
    'assets/elifba/zel.png',
    'assets/elifba/ra.png',
    'assets/elifba/ra.png',
    'assets/elifba/ze.png',
    'assets/elifba/ze.png',
    'assets/elifba/sin.png',
    'assets/elifba/sin.png',
    'assets/elifba/şin.png',
    'assets/elifba/şin.png',
    'assets/elifba/sad.png',
    'assets/elifba/sad.png',
    'assets/elifba/dad.png',
    'assets/elifba/dad.png',

    'assets/elifba/ta.png',
    'assets/elifba/ta.png',
    'assets/elifba/za.png',
    'assets/elifba/za.png',
    'assets/elifba/ayın.png',
    'assets/elifba/ayın.png',
    'assets/elifba/ğayn.png',
    'assets/elifba/ğayn.png',
    'assets/elifba/fe.png',
    'assets/elifba/fe.png',
    'assets/elifba/gaf.png',
    'assets/elifba/gaf.png',
    'assets/elifba/kef.png',
    'assets/elifba/kef.png',
    'assets/elifba/lam.png',
    'assets/elifba/lam.png',
    'assets/elifba/mim.png',
    'assets/elifba/mim.png',
    'assets/elifba/nun.png',
    'assets/elifba/nun.png',
    'assets/elifba/vav.png',
    'assets/elifba/vav.png',
    'assets/elifba/he.png',
    'assets/elifba/he.png',
    'assets/elifba/lamelif.jpg',
    'assets/elifba/lamelif.jpg',
    'assets/elifba/ye.png',
    'assets/elifba/ye.png',
  ];
  List<String> gizliResimler = [
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
  ];

  @override
  void initState() {
    super.initState();
    liste();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    Future.delayed(Duration.zero, () {
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
                  "Oyun Hakkında",
                  style: GoogleFonts.comicNeue(
                    color: Colors.lightBlueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Bu oyunda...",
                  style: GoogleFonts.comicNeue(
                    fontSize:18,
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
                  children: [  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OyunSinifi(
                                user: widget.user,
                              ))).then((value) => Navigator.pop(context));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'Çıkış Yap',
                      style: GoogleFonts.comicNeue(
                        fontWeight: FontWeight.w600,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        startTimer();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.lightBlueAccent),
                      ),
                      child: Text(
                        "Başla",
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
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
          title: Text("Hadi Oyun Oynayalım",
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
        body: Column(
          children: [
            customSizedBox(),
            row(),
            customSizedBox(),
            //buildcizgi(),
            //customSizedBox(),
            Expanded(
              child: Center(
                child: GridView.builder(
                  itemCount: resimler.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!eslesmeTamamlandi) {
                            if (seciliIndex == -1) {
                              seciliIndex = index;
                              gizliResimler[index] = resimler[index];
                            } else if (seciliIndex != index) {
                              if (resimler[index] == resimler[seciliIndex]) {
                                gizliResimler[index] = resimler[index];
                                seciliIndex = -1;
                                if (gizliResimler.every((resim) =>
                                    resim != 'assets/resim/Elif.png')) {
                                  eslesmeTamamlandi = true;
                                  _timer.cancel();
                                  _showDialogg();
                                }
                              } else {
                                gizliResimler[index] = resimler[index];
                                Timer(Duration(milliseconds: 500), () {
                                  if (seciliIndex != -1) {
                                    if (index != seciliIndex) {
                                      gizliResimler[index] =
                                          'assets/resim/Elif.png';
                                      gizliResimler[seciliIndex] =
                                          'assets/resim/Elif.png';
                                      seciliIndex = -1;
                                      setState(() {});
                                    }
                                  }
                                });
                              }
                            }
                          }
                        });
                      },
                      child: Card(
                        color: Colors.lightBlueAccent,
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Color(0xffbea1ea), width: 2),
                          ),
                          child: Image.asset(
                            gizliResimler[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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
                                ))).then((value) => Navigator.pop(context));
                    togglePause();
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
                                ))).then((value) => Navigator.pop(context));
                    togglePause();
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
                            builder: (context) => OyunSinifi(user: widget.user)));
                    togglePause();
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
                  onTap: () {},
                  leading: Icon(Icons.import_contacts_sharp),
                  title: Text(
                    'Sureler',
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
                                )));
                    togglePause();
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
    );
  }
  Widget row(){
    return Row(
      children: [
            timer(),
            _title(),

      ],
    );
}
  Widget timer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            onTap: togglePause,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  color: Colors.lightBlueAccent,
                  progress: _animationController,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                getIcon(),
                color: Colors.lightBlueAccent,
                size: 20,
              ),
              Text(
                _isPaused ? '$_pausedTime' : '$_secondsLeft',
                style: GoogleFonts.comicNeue(
                    color: Colors.lightBlueAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Renkli',
          style: GoogleFonts.comicNeue(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            color: Colors.lightBlueAccent,
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
                color: Colors.lightBlueAccent,
                fontSize: 38,
                fontWeight: FontWeight.w700,shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.grey,
                  offset: Offset(2.0, 2.0),
                ),
              ],),
            ),
            TextSpan(
              text: 'Harfler ',
              style: GoogleFonts.comicNeue(
                color: Colors.lightBlueAccent,
                fontSize: 38,
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
              text: '3',
              style: GoogleFonts.comicNeue(
                color: Colors.lightBlueAccent,
                fontSize: 38,
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

  void _showResendDialog() {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
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
  void _showDialog() {
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
                "Malesef Olmadı",
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ), SizedBox(height: 16),
              Text(
                textAlign: TextAlign.center,
                "Oyunu yeniden başlatmak ister misiniz?",
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontSize: 18,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OyunSinifi(
                                user: widget.user,
                              ))).then((value) => Navigator.pop(context));
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
                      Navigator.of(context).pop();
                      _secondsLeft=120;
                      startTimer();
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
  void _showDialogg() {
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
                'Tebrikler!',
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ), SizedBox(height: 16),
              Text(
                textAlign: TextAlign.center,
                'Tüm harfleri eşleştirdiniz!',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontSize: 18,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OyunSinifi(
                                user: widget.user,
                              ))).then((value) => Navigator.pop(context));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'Çıkış Yap',
                      style: GoogleFonts.comicNeue(
                        fontWeight: FontWeight.w600,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _secondsLeft = 120;
                      startTimer();
                      reset();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Tekrar Oyna',
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

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_secondsLeft < 1) {
            timer.cancel();
            _showDialog();
          } else {
            _secondsLeft = _secondsLeft - 1;
          }
        },
      ),
    );
  }
  void togglePause() {
    if (_isPaused) {
      startTimer();
      _animationController.forward();
      setState(() {
        _isPaused = false;
      });
    } else {
      _timer.cancel();
      _animationController.reverse(from: 1);
      setState(() {
        _isPaused = true;
        _pausedTime = _secondsLeft;
      });
    }
  }
  void liste() {
    setState(() {
      resimler.shuffle(Random());
    });
  }
  void reset() {
    setState(() {
      resimler.shuffle();
      gizliResimler =
          List<String>.filled(gizliResimler.length, 'assets/resim/Elif.png');
      eslesmeTamamlandi = false;
    });
  }
  IconData getIcon() {
    if (_isPaused) {
      return Icons.hourglass_empty;
    } else if (_secondsLeft <= 0) {
      _animationController.forward();
      return Icons.hourglass_empty;
    } else {
      return Icons.alarm;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Timer>('_timer', _timer));
  }
}
