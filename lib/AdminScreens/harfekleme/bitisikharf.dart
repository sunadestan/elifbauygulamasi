import 'package:elifbauygulamasi/AdminScreens/listeler/bitisikliste.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:elifbauygulamasi/data/dbHelper.dart';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import '../../LoginScreens/login_page.dart';
import '../../hakkimizda.dart';
import '../../models/Log.dart';
import '../../models/bitisik.dart';
import '../../models/game.dart';
import '../../models/letter.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import '../../models/user.dart';
import '../admin.dart';
import '../harfeklememenü.dart';
import '../listemenü.dart';
import '../log.dart';

class BitisikHarf extends StatefulWidget {
  BitisikHarf(
      {Key? key,
      required this.user,
      required this.letter,
      required this.denemeiki,
      required this.deneme,
      required this.log})
      : super(key: key);
  final User user;
  final Letter letter;
  final int deneme;
  final int denemeiki;
  Log log;

  @override
  State<BitisikHarf> createState() => _BitisikHarfState();
}

class _BitisikHarfState extends State<BitisikHarf> {
  String? imagePath;
  final _advancedDrawerController = AdvancedDrawerController();

  String? musicPath;
  String? _name;
  String? _aciklama;
  final game = Game(durum: 0, kullaniciId: 0, seviyeKilit: 0);

  var txtlettername = TextEditingController();
  var txtletterannotation = TextEditingController();

  final picker = ImagePicker();
  final dbHelper = DbHelper();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HarfeklemeMenu(
                    log: widget.log,
                    denemeiki: widget.denemeiki,
                    user: widget.user,
                    deneme: widget.deneme,
                  )),
          (route) => false,
        );
        return false; // Geri tuşu işleme alınmadı
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
            title: Text(
              'Birleşik Harf Ekle',
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
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
                            builder: (context) => HarfeklemeMenu(
                                  denemeiki: widget.denemeiki,
                                  user: widget.user,
                                  deneme: widget.deneme,
                                  log: widget.log,
                                )),
                        (route) => false);
                  },
                  icon: Icon(Icons.exit_to_app))
            ],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  customSizedBox(),
                  _title(),
                  customSizedBox(),
                  customSizedBox(),
                  buildLetterName(),
                  buildLetterAnnotation(),
                  buildTopField(),
                  musicPath == null
                      ? Container()
                      : Text(
                          basename(musicPath!),
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.right,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  _ekleButton(context),
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
                            builder: (context) => AdminPage(
                                  user: widget.user,
                                  deneme: widget.deneme,
                                  denemeiki: widget.denemeiki,
                                  log: widget.log,
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
                                  denemeiki: widget.denemeiki,
                                  log: widget.log,
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
                                  denemeiki: widget.denemeiki,
                                  log: widget.log,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LogGiris(
                                  user: widget.user,
                                  deneme: widget.deneme,
                                  denemeiki: widget.denemeiki,
                                  log: widget.log,
                                )),
                      );
                    },
                    leading: Icon(Icons.verified_user_outlined),
                    title: Text(
                      'Giriş Bilgileri',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _showResendDialogg(context);
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
                          MaterialPageRoute(builder: (context) => Hakkimizda()),
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

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = pickedFile!.path;
    });
  }

  Future getMusic() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    setState(() {
      musicPath = pickedFile!.files.first.path!;
    });
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

  Widget _ekleButton(context) {
    return TextButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          saveToDatabase();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BitisikListe(
                      user: widget.user,
                      denemeiki: widget.denemeiki,
                      deneme: widget.deneme,
                      log: widget.log,
                    )),
          );
          _showResendDialog(context);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 75,
        ),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffad89d7),
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff9a6ed3),
                  Color(0xffbea1ea),
                  Color(0xff9a6ed3),
                ])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ekle",
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopField() {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: getImage,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Görsel Ekle",
                    style: GoogleFonts.comicNeue(
                      color: Color(0xff935ccf),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xff935ccf)),
                      image: imagePath != null
                          ? DecorationImage(
                              image: FileImage(File(imagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imagePath == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 32.0,
                            color: Color(0xff935ccf),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: getMusic,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Ses Ekle",
                    style: GoogleFonts.comicNeue(
                      color: Color(0xff935ccf),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xff935ccf)),
                      ),
                      alignment: Alignment.center,
                      width: 100.0,
                      height: 100.0,
                      child: Icon(
                        Icons.my_library_music_sharp,
                        size: 32.0,
                        color: Color(0xff935ccf),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> saveToDatabase() async {
    var result = await dbHelper.insertBitisikHarf(BitisikHarfler(
      harfinadi: txtlettername.text,
      harfinaciklamasi: txtletterannotation.text,
      ses_path: musicPath,
      image_path: imagePath,
    ));
    if (result > 0) {
      print("Data has been saved successfully.");
    } else {
      print("Data could not be saved.");
    }
  }

  void _showResendDialog(context) {
    showDialog(
      context: context,
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
                "Kayıt Başarılı",
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                txtlettername.text,
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  //fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResendDialogg(context) {
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
                      dbHelper.getCurrentUser().then((currentUser) {
                        if (currentUser != null) {
                          dbHelper
                              .updateUserhesapById(widget.user.id!, 0)
                              .then((_) {
                            setState(() {});
                          });
                        } else {
                          setState(() {});
                        }
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(
                                    log: widget.log,
                                    game: game,
                                    user: widget.user,
                                  )),
                          (route) => false);
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

  Widget customSizedBox() => SizedBox(
        height: 20,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_name', _name));
    properties.add(StringProperty('_aciklama', _aciklama));
  }
}
