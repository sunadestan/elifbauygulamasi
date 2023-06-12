import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dbHelper.dart';
import '../../data/googlesign.dart';
import '../../hakkimizdaiki.dart';
import '../../models/Log.dart';
import '../../models/game.dart';
import '../ayarlar.dart';
import '../dersmenü.dart';
import '../home.dart';
import '../oyunmenü.dart';
import '../../LoginScreens/login_page.dart';
import '../../models/letter.dart';
import '../../models/user.dart';
import 'package:intl/intl.dart';

class Soru {
  final String harf;
  final String resim1;
  final String resim2;
  final String resim3;
  final String dogruCevap;

  Soru(this.harf, this.resim1, this.resim2, this.resim3, this.dogruCevap);
}

class SoruOyunu extends StatefulWidget {
  SoruOyunu({
    Key? key,
    required this.user,
    required this.game,
    required this.letter,
    required this.name,
    required this.lastname,
    required this.email,
    required this.username,
  }) : super(key: key);
  User user;
  Letter letter;
  Game game;
  final name;
  final email;
  final username;
  final lastname;

  @override
  _SoruOyunuState createState() => _SoruOyunuState();
}

class _SoruOyunuState extends State<SoruOyunu> with TickerProviderStateMixin {
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
  var dbHelper = DbHelper();
  final log = Log();

  bool _dogruMu = false;
  int _randomIndex = 0;
  int _kalanHak = 11;
  int _dogruSayac = 0;
  int yanlisCevapSayisi = 0;

  static List<Soru> _resimler = [
    Soru("elif", "ustun/elif_üstün.png", "esre/elif_esre.png",
        "otre/elif_ötre.png", "ustun"),
    Soru("be", "ustun/be_üstün.png", "esre/be_esre.png", "otre/be_ötre.png",
        "esre"),
    Soru("te", "ustun/te_üstün.png", "esre/te_esre.png", "otre/te_ötre.png",
        "otre"),
    Soru("peltekSe", "ustun/se_üstün.png", "esre/se_esre.png",
        "otre/se_ötre.png", "ustun"),
    Soru("cim", "ustun/cim_üstün.png", "esre/cim_esre.png", "otre/cim_ötre.png",
        "esre"),
    Soru("ha", "ustun/ha_üstün.png", "esre/ha_esre.png", "otre/ha_ötre.png",
        "otre"),
    Soru("ğhı", "ustun/hı_üstün.png", "esre/hı_esre.png", "otre/hı_ötre.png",
        "ustun"),
    Soru("dal", "ustun/dal_üstün.png", "esre/dal_esre.png", "otre/dal_ötre.png",
        "esre"),
    Soru("zel", "ustun/zel_üstün.png", "esre/zel_esre.png", "otre/zel_ötre.png",
        "otre"),
    Soru("ra", "ustun/ra_üstün.png", "esre/ra_esre.png", "otre/ra_ötre.png",
        "ustun"),
    Soru("ze", "ustun/ze_üstün.png", "esre/ze_esre.png", "otre/ze_ötre.png",
        "esre"),
    Soru("sin", "ustun/sin_üstün.png", "esre/sin_esre.png", "otre/sin_ötre.png",
        "otre"),
    Soru("şin", "ustun/şin_üstün.png", "esre/şin_esre.png", "otre/şin_ötre.png",
        "ustun"),
    Soru("sad", "ustun/sad_üstün.png", "esre/sad_esre.png", "otre/sad_ötre.png",
        "esre"),
    Soru("dad", "ustun/dad_üstün.png", "esre/dad_esre.png", "otre/dad_ötre.png",
        "otre"),
    Soru("ta", "ustun/tı_üstün.png", "esre/tı_esre.png", "otre/tı_ötre.png",
        "ustun"),
    Soru("ayın", "ustun/ayın_üstün.png", "esre/ayın_esre.png",
        "otre/ayın_ötre.png", "esre"),
    Soru("ğayn", "ustun/gayın_üstün.png", "esre/gayın_esre.png",
        "otre/gayın_ötre.png", "otre"),
    Soru("fe", "ustun/fe_üstün.png", "esre/fe_esre.png", "otre/fe_ötre.png",
        "ustun"),
    Soru("gaf", "ustun/gaf_üstün.png", "esre/gaf_esre.png", "otre/gaf_ötre.png",
        "esre"),
    Soru("kef", "ustun/kef_üstün.png", "esre/kef_esre.png", "otre/kef_ötre.png",
        "otre"),
    Soru("lam", "ustun/lam_üstün.png", "esre/lam_esre.png", "otre/lam_ötre.png",
        "ustun"),
    Soru("mim", "ustun/mim_üstün.png", "esre/mim_esre.png", "otre/mim_ötre.png",
        "esre"),
    Soru("nun", "ustun/nun_üstün.png", "esre/nun_esre.png", "otre/nun_ötre.png",
        "otre"),
    Soru("vav", "ustun/vav_üstün.png", "esre/vav_esre.png", "otre/vav_ötre.png",
        "ustun"),
    Soru("he", "ustun/he_üstün.png", "esre/he_esre.png", "otre/he_ötre.png",
        "esre"),
    Soru("ye", "ustun/ye_üstün.png", "esre/ye_esre.png", "otre/ye_ötre.png",
        "otre"),
    Soru("elif", "ustun/elif_üstün.png", "esre/elif_esre.png",
        "otre/elif_ötre.png", "esre"),
    Soru("be", "ustun/be_üstün.png", "esre/be_esre.png", "otre/be_ötre.png",
        "otre"),
    Soru("te", "ustun/te_üstün.png", "esre/te_esre.png", "otre/te_ötre.png",
        "ustun"),
    Soru("peltekSe", "ustun/se_üstün.png", "esre/se_esre.png",
        "otre/se_ötre.png", "esre"),
    Soru("cim", "ustun/cim_üstün.png", "esre/cim_esre.png", "otre/cim_ötre.png",
        "otre"),
    Soru("ha", "ustun/ha_üstün.png", "esre/ha_esre.png", "otre/ha_ötre.png",
        "ustun"),
    Soru("ğhı", "ustun/hı_üstün.png", "esre/hı_esre.png", "otre/hı_ötre.png",
        "esre"),
    Soru("dal", "ustun/dal_üstün.png", "esre/dal_esre.png", "otre/dal_ötre.png",
        "otre"),
    Soru("zel", "ustun/zel_üstün.png", "esre/zel_esre.png", "otre/zel_ötre.png",
        "ustun"),
    Soru("ra", "ustun/ra_üstün.png", "esre/ra_esre.png", "otre/ra_ötre.png",
        "esre"),
    Soru("ze", "ustun/ze_üstün.png", "esre/ze_esre.png", "otre/ze_ötre.png",
        "otre"),
    Soru("sin", "ustun/sin_üstün.png", "esre/sin_esre.png", "otre/sin_ötre.png",
        "ustun"),
    Soru("şin", "ustun/şin_üstün.png", "esre/şin_esre.png", "otre/şin_ötre.png",
        "esre"),
    Soru("sad", "ustun/sad_üstün.png", "esre/sad_esre.png", "otre/sad_ötre.png",
        "otre"),
    Soru("dad", "ustun/dad_üstün.png", "esre/dad_esre.png", "otre/dad_ötre.png",
        "ustun"),
    Soru("ta", "ustun/tı_üstün.png", "esre/tı_esre.png", "otre/tı_ötre.png",
        "esre"),
    Soru("ayın", "ustun/ayın_üstün.png", "esre/ayın_esre.png",
        "otre/ayın_ötre.png", "otre"),
    Soru("ğayn", "ustun/gayın_üstün.png", "esre/gayın_esre.png",
        "otre/gayın_ötre.png", "ustun"),
    Soru("fe", "ustun/fe_üstün.png", "esre/fe_esre.png", "otre/fe_ötre.png",
        "esre"),
    Soru("gaf", "ustun/gaf_üstün.png", "esre/gaf_esre.png", "otre/gaf_ötre.png",
        "otre"),
    Soru("kef", "ustun/kef_üstün.png", "esre/kef_esre.png", "otre/kef_ötre.png",
        "ustun"),
    Soru("lam", "ustun/lam_üstün.png", "esre/lam_esre.png", "otre/lam_ötre.png",
        "esre"),
    Soru("mim", "ustun/mim_üstün.png", "esre/mim_esre.png", "otre/mim_ötre.png",
        "otre"),
    Soru("nun", "ustun/nun_üstün.png", "esre/nun_esre.png", "otre/nun_ötre.png",
        "ustun"),
    Soru("vav", "ustun/vav_üstün.png", "esre/vav_esre.png", "otre/vav_ötre.png",
        "esre"),
    Soru("he", "ustun/he_üstün.png", "esre/he_esre.png", "otre/he_ötre.png",
        "otre"),
    Soru("ye", "ustun/ye_üstün.png", "esre/ye_esre.png", "otre/ye_ötre.png",
        "ustun"),
    Soru("elif", "ustun/elif_üstün.png", "esre/elif_esre.png",
        "otre/elif_ötre.png", "otre"),
    Soru("be", "ustun/be_üstün.png", "esre/be_esre.png", "otre/be_ötre.png",
        "ustun"),
    Soru("te", "ustun/te_üstün.png", "esre/te_esre.png", "otre/te_ötre.png",
        "esre"),
    Soru("peltekSe", "ustun/se_üstün.png", "esre/se_esre.png",
        "otre/se_ötre.png", "otre"),
    Soru("cim", "ustun/cim_üstün.png", "esre/cim_esre.png", "otre/cim_ötre.png",
        "ustun"),
    Soru("ha", "ustun/ha_üstün.png", "esre/ha_esre.png", "otre/ha_ötre.png",
        "esre"),
    Soru("ğhı", "ustun/hı_üstün.png", "esre/hı_esre.png", "otre/hı_ötre.png",
        "otre"),
    Soru("dal", "ustun/dal_üstün.png", "esre/dal_esre.png", "otre/dal_ötre.png",
        "ustun"),
    Soru("zel", "ustun/zel_üstün.png", "esre/zel_esre.png", "otre/zel_ötre.png",
        "esre"),
    Soru("ra", "ustun/ra_üstün.png", "esre/ra_esre.png", "otre/ra_ötre.png",
        "otre"),
    Soru("ze", "ustun/ze_üstün.png", "esre/ze_esre.png", "otre/ze_ötre.png",
        "ustun"),
    Soru("sin", "ustun/sin_üstün.png", "esre/sin_esre.png", "otre/sin_ötre.png",
        "esre"),
    Soru("şin", "ustun/şin_üstün.png", "esre/şin_esre.png", "otre/şin_ötre.png",
        "otre"),
    Soru("sad", "ustun/sad_üstün.png", "esre/sad_esre.png", "otre/sad_ötre.png",
        "ustun"),
    Soru("dad", "ustun/dad_üstün.png", "esre/dad_esre.png", "otre/dad_ötre.png",
        "esre"),
    Soru("ta", "ustun/tı_üstün.png", "esre/tı_esre.png", "otre/tı_ötre.png",
        "otre"),
    Soru("ayın", "ustun/ayın_üstün.png", "esre/ayın_esre.png",
        "otre/ayın_ötre.png", "ustun"),
    Soru("ğayn", "ustun/gayın_üstün.png", "esre/gayın_esre.png",
        "otre/gayın_ötre.png", "esre"),
    Soru("fe", "ustun/fe_üstün.png", "esre/fe_esre.png", "otre/fe_ötre.png",
        "otre"),
    Soru("gaf", "ustun/gaf_üstün.png", "esre/gaf_esre.png", "otre/gaf_ötre.png",
        "ustun"),
    Soru("kef", "ustun/kef_üstün.png", "esre/kef_esre.png", "otre/kef_ötre.png",
        "esre"),
    Soru("lam", "ustun/lam_üstün.png", "esre/lam_esre.png", "otre/lam_ötre.png",
        "otre"),
    Soru("mim", "ustun/mim_üstün.png", "esre/mim_esre.png", "otre/mim_ötre.png",
        "ustun"),
    Soru("nun", "ustun/nun_üstün.png", "esre/nun_esre.png", "otre/nun_ötre.png",
        "esre"),
    Soru("vav", "ustun/vav_üstün.png", "esre/vav_esre.png", "otre/vav_ötre.png",
        "otre"),
    Soru("he", "ustun/he_üstün.png", "esre/he_esre.png", "otre/he_ötre.png",
        "ustun"),
    Soru("ye", "ustun/ye_üstün.png", "esre/ye_esre.png", "otre/ye_ötre.png",
        "esre"),
  ];
  List<String> _sorularr = [
    'Harfin üstün hali nedir?',
    'Harfin esre hali nedir?',
    'Harfin ötre hali nedir?'
  ];
  List<String> _secilenSorular = [];
  List<String> sorular = [
    '1. Soru',
    '2. Soru',
    '3. Soru',
    '4. Soru',
    '5. Soru',
    '6. Soru',
    '7. Soru',
    '8. Soru',
    '9. Soru',
    '10. Soru',
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

    // Seçilen soruyu ekle
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
            'Harfin üstün hali nedir?',
          ];
        } else if (_dogruSik == "esre") {
          _sorularr = [
            'Harfin esre hali nedir?',
          ];
        } else {
          _sorularr = [
            'Harfin ötre hali nedir?',
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
                              "4", // Provide the appropriate value for the level field
                        );
                        dbHelper.updateGame1(updatedGame, "4");
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
                  'Doğru Cevap: ${_resim.dogruCevap}',
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
        bool exit = await Navigator.pushAndRemoveUntil(
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
                    )),
            (route) => false);
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                row(),
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
                        'assets/elifba/${_resim.harf}.png',
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
                        _cevapKontrol(_resim.resim1.contains(_resim.dogruCevap)
                            ? 'ustun'
                            : _resim.resim1.contains('ustun')
                                ? 'ustun'
                                : 'ustun');
                      },
                      child: Image.asset(
                        'assets/elifba/${_resim.resim1}',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _cevapKontrol(_resim.resim2.contains(_resim.dogruCevap)
                            ? 'esre'
                            : _resim.resim2.contains('esre')
                                ? 'esre'
                                : 'esre');
                      },
                      child: Image.asset(
                        'assets/elifba/${_resim.resim2}',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _cevapKontrol(_resim.resim3.contains(_resim.dogruCevap)
                            ? 'otre'
                            : _resim.resim3.contains('otre')
                                ? 'otre'
                                : 'otre');
                      },
                      child: Image.asset(
                        'assets/elifba/${_resim.resim3}',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ],
                ),
                nextIcon(),
              ],
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_secilenSik', _secilenSik));
    properties.add(StringProperty('_dogruSik', _dogruSik));
    properties.add(DiagnosticsProperty<bool>('_dogruMu', _dogruMu));
    properties.add(StringProperty('_soru', _soru));
  }
}
