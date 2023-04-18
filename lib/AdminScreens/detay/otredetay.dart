import 'dart:async';
import 'dart:io';
import 'package:elifbauygulamasi/AdminScreens/listeler/%C3%BCst%C3%BCnliste.dart';
import 'package:elifbauygulamasi/models/harfharake.dart';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../LoginScreens/login_page.dart';
import '../../data/dbHelper.dart';
import '../../models/letter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../models/user.dart';
import '../admin.dart';
import '../harfeklememenü.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../listeler/ötreliste.dart';
import '../listemenü.dart';

class OtrePage extends StatefulWidget {
  OtrePage(
      {Key? key,
        required this.letter,
        required this.user,
        required this.deneme,
        required this.harf})
      : super(key: key);
  final Letter letter;
  final User user;
  final int deneme;
  final Harfharake harf;
  @override
  State<OtrePage> createState() => _OtrePageState(harf);
}

enum Options { delete, update }

class _OtrePageState extends State<OtrePage> with ValidationMixin {
  late final Harfharake harfler = widget.harf;
  final _advancedDrawerController = AdvancedDrawerController();
  late int deneme;

  var dbHelper = DbHelper();

  ImagePicker picker = ImagePicker();
  AudioPlayer audioPlayer = AudioPlayer();

  String? imagePath;
  String? musicPath;
  String? _name;
  String? _aciklama;
  String? _ses;
  bool _isPlaying = false;

  Harfharake harf;
  _OtrePageState(this.harf);
  var txtlettername = TextEditingController();
  var txtletterannotation = TextEditingController();
  var txtses;

  @override
  void initState() {
    txtlettername.text = harf.harfharakename!;
    txtletterannotation.text = harf.harfharakeannotation!;
    super.initState();
    audioPlayer = AudioPlayer();
    _loadAudio();
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
          title: Text(
            "Harf Detayı",
            style: GoogleFonts.comicNeue(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
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
          actions: <Widget>[
            PopupMenuButton<Options>(
                onSelected: selectProcess,
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<Options>>[
                  PopupMenuItem<Options>(
                    value: Options.delete,
                    child: Text(
                      "Harfi sil",
                      style: GoogleFonts.comicNeue(
                        fontWeight: FontWeight.w700,
                        //color: Colors.black,
                      ),
                    ),
                  ),
                  PopupMenuItem<Options>(
                    value: Options.update,
                    child: Text(
                      "Güncelle",
                      style: GoogleFonts.comicNeue(
                        fontWeight: FontWeight.w700,
                        //color: Colors.black,
                      ),
                    ),
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
                        image: FileImage(
                            File(widget.harf.harfharakeimage_path ?? "")),
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
                                ? path.basename(
                                widget.harf.harfharakemusic_path ?? "Ses:")
                                : path.basename(musicPath!),
                            style: GoogleFonts.comicNeue(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
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
            customSizedBox(),
            buildLetterName(),
            buildLetterAnnotation(),
            customSizedBox(),
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
                          builder: (context) => AdminPage(
                            user: widget.user,
                            deneme: widget.deneme,
                          )),
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
                "Harfi kalıcı olarak silmek istediğinize emin misiniz?",
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      dbHelper.deleteHarfharake(harf.id!);
                      setState(() {});
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtreListePage(
                              user: widget.user,
                              deneme: widget.deneme,
                            )),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Evet',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  @override
  void dispose() {
    _pause();
    audioPlayer.stop();
    super.dispose();
  }

  Future<void> _loadAudio() async {
    try {
      await audioPlayer.setUrl(musicPath ?? widget.harf.harfharakemusic_path!);
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  Future<void> _play() async {
    int result =
    await audioPlayer.play(musicPath ?? widget.harf.harfharakemusic_path!);
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

  Future<List<Harfharake>> liste() async {
    final result = await dbHelper.getHarfharake();
    return result;
  }

  Widget buildLetterName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Harf Adı",
            style: GoogleFonts.comicNeue(
              color: Color(0xff935ccf),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
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
            style: GoogleFonts.comicNeue(
              color: Color(0xff935ccf),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
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
        updateHareke();
        _pause();
        break;
      default:
    }
  }

  void updateHareke() async {
    Harfharake updateHarfharake = widget.harf.copyWith(
      harfharakeimage_path: imagePath,
      harfharakemusic_path: musicPath,
      harfharakename: txtlettername.text,
      harfharakeannotation: txtletterannotation.text,
    );
    await dbHelper.updateHarfharake(updateHarfharake);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OtreListePage(
            user: widget.user,
            deneme: widget.deneme,
          )),
    );
    setState(() {});
  }

  Widget customSizedBox() => SizedBox(
    height: 20,
  );

  void _handleMenuButtonPressed() {
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
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
