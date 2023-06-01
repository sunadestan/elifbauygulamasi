import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../LoginScreens/login_page.dart';
import '../../data/dbHelper.dart';
import '../../data/googlesign.dart';
import '../../models/Log.dart';
import '../../models/game.dart';
import '../../models/letter.dart';
import '../../models/user.dart';
import '../ayarlar.dart';
import '../dersmenü.dart';
import '../home.dart';
import '../oyunmenü.dart';
import 'package:intl/intl.dart';

class Ses {
  final String harf;
  final String ses;
  final String dogruCevap;

  Ses(this.harf, this.ses, this.dogruCevap);
}

class Soru {
  final String harf;
  final String dogruCevap;

  Soru(this.harf, this.dogruCevap);
}

class SesOyunu extends StatefulWidget {
  SesOyunu(
      {Key? key,
      required this.user,
      required this.game,
      required this.letter,
      required this.name,
      required this.lastname,
      required this.email,
      required this.username})
      : super(key: key);
  User user;
  Letter letter;
  Game game;
  final name;
  final email;
  final username;
  final lastname;

  @override
  State<SesOyunu> createState() => _SesOyunuState();
}

class _SesOyunuState extends State<SesOyunu> with TickerProviderStateMixin {
  int skor = 0;
  bool tappingDisabled = false;
  bool eslesmeTamamlandi = false;
  int _secondsLeft = 120;
  int _pausedTime = 0;
  bool _isPaused = false;
  final log = Log();

  late Soru _resim;
  late Ses _ses;
  late Timer _timer;
  late AnimationController _animationController;
  final _advancedDrawerController = AdvancedDrawerController();
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  //var userr = User("", "", "", "", "", "", "", isadmin: 0);
  bool _isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  var dbHelper = DbHelper();

  static List<Ses> _sesler = [
    Ses("elif", "ses/elif.mp3", "ustun"),
    Ses("be", "ses/be.mp3", "esre"),
    Ses("te", "ses/te.mp3", "otre"),
    Ses("peltekSe", "ses/se.mp3", "ustun"),
    Ses("cim", "ses/cim.mp3", "esre"),
    Ses("ha", "ses/ha.mp3", "otre"),
    Ses("ğhı", "ses/hı.mp3", "ustun"),
    Ses("dal", "ses/dal.mp3", "esre"),
    Ses("zel", "ses/zel.mp3", "otre"),
    Ses("ra", "ses/ra.mp3", "ustun"),
    Ses("ze", "ses/ze.mp3", "esre"),
    Ses("sin", "ses/sin.mp3", "otre"),
    Ses("şin", "ses/şin.mp3", "ustun"),
    Ses("sad", "ses/sad.mp3", "esre"),
    Ses("dad", "ses/dad.mp3", "otre"),
    Ses("ta", "ses/te.mp3", "ustun"),
    Ses("ayın", "ses/ayın.mp3 ", "esre"),
    Ses("ğayn", "ses/gayın.mp3", "otre"),
    Ses("fe", "ses/fe.mp3", "ustun"),
    Ses("gaf", "ses/gaf.mp3", "esre"),
    Ses("kef", "ses/kef.mp3", "otre"),
    Ses("lam", "ses/lam.mp3", "ustun"),
    Ses("mim", "ses/mim.mp3", "esre"),
    Ses("nun", "ses/nun.mp3", "otre"),
    Ses("vav", "ses/vav.mp3", "ustun"),
    Ses("he", "ses/he.mp3", "esre"),
    Ses("ye", "ses/ye.mp3", "otre"),
    Ses("elif", "ses/elif.mp3", "esre"),
    Ses("be", "ses/be.mp3", "otre"),
    Ses("te", "ses/te.mp3", "ustun"),
    Ses("peltekSe", "ses/se.mp3", "esre"),
    Ses("cim", "ses/cim.mp3", "otre"),
    Ses("ha", "ses/ha.mp3", "ustun"),
    Ses("ğhı", "ses/hı.mp3", "esre"),
    Ses("dal", "ses/dal.mp3", "otre"),
    Ses("zel", "ses/zel.mp3", "ustun"),
    Ses("ra", "ses/ra.mp3", "esre"),
    Ses("ze", "ses/ze.mp3", "otre"),
    Ses("sin", "ses/sin.mp3", "ustun"),
    Ses("şin", "ses/şin.mp3", "esre"),
    Ses("sad", "ses/sad.mp3", "otre"),
    Ses("dad", "ses/dad.mp3", "ustun"),
    Ses("ta", "ses/ta.mp3", "esre"),
    Ses("ayın", "ses/ayın.mp3", "otre"),
    Ses("ğayn", "ses/gayın.mp3", "ustun"),
    Ses("fe", "ses/fe.mp3", "esre"),
    Ses("gaf", "ses/gaf.mp3", "otre"),
    Ses("kef", "ses/kef.mp3", "ustun"),
    Ses("lam", "ses/lam.mp3", "esre"),
    Ses("mim", "ses/mim.mp3", "otre"),
    Ses("nun", "ses/nun.mp3", "ustun"),
    Ses("vav", "ses/nun.mp3", "esre"),
    Ses("he", "ses/he.mp3", "otre"),
    Ses("ye", "ses/ye.mp3", "ustun"),
    Ses("elif", "ses/elif.mp3", "otre"),
    Ses("be", "ses/be.mp3", "ustun"),
    Ses("te", "ses/te.mp3", "esre"),
    Ses("peltekSe", "ses/se.mp3", "otre"),
    Ses("cim", "ses/cim.mp3", "ustun"),
    Ses("ha", "ses/ha.mp3", "esre"),
    Ses("ğhı", "ses/hı.mp3", "otre"),
    Ses("dal", "ses/dal.mp3", "ustun"),
    Ses("zel", "ses/zel.mp3", "esre"),
    Ses("ra", "ses/ra.mp3", "otre"),
    Ses("ze", "ses/ze.mp3", "ustun"),
    Ses("sin", "ses/sin.mp3", "esre"),
    Ses("şin", "ses/şin.mp3", "otre"),
    Ses("sad", "ses/sad.mp3", "ustun"),
    Ses("dad", "ses/dad.mp3", "esre"),
    Ses("ta", "ses/te.mp3", "otre"),
    Ses("ayın", "ses/ayın.mp3", "ustun"),
    Ses("ğayn", "ses/gayın.mp3", "esre"),
    Ses("fe", "ses/fe.mp3", "otre"),
    Ses("gaf", "ses/gaf.mp3", "ustun"),
    Ses("kef", "ses/kef.mp3", "esre"),
    Ses("lam", "ses/lam.mp3", "otre"),
    Ses("mim", "ses/mim.mp3", "ustun"),
    Ses("nun", "ses/nun.mp3", "esre"),
    Ses("vav", "ses/vav.mp3", "otre"),
    Ses("he", "ses/he.mp3", "ustun"),
    Ses("ye", "ses/ye.mp3", "esre"),
  ];
  static List<Soru> _resimler = [
    Soru("elif", "ustun"),
    Soru("be", "esre"),
    Soru("te", "otre"),
    Soru("peltekSe", "ustun"),
    Soru("cim", "esre"),
    Soru("ha", "otre"),
    Soru("ğhı", "ustun"),
    Soru("dal", "esre"),
    Soru("zel", "otre"),
    Soru("ra", "ustun"),
    Soru("ze", "esre"),
    Soru("sin", "otre"),
    Soru("şin", "ustun"),
    Soru("sad", "esre"),
    Soru("dad", "otre"),
    Soru("ta", "ustun"),
    Soru("ayın", "esre"),
    Soru("ğayn", "otre"),
    Soru("fe", "ustun"),
    Soru("gaf", "esre"),
    Soru("kef", "otre"),
    Soru("lam", "ustun"),
    Soru("mim", "esre"),
    Soru("nun", "otre"),
    Soru("vav", "ustun"),
    Soru("he", "esre"),
    Soru("ye", "otre"),
    Soru("elif", "esre"),
    Soru("be", "otre"),
    Soru("te", "ustun"),
    Soru("peltekSe", "esre"),
    Soru("cim", "otre"),
    Soru("ha", "ustun"),
    Soru("ğhı", "esre"),
    Soru("dal", "otre"),
    Soru("zel", "ustun"),
    Soru("ra", "esre"),
    Soru("ze", "otre"),
    Soru("sin", "ustun"),
    Soru("şin", "esre"),
    Soru("sad", "otre"),
    Soru("dad", "ustun"),
    Soru("ta", "esre"),
    Soru("ayın", "otre"),
    Soru("ğayn", "ustun"),
    Soru("fe", "esre"),
    Soru("gaf", "otre"),
    Soru("kef", "ustun"),
    Soru("lam", "esre"),
    Soru("mim", "otre"),
    Soru("nun", "ustun"),
    Soru("vav", "esre"),
    Soru("he", "otre"),
    Soru("ye", "ustun"),
    Soru("elif", "otre"),
    Soru("be", "ustun"),
    Soru("te", "esre"),
    Soru("peltekSe", "otre"),
    Soru("cim", "ustun"),
    Soru("ha", "esre"),
    Soru("ğhı", "otre"),
    Soru("dal", "ustun"),
    Soru("zel", "esre"),
    Soru("ra", "otre"),
    Soru("ze", "ustun"),
    Soru("sin", "esre"),
    Soru("şin", "otre"),
    Soru("sad", "ustun"),
    Soru("dad", "esre"),
    Soru("ta", "otre"),
    Soru("ayın", "ustun"),
    Soru("ğayn", "esre"),
    Soru("fe", "otre"),
    Soru("gaf", "ustun"),
    Soru("kef", "esre"),
    Soru("lam", "otre"),
    Soru("mim", "ustun"),
    Soru("nun", "esre"),
    Soru("vav", "otre"),
    Soru("he", "ustun"),
    Soru("ye", "esre"),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _timer.cancel();
        bool exit = await Navigator.pushAndRemoveUntil(
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
                  icon: Icon(Icons.exit_to_app))
            ],
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Column(
                children: [
                  customSizedBox(),
                  row(),
                  customSizedBox(),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) => ses(_sesler.first),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) => harf(index),
                          ),
                        ),
                      ],
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

  void _checkAnswer(String cevap) {
    if (_ses.dogruCevap == cevap) {
      // Doğru harf resmi bulundu, tebrik mesajı gösterilebilir.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Tebrikler!'),
          content: Text('Doğru harf resmini buldunuz!'),
          actions: [
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Widget customSizedBox() => SizedBox(
        height: 20,
      );
  Widget row() {
    return Row(
      children: [
        timer(),
        _title(),
      ],
    );
  }

  Future<void> _play(Ses ses) async {
    int result = await audioPlayer.play(ses.ses!);
    if (result == 1) {
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future<void> _pause() async {
    if (mounted) {
      int result = await audioPlayer.pause();
      if (result == 1) {
        _isPlaying = false;
      }
    }
  }

  late String musicPath;
  Future<void> _loadAudio() async {
    try {
      await audioPlayer.setUrl(musicPath);
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  Widget ses(Ses ses) {
    return InkWell(
      onTap: () async {
        await _loadAudio();
        if (_isPlaying) {
          await _pause();
          _play(ses);
          setState(() {
            _isPlaying = false;
          });
        } else {
          await _play(ses);
          setState(() {
            _isPlaying = true;
          });
        }
      },
      child: Container(
        //width: 150,
        alignment: Alignment.center,
        child: Center(
          child: Card(
            //margin: EdgeInsets.only(left: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Color(0xffbea1ea),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    'assets/elifba/ses/ses.jpg',
                    //fit: BoxFit.cover,
                    //height: 150,
                    height: 85,
                    width: 140,
                  ),
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      audioPlayer.play(ses.ses);
                      _checkAnswer(_ses.dogruCevap);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget harf(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        child: Center(
          child: Card(
            //margin: EdgeInsets.only(left: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Color(0xffbea1ea),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    "assets/elifba/${_sesler[index].harf}.png",
                    height: 130,
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
          text: 'Sesli',
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
          ]),
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
                      List<Log> logList = await dbHelper.getLog();
                      if (logList.isNotEmpty) {
                        Log existingLog = logList.first;
                        existingLog.durum = 0;
                        existingLog.cikisTarih = formattedDateTime;
                        existingLog.girisTarih;
                        await dbHelper.updateLog(existingLog);
                        print(existingLog);
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
                                    user: widget.user,
                                    letter: widget.letter,
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
                      Navigator.of(context).pop();
                      _secondsLeft = 120;
                      startTimer();
                      skor = 0;
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
              ),
              SizedBox(height: 16),
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
                                    letter: widget.letter,
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
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _secondsLeft = 120;
                      startTimer();
                      skor = 0;
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
  void initState() {
    super.initState();
    _ses = _sesler.first;
    _sesler.shuffle();
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
                                      letter: widget.letter,
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
                        Navigator.pop(context);
                        //Navigator.of(context).pop();
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

  void logOut() {
    setState(() {
      if (GoogleSignInApi != null) {
        GoogleSignInApi.logout();
      }
    });
  }
}
