import 'dart:async';
import 'dart:io';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../AdminScreens/liste.dart';
import '../data/dbHelper.dart';
import '../models/letter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/user.dart';
import 'package:path/path.dart' as path;

import 'dersler.dart';

class HarfBilgisiPage extends StatefulWidget {
  HarfBilgisiPage({Key? key, required this.letter, required this.user})
      : super(key: key);
  final Letter letter;
  final User user;
  @override
  State<HarfBilgisiPage> createState() => _HarfBilgisiPage(letter);
}

enum Options { delete, update }

class _HarfBilgisiPage extends State<HarfBilgisiPage> with ValidationMixin {
  late final Letter letters = widget.letter;

  var dbHelper = DbHelper();

  ImagePicker picker = ImagePicker();
  AudioPlayer audioPlayer = AudioPlayer();

  String? imagePath;
  String? musicPath;
  String? _name;
  String? _aciklama;
  String? _ses;
  bool _isPlaying = false;
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");


  _HarfBilgisiPage(letter);
  var txtlettername = TextEditingController();
  var txtletterannotation = TextEditingController();
  var txtses;
  late Future<List<Letter>> _lettersFuture;
  @override
  void initState() {
    Letter letter=widget.letter;

    txtlettername.text = letter.name!;
    txtletterannotation.text = letter.annotation!;
    super.initState();
    audioPlayer = AudioPlayer();
    _loadAudio();
    _lettersFuture = liste();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harf Bilgisi' +
            "  " +
            '${widget.letter.name}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _pause();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dersler(user: widget.user,letter: letter,)),
            );

          },
        ),
        backgroundColor: Color(0xFF975FD0),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              InkWell(
                onTap: (){},
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(widget.letter.imagePath!)),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              musicPath == null
                  ? Container()
                  : Text(
                path.basename(musicPath!),
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.right,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),

                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.only(bottom: 0,),
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40.0,
                        color: Color(0xffbea1ea),
                      ),
                      onPressed: () {
                        _isPlaying ? _pause() : _play();
                      },
                    ),
                  ],
                ),
              )

            ],
          ),
          buildLetterAnnotation(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pause();
    audioPlayer.stop(); // add this line to stop audio playback
    super.dispose();
  }
  Future<void> _loadAudio() async {
    try {
      await audioPlayer.setUrl(musicPath ?? widget.letter.musicPath!);
    } catch (e) {
      print('Error loading audio: $e');
    }
  }
  Future<void> _play() async {
    int result = await audioPlayer.play(musicPath ?? widget.letter.musicPath!);
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
  Future<List<Letter>> liste() async {
    final result = await dbHelper.getLetters();
    return result;
  }
  Widget buildLetterAnnotation() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Harf Açıklaması",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xff935ccf),
                fontSize: 15),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: txtletterannotation,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator: validateLetterAciklama,
            onSaved: (String? value) {
              _aciklama = value!;
            },
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_name', _name));
    properties.add(StringProperty('_aciklama', _aciklama));
    properties.add(StringProperty('_ses', _ses));
    properties.add(DiagnosticsProperty<bool>('_isPlaying', _isPlaying));
    properties.add(DiagnosticsProperty<Future<List<Letter>>>('_lettersFuture', _lettersFuture));
  }
}
