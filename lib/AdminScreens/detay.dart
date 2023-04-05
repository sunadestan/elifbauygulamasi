import 'dart:async';
import 'dart:io';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/dbHelper.dart';
import '../models/letter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/user.dart';
import 'liste.dart';
import 'package:path/path.dart' as path;

class DetayPage extends StatefulWidget {
  DetayPage({Key? key, required this.letter, required this.user})
      : super(key: key);
  final Letter letter;
  final User user;
  @override
  State<DetayPage> createState() => _DetayPageState(letter);
}

enum Options { delete, update }

class _DetayPageState extends State<DetayPage> with ValidationMixin {
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

  Letter letter;
  _DetayPageState(this.letter);
  var txtlettername = TextEditingController();
  var txtletterannotation = TextEditingController();
  var txtses;

  @override
  void initState() {
    txtlettername.text = letter.name!;
    txtletterannotation.text = letter.annotation!;
    super.initState();
    audioPlayer = AudioPlayer();
    _loadAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detay Sayfası"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ListePage(
                        user: widget.user,
                      )),
            );
          },
        ),
        actions: <Widget>[
          PopupMenuButton<Options>(
              onSelected: selectProcess,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
                    PopupMenuItem<Options>(
                      value: Options.delete,
                      child: Text("Sil"),
                    ),
                    PopupMenuItem<Options>(
                      value: Options.update,
                      child: Text("Güncelle"),
                    ),
                  ])
        ],
        backgroundColor: Color(0xFF975FD0),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              InkWell(
                onTap: getImage,
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
                      image: FileImage(File(widget.letter.imagePath ?? "")),
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
                decoration: BoxDecoration(
                  color: Color(0xffbea1ea),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.only(
                        bottom: 0,
                      ),
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40.0,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _isPlaying ? _pause() : _play();
                      },
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          getMusic();
                        },
                        icon: Icon(Icons.music_note, color: Colors.white),
                        label: Text(
                          musicPath == null
                              ? path.basename(widget.letter.musicPath ?? "Ses:")
                              : path.basename(musicPath!),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffbea1ea),
                          onPrimary: Colors.white,
                          elevation: 0,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          buildLetterName(),
          buildLetterAnnotation(),
          customSizedBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pause();
    audioPlayer.stop();
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

  Widget buildLetterName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Harf Ad",
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
            controller: txtlettername,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator: validateLetterName,
            //
            onSaved: (String? value) {
              _name = value!;
            },
          ),
        ],
      ),
    );
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

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Resim seçilmiş mi diye kontrol ediyoruz
      setState(() {
        imagePath = pickedFile.path;
        widget.letter.imagePath = imagePath;
      });
    }
  }

  void getMusicc() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (pickedFile != null && pickedFile.files.isNotEmpty) {
      musicPath = pickedFile.files.first.path!;
    }
  }

  void getMusic() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (pickedFile != null && pickedFile.files.isNotEmpty) {
      setState(() {
        musicPath = pickedFile.files.first.path!;
      });
      _loadAudio();
      _play();
    }
  }

  void selectProcess(Options options) {
    switch (options) {
      case Options.delete:
        _showResendDialog();
        break;
      case Options.update:
        updateLetter();
        _pause();
        break;
      default:
    }
  }

  void updateLetter() async {
    Letter updatedLetter = widget.letter.copyWith(
        imagePath: imagePath,
        musicPath: musicPath,
        name: txtlettername.text,
        annotation: txtletterannotation.text);
    await dbHelper.updateLetter(updatedLetter);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListePage(
                user: widget.user,
              )),
    );
    setState(() {});
  }

  Widget customSizedBox() => SizedBox(
        height: 20,
      );
  void _showResendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Silmek istediğinize emin misiniz"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            child: Text("Hayır"),
          ),
          TextButton(
            onPressed: () {
              dbHelper.deleteLetter(letter.id!).then((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListePage(
                            user: widget.user,
                          )),
                );
                setState(() {});
              });
            },
            child: Text("Evet"),
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
  }
}
