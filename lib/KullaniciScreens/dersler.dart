import 'dart:io';
import 'package:elifbauygulamasi/KullaniciScreens/home.dart';
import 'package:elifbauygulamasi/KullaniciScreens/oyunsinifi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../LoginScreens/login_page.dart';
import '../data/dbHelper.dart';
import '../models/letter.dart';
import '../models/user.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'ayarlar.dart';


class Dersler extends StatefulWidget {
  Dersler({Key? key, required this.user, required this.letter})
      : super(key: key);
  User user;
  Letter letter;

  @override
  State<Dersler> createState() => _DerslerState();
}

class _DerslerState extends State<Dersler> {
  final _advancedDrawerController = AdvancedDrawerController();
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  var user = User("", "", "", "", "", "", "", isadmin: 0);
  late Future<List<Letter>> _lettersFuture;
  var dbHelper = DbHelper();
  AudioPlayer audioPlayer = AudioPlayer();
  late String musicPath;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _lettersFuture = liste();
  }

  Future<List<Letter>> liste() async {
    final result = await dbHelper.getLetters();
    return result;
  }

  @override
  void dispose() {
    _pause();
    audioPlayer.stop();
    super.dispose();
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
        body: Center(
          child: Column(
            children: [
              customSizedBox(),
              _title(),
              customSizedBox(),
              Expanded(
                child: FutureBuilder<List<Letter>>(
                  future: _lettersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final letters = snapshot.data;
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: GridView.count(
                          crossAxisCount: 4,
                          childAspectRatio: 0.8,
                          children: List.generate(
                            letters!.length,
                            (index) => kutuu(letters[index]),
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
                              letter: letter,
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
                            builder: (context) => OyunSinifi(user: user)));
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
                              letter: widget.letter,
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

  Future<void> _loadAudio() async {
    try {
      await audioPlayer.setUrl(musicPath);
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  Future<void> _play(Letter letter) async {
    int result = await audioPlayer.play(letter.musicPath!);
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

  Widget yazi(Letter letters) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            letters.name ?? "",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget kutuu(Letter letters) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await _loadAudio();
            if (_isPlaying) {
              await _pause();
              _play(letter);
              setState(() {
                _isPlaying = false;
              });
            } else {
              await _play(letters);
              setState(() {
                _isPlaying = true;
              });
            }
            _showResendDialog(letters);
          },
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
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.file(
                        File(letters.imagePath ?? ""),
                        fit: BoxFit.cover,
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
                fontWeight: FontWeight.w700,shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.grey,
                  offset: Offset(2.0, 2.0),
                ),
              ],),
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


  void _showResendDialog(Letter selectedLetter) {
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
                Text(selectedLetter.name ?? "",
                  style: GoogleFonts.comicNeue(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.lightBlueAccent,
                  ),),
                SizedBox(height: 16),
                Text(selectedLetter.annotation ?? "",
                  style: GoogleFonts.comicNeue(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 18,
                  ),),
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
                        _pause();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
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

  void _handleMenuButtonPressed() {
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  Widget customSizedBox() => SizedBox(
        height: 20,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('_isPlaying', _isPlaying));
  }
}
