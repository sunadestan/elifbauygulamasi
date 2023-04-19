import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../LoginScreens/login_page.dart';
import '../data/dbHelper.dart';
import '../models/letter.dart';
import '../models/user.dart';
import 'ayarlar.dart';
import 'dersmenü.dart';
import 'home.dart';
import 'oyunmenü.dart';

class ses extends StatefulWidget {
  ses({Key? key,required this.user,required this.letter}) : super(key: key,);
  final User user;
  final Letter letter;

  @override
  State<ses> createState() => _sesState();
}

class _sesState extends State<ses> with TickerProviderStateMixin {
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  final AudioPlayer audioPlayer = AudioPlayer();
  final _advancedDrawerController = AdvancedDrawerController();
  late AnimationController _animationController;
  int _secondsLeft = 120;
  int _pausedTime = 0;
  bool _isPaused = false;
  late Timer _timer;
  late String musicPath;
  bool _isPlaying = false;
  late Future<List<Letter>> _lettersFuture;
  var dbHelper = DbHelper();
  late Letter _resim;

  @override
  void initState() {
    super.initState();
    _lettersFuture = liste();
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

  Future<List<Letter>> liste() async {
    final result = await dbHelper.getLetters();
    List<Letter> randomLetters = [];
    Random random = new Random();
    for (var i = 0; i < 5; i++) {
      randomLetters.add(result[random.nextInt(result.length)]);
    }
    return randomLetters;
  }

  Future<void> _loadAudio() async {
    try {
      await audioPlayer.setUrl(musicPath);
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  Future<void> _play(Letter harf) async {
    int result = await audioPlayer.play(harf.musicPath!);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _timer.cancel();
        bool exit =await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OyunSinifi(user: widget.user)),
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
            title: Text("Esre Harfler",
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
                    _timer.cancel();
                    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> OyunSinifi(user: widget.user)), (route) => false);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> OyunSinifi(user: widget.user)),);
                  },
                  icon: Icon(Icons.exit_to_app)
              )
            ],
          ),
          body: Center(
            child: Column(
              children: [
                customSizedBox(),
                row(),
                customSizedBox(),
                Expanded(
                  child: FutureBuilder<List<Letter>>(
                    future: _lettersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final letters = snapshot.data;
                        return Container(
                          margin: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: List.generate(
                                    letters!.length,
                                    (index) => ses(letters![index]),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: List.generate(
                                    letters!.length,
                                    (index) => kutuu(letters![index]),
                                  ),
                                ),
                              ),
                            ],
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
                              builder: (context) =>
                                  OyunSinifi(user: widget.user)));
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
  Widget row() {
    return Row(
      children: [
        timer(),
        _title(),
      ],
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
                      _secondsLeft = 120;
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
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()), (route) => false);

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

  Widget kutuu(Letter harf) {
    return Column(
      children: [
        InkWell(
          onTap: () async {},
          child: Container(
            child: Center(
              child: Card(
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
                      Image.file(
                        File(harf.imagePath ?? ""),
                        //fit: BoxFit.cover,
                        height: 90,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ses(Letter harf) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await _loadAudio();
            if (_isPlaying) {
              await _pause();
              _play(harf);
              setState(() {
                _isPlaying = false;
              });
            } else {
              await _play(harf);
              setState(() {
                _isPlaying = true;
              });
            }
          },
          child: Container(
            child: Center(
              child: Card(
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
                        "assets/elifba/ses/ses.jpg",
                        //fit: BoxFit.cover,
                        height: 90,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  void _handleMenuButtonPressed() {
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  Widget customSizedBox() => SizedBox(
    height: 20,
  );
}
