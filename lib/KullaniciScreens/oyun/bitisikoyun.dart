import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../LoginScreens/login_page.dart';
import '../../data/dbHelper.dart';
import '../../data/googlesign.dart';
import '../../hakkimizdaiki.dart';
import '../../models/Log.dart';
import '../../models/game.dart';
import '../../models/letter.dart';
import '../../models/user.dart';
import '../ayarlar.dart';
import '../dersmenü.dart';
import '../home.dart';
import '../oyunmenü.dart';
import 'package:intl/intl.dart';

class Soru {
  final String harf;
  final String resim1;
  final String resim2;
  final String resim3;
  final String dogruCevap;

  Soru(this.harf, this.resim1, this.resim2, this.resim3, this.dogruCevap);
}

class BitisikOyun extends StatefulWidget {
  BitisikOyun({
    Key? key,
    required this.name,
    required this.user,
    required this.game,
    required this.letter,
    required this.username,
    required this.email,
    required this.lastname,
  }) : super(key: key);
  final name;
  final username;
  final lastname;
  final email;
  User user;
  Letter letter;
  Game game;

  @override
  State<BitisikOyun> createState() => _BitisikOyunState();
}

class _BitisikOyunState extends State<BitisikOyun>
    with TickerProviderStateMixin {
  final _advancedDrawerController = AdvancedDrawerController();
  late AnimationController _animationController;
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  int skor = 0;
  int _secondsLeft = 120;
  int _pausedTime = 0;
  bool _isPaused = false;
  late Timer _timer;
  late Soru _resim;
  String? _secilenSik;
  String? _dogruSik;
  String? _soru;
  bool _dogruMu = false;
  int _randomIndex = 0;
  int _kalanHak = 11;
  int _dogruSayac = 0;
  int yanlisCevapSayisi = 0;
  var dbHelper = DbHelper();
  final log = Log();

  static List<Soru> _resimler = [
    Soru("alime", "ABETİ", "ALİME", "EHADE", "esre"),
    Soru("bedee", 'BEDEE', "BEHÜSE", "BEŞERİ", "ustun"),
    Soru("beude", "ustun/te_üstün.png", "esre/te_esre.png", "BEUDE", "otre"),
    Soru("ebede", "EBEDE", "esre/se_esre.png", "otre/se_ötre.png", "ustun"),
    Soru("ecele", "ustun/cim_üstün.png", "ECELE", "otre/cim_ötre.png", "esre"),
    Soru("ehade", "ustun/ha_üstün.png", "esre/ha_esre.png", "EHADE", "otre"),
    Soru("ekele", "EKELE", "esre/hı_esre.png", "otre/hı_ötre.png", "ustun"),
    Soru("emera", "ustun/dal_üstün.png", "EMERA", "otre/dal_ötre.png", "esre"),
    Soru("emine", "ustun/zel_üstün.png", "esre/zel_esre.png", "EMİNE", "otre"),
    Soru("erine", "ERİNE", "esre/ra_esre.png", "otre/ra_ötre.png", "ustun"),
    Soru("eseri", "ustun/ze_üstün.png", "ESERİ", "otre/ze_ötre.png", "esre"),
    Soru("ezine", "ustun/sin_üstün.png", "esre/sin_esre.png", "EZİNE", "otre"),
    Soru("feale", "FEALE", "esre/şin_esre.png", "otre/şin_ötre.png", "ustun"),
    Soru(
        "fehüve", "ustun/sad_üstün.png", "FEHÜVE", "otre/sad_ötre.png", "esre"),
    Soru(
        "hamide", "ustun/dad_üstün.png", "esre/dad_esre.png", "HAMİDE", "otre"),
    Soru("kelime", "KELİME", "esre/tı_esre.png", "otre/tı_ötre.png", "ustun"),
    Soru("ketebe", "ustun/ayın_üstün.png", "KETEBE", "otre/ayın_ötre.png",
        "esre"),
    Soru("kütibe", "ustun/gayın_üstün.png", "esre/gayın_esre.png", "KÜTİBE",
        "otre"),
    Soru("meleke", "MELEKE", "esre/fe_esre.png", "otre/fe_ötre.png", "ustun"),
    Soru(
        "meliki", "ustun/gaf_üstün.png", "MELİKİ", "otre/gaf_ötre.png", "esre"),
    Soru(
        "mesedi", "ustun/kef_üstün.png", "esre/kef_esre.png", "MESEDİ", "otre"),
    Soru("mesele", "MESELE", "esre/lam_esre.png", "otre/lam_ötre.png", "ustun"),
    Soru(
        "meselü", "ustun/mim_üstün.png", "MESELÜ", "otre/mim_ötre.png", "esre"),
    Soru(
        "nüfiha", "ustun/nun_üstün.png", "esre/nun_esre.png", "NÜFİHA", "otre"),
    Soru("rüsülü", "RÜSÜLÜ", "esre/vav_esre.png", "otre/vav_ötre.png", "ustun"),
    Soru("samedü", "ustun/he_üstün.png", "SAMEDÜ", "otre/he_ötre.png", "esre"),
    Soru("sekete", "ustun/ye_üstün.png", "esre/ye_esre.png", "SEKETE", "otre"),
    Soru("selime", "ustun/elif_üstün.png", "SELİME", "otre/elif_ötre.png",
        "esre"),
    Soru("sülüsü", "ustun/be_üstün.png", "esre/be_esre.png", "SÜLÜSÜ", "otre"),
    Soru("tebia", "TEBİA", "esre/te_esre.png", "otre/te_ötre.png", "ustun"),
    Soru("vehüve", "ustun/se_üstün.png", "VEHÜVE", "otre/se_ötre.png", "esre"),
    Soru(
        "velede", "ustun/cim_üstün.png", "esre/cim_esre.png", "VELEDE", "otre"),
    Soru("verime", "VERİME", "esre/ha_esre.png", "otre/ha_ötre.png", "ustun"),
    Soru("verise", "ustun/hı_üstün.png", "VERİSE", "otre/hı_ötre.png", "esre"),
    Soru(
        "vücide", "ustun/dal_üstün.png", "esre/dal_esre.png", "VÜCİDE", "otre"),
    Soru("zükira", "ZÜKİRA", "esre/zel_esre.png", "otre/zel_ötre.png", "ustun"),
    Soru("üzine", "ustun/ra_üstün.png", "ÜZİNE", "otre/ra_ötre.png", "esre"),
    Soru("şehide", "ustun/ze_üstün.png", "esre/ze_esre.png", "ŞEHİDE", "otre"),
    Soru("şeribe", "ŞERİBE", "esre/sin_esre.png", "otre/sin_ötre.png", "ustun"),
  ];
  List<String> _secilenSorular = [];
  List<String> _sorularr = [
    'Harfin okunuşu nedir?',
  ];

  void _soruYukle() {
    List<String> secilebilirSorular = _resimler
        .map((soru) => soru.harf)
        .where((id) => !_secilenSorular.contains(id))
        .toList();
    final rastgeleSoruIndex = Random().nextInt(secilebilirSorular.length);
    final secilenSoru = secilebilirSorular[rastgeleSoruIndex];

    _resim = _resimler.firstWhere((soru) => soru.harf == secilenSoru);
    _dogruSik = _resim.dogruCevap;
    _secilenSorular.add(secilenSoru);

    for (int i = 0; i < _sorularr.length; i++) {
      if (_sorularr[i].contains(_resim.dogruCevap)) {
        _soru = _sorularr[i];
        break;
      }
    }
  }

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
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      String formattedDateTime =
                          DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
                      List<Log> logList =
                          await dbHelper.getLogusername(widget.user.username!);
                      if (logList.isNotEmpty) {
                        Log existingLog = logList.first;
                        existingLog.durum = 0;
                        existingLog.cikisTarih = formattedDateTime;
                        existingLog.girisTarih;
                        existingLog.yapilanIslem = "Çıkış";
                        await dbHelper.updateLog(existingLog);
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

  void _soruYenile() {
    setState(() {
      if (_kalanHak > 0) {
        _kalanHak--;
        _soruYukle();
        _secilenSik = null;
        _dogruMu = false;
        if (_dogruSik == "ustun") {
          _sorularr = [
            'Harfin okunuşu nedir?',
          ];
        } else if (_dogruSik == "esre") {
          _sorularr = [
            'Harfin okunuşu nedir?',
          ];
        } else {
          _sorularr = [
            'Harfin okunuşu nedir?',
          ];
        }
        deneme();
      }
    });
  }

  void deneme() {
    if (_kalanHak == 0) {
      if (_dogruMu) {}
      _timer.cancel();
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
                  "Tebrikler Oyunu Bitirdiniz",
                  style: GoogleFonts.comicNeue(
                    color: Colors.lightBlueAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,
                  "Yeniden oynamak ister misiniz?",
                  style: GoogleFonts.comicNeue(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,
                  "Skorunuz: ${_dogruSayac}",
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
                        Game updatedGame = Game(
                          seviyeKilit: 1,
                          durum: 2,
                          kullaniciId: widget.user.id,
                          level:
                              "5", // Provide the appropriate value for the level field
                        );
                        dbHelper.updateGame1(updatedGame, "5");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OyunSinifi(
                                      user: widget.user,
                                      letter: letter,
                                      name: widget.name,
                                      username: widget.username,
                                      lastname: widget.lastname,
                                      email: widget.email,
                                      game: widget.game,
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
                        setState(() {
                          Navigator.of(context).pop();
                          _secondsLeft = 120;
                          startTimer();
                          _kalanHak = 11;
                          _dogruSayac = 0;
                          _soruYenile();
                        });
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
  }

  void _handleMenuButtonPressed() {
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void _cevapKontrol(String cevap) {
    if (cevap == _resim.dogruCevap) {
      _dogruSayac++;
      skor += 1;
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
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Cevabınız doğru.",
                  style: GoogleFonts.comicNeue(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                        _soruYenile();
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
    } else {
      yanlisCevapSayisi++;
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
                  'Üzgünüm!',
                  style: GoogleFonts.comicNeue(
                    color: Colors.lightBlueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Cevabınız Yanlış',
                  style: GoogleFonts.comicNeue(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Doğru Cevap: ${_resim.harf}',
                  style: GoogleFonts.comicNeue(
                    color: Colors.black,
                    fontSize: 20,
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
                        _soruYenile();
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
  }

  @override
  void initState() {
    super.initState();
    _resimler;
    _soruYukle();
    _soruYenile();
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
                  "Bu oyunda harflerin harekelerini pekiştireceğiz.",
                  style: GoogleFonts.comicNeue(
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
                                      letter: letter,
                                      name: widget.name,
                                      username: widget.username,
                                      lastname: widget.lastname,
                                      email: widget.email,
                                      game: widget.game,
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
    return WillPopScope(
      onWillPop: () async {
        _timer.cancel();
        togglePause();
        pause();
        bool exit = await Navigator.pushReplacement(
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
            actions: [
              IconButton(
                  onPressed: () {
                    _cikmakistiyorMusunuzuc();
                  },
                  icon: Icon(Icons.exit_to_app))
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              row(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150.0,
                        height: 150.0,
                        margin: const EdgeInsets.only(
                          top: 24.0,
                          bottom: 64.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/elifba/bitisik/${_resim.harf}.png',
                            ),
                            fit: BoxFit.scaleDown,
                          ),
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        '${_sorularr[_randomIndex]}',
                        style: GoogleFonts.comicNeue(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Şıkları liste halinde göster
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              _cevapKontrol(
                                  _resim.resim1.contains(_resim.dogruCevap)
                                      ? 'ustun'
                                      : _resim.resim1.contains('ustun')
                                          ? 'ustun'
                                          : 'ustun');
                            },
                            child: Text(
                              "A)" + "  " + " " + "${_resim.resim1}",
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _cevapKontrol(
                                  _resim.resim2.contains(_resim.dogruCevap)
                                      ? 'esre'
                                      : _resim.resim2.contains('esre')
                                          ? 'esre'
                                          : 'esre');
                            },
                            child: Text(
                              "B)" + "  " + " " + "${_resim.resim2}",
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _cevapKontrol(
                                  _resim.resim3.contains(_resim.dogruCevap)
                                      ? 'otre'
                                      : _resim.resim3.contains('otre')
                                          ? 'otre'
                                          : 'otre');
                            },
                            child: Text(
                              "C)" + "  " + " " + "${_resim.resim3}",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 150,
                      ),
                      nextIcon(),
                    ],
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
                      togglePause();
                      _cikmakistiyorMusunuzbir();
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
                      togglePause();
                      _cikmakistiyorMusunuziki();
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
                      togglePause();
                      _cikmakistiyorMusunuzuc();
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
                      togglePause();
                      _cikmakistiyorMusunuzdort();
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
                      togglePause();
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
              ),
              SizedBox(height: 16),
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
                                    name: widget.name,
                                    user: widget.user,
                                    letter: letter,
                                    username: widget.username,
                                    lastname: widget.lastname,
                                    email: widget.email,
                                    game: widget.game,
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
                      _secondsLeft = 120;
                      startTimer();
                      _soruYenile();
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

  Widget timer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              togglePause();
              pause();
            },
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
                  // progress: _animationController,
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

  Widget row() {
    return Row(
      children: [
        timer(),
        _title(),
      ],
    );
  }

  void pause() {
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
                'Oyun Durdu!',
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Skor: ${_dogruSayac}  Kalan Süre:  ${_pausedTime}',
                style: GoogleFonts.comicNeue(
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
                      Navigator.pushAndRemoveUntil(
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
                                  )),
                          (route) => false);
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
                      togglePause();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Devam Et',
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

  void _cikmakistiyorMusunuzbir() {
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
                textAlign: TextAlign.center,
                'Oyundan Çıkış Yapmak İstediğinize Emin Misiniz?',
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Skorunuz Sıfırlanıcaktır!',
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Skor: ${_dogruSayac}  Kalan Süre:  ${_pausedTime}',
                style: GoogleFonts.comicNeue(
                  fontSize: 16,
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
                      togglePause();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'İptal',
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
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    user: widget.user,
                                    letter: widget.letter,
                                    name: widget.name,
                                    username: widget.username,
                                    lastname: widget.lastname,
                                    email: widget.email,
                                    game: widget.game,
                                  )));
                      togglePause();
                      _timer.cancel();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Çıkış Yap',
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

  void _cikmakistiyorMusunuziki() {
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
                textAlign: TextAlign.center,
                'Oyundan Çıkış Yapmak İstediğinize Emin Misiniz?',
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Skorunuz Sıfırlanıcaktır!',
                style: GoogleFonts.comicNeue(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Skor: ${_dogruSayac}  Kalan Süre:  ${_pausedTime}',
                style: GoogleFonts.comicNeue(
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
                      Navigator.of(context).pop();
                      togglePause();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'İptal',
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
                      togglePause();
                      _timer.cancel();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Çıkış Yap',
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

  void _cikmakistiyorMusunuzuc() {
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
                textAlign: TextAlign.center,
                'Oyundan Çıkış Yapmak İstediğinize Emin Misiniz?',
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Skorunuz Sıfırlanıcaktır!',
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Skor: ${_dogruSayac}  Kalan Süre:  ${_pausedTime}',
                style: GoogleFonts.comicNeue(
                  fontSize: 16,
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
                      togglePause();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'İptal',
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
                      togglePause();
                      _timer.cancel();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Çıkış Yap',
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

  void _cikmakistiyorMusunuzdort() {
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
                textAlign: TextAlign.center,
                'Oyundan Çıkış Yapmak İstediğinize Emin Misiniz?',
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Skorunuz Sıfırlanıcaktır!',
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Skor: ${_dogruSayac}  Kalan Süre:  ${_pausedTime}',
                style: GoogleFonts.comicNeue(
                  fontSize: 16,
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
                      togglePause();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'İptal',
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
                      togglePause();
                      _timer.cancel();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Çıkış Yap',
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

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Bil',
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
              text: 'Bakalım ',
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

  Widget nextIcon() {
    return GestureDetector(
      onTap: () {
        _soruYenile();
      },
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Soruyu Geç',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_secilenSik', _secilenSik));
    properties.add(StringProperty('_dogruSik', _dogruSik));
    properties.add(DiagnosticsProperty<bool>('_dogruMu', _dogruMu));
    properties.add(StringProperty('_soru', _soru));
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
//•	Kelime ismi yazılır ve ona ait resmin bulunması istenir.
//•	Resim yukarıda verilir ve kelimenin okunuşu istenir. Bu ya klavyeden yazmalı ya da harfleri sıralamalı olabilir.
//•	Resim yukarda eksik verilir ya da okunuşu mesela “KETEBE” bunu “KE-…-BE”
// şeklinde verilip eksik kısım tamamlattırılır.
