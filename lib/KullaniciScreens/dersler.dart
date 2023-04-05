import 'dart:io';
import 'package:elifbauygulamasi/KullaniciScreens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/dbHelper.dart';
import '../models/letter.dart';
import '../models/user.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';


class Dersler extends StatefulWidget {
  Dersler({Key? key, required this.user, required this.letter})
      : super(key: key);
  User user;
  Letter letter;

  @override
  State<Dersler> createState() => _DerslerState();
}

class _DerslerState extends State<Dersler> {
  late Future<List<Letter>> _lettersFuture;
  var dbHelper = DbHelper();
  AudioPlayer audioPlayer = AudioPlayer();
  late String musicPath;
  bool _isPlaying = false;

  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  //var user = User("", "", "", "", "", "", "", isadmin: 0);

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Harfler",
            style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900)),
        backgroundColor: Color(0xFF975FD0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _pause();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          user: widget.user,
                          letter: letter,
                        )));
          },
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
      builder: (context) => AlertDialog(
        title: Text(selectedLetter.name ?? "",
          style: GoogleFonts.comicNeue(
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectedLetter.annotation ?? "",
              style: GoogleFonts.comicNeue(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Tamam',
              style: GoogleFonts.comicNeue(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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
