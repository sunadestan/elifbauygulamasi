import 'dart:io';
import 'package:elifbauygulamasi/AdminScreens/listeler/%C3%B6treliste.dart';
import 'package:elifbauygulamasi/AdminScreens/listeler/%C3%BCst%C3%BCnliste.dart';
import 'package:elifbauygulamasi/AdminScreens/admin.dart';
import 'package:elifbauygulamasi/AdminScreens/listeler/esreliste.dart';
import 'package:elifbauygulamasi/data/dbHelper.dart';
import 'package:elifbauygulamasi/hakkimizda.dart';
import 'package:elifbauygulamasi/models/harfharake.dart';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import '../../LoginScreens/login_page.dart';
import '../../models/Log.dart';
import '../../models/game.dart';
import '../../models/letter.dart';
import 'package:flutter/widgets.dart';
import '../../models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../harfeklememenü.dart';
import '../listemenü.dart';
import '../log.dart';

class Harake extends StatefulWidget {
  Harake({
    Key? key,
    required this.user,
    required this.letter,
    required this.harf,
    required this.deneme,
    required this.log,
    required this.denemeiki,
  }) : super(key: key);
  final User user;
  final Letter letter;
  final Harfharake harf;
  final int deneme;
  final int denemeiki;
  Log log;

  @override
  _HarfEkleState createState() => _HarfEkleState();
}

class _HarfEkleState extends State<Harake> with ValidationMixin {
  String? harfharakeimage_path;
  final _advancedDrawerController = AdvancedDrawerController();

  String? harfharakemusic_path;
  String? harfharakename;
  String? harfharakeannotation;

  var txtharfharakename = TextEditingController();
  var txtlharfharakeannotation = TextEditingController();
  final game = Game(durum: 0, kullaniciId: 0, seviyeKilit: 0);

  final picker = ImagePicker();
  final dbHelper = DbHelper();
  final _formKey = GlobalKey<FormState>();

  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;
  int? _selectedHarfTur;

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
              'Harekeli Harf Ekle',
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
                                  log: widget.log,
                                  denemeiki: widget.denemeiki,
                                  user: widget.user,
                                  deneme: widget.deneme,
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
                  checBox(context),
                  harfharakemusic_path == null
                      ? Container()
                      : Text(
                          basename(harfharakemusic_path!),
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
                                log: widget.log,
                                denemeiki: widget.denemeiki)),
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
                                log: widget.log,
                                denemeiki: widget.denemeiki)),
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

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      harfharakeimage_path = pickedFile!.path;
    });
  }

  Future getMusic() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    setState(() {
      harfharakemusic_path = pickedFile!.files.first.path!;
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
            controller: txtharfharakename,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator: validateLetterName,
            //
            onSaved: (String? value) {
              harfharakename = value!;
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
            controller: txtlharfharakeannotation,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator: validateLetterAciklama,
            onSaved: (String? value) {
              harfharakeannotation = value!;
            },
          ),
        ],
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
                      image: harfharakeimage_path != null
                          ? DecorationImage(
                              image: FileImage(File(harfharakeimage_path!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: harfharakeimage_path == null
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

  Widget _ekleButton(context) {
    return TextButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          if (_selectedHarfTur == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UstunListePage(
                        denemeiki: widget.denemeiki,
                        log: widget.log,
                        user: widget.user,
                        deneme: _selectedHarfTur!)));
            await saveToDatabase();
            _showResendDialog(context);
          } else if (_selectedHarfTur == 2) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => EsreListePage(
                        denemeiki: widget.denemeiki,
                        log: widget.log,
                        user: widget.user,
                        deneme: _selectedHarfTur!)));
            await saveToDatabase();
            _showResendDialog(context);
          } else if (_selectedHarfTur == 3) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => OtreListePage(
                        denemeiki: widget.denemeiki,
                        log: widget.log,
                        user: widget.user,
                        deneme: _selectedHarfTur!)));
            await saveToDatabase();
            _showResendDialog(context);
          } else {
            _hatashowResendDialog(context);
          }
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

  /* Widget checBox(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CheckboxListTile(
          value: _selectedHarfTur == 1,
          onChanged: (bool? value) {
            setState(() {
              _selectedHarfTur = value! ? 1 : null;
            });
          },
          title: Text(
            'Üstün',
            style: TextStyle(
              color: Color(0xff935ccf),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        CheckboxListTile(
          value: _selectedHarfTur == 2,
          onChanged: (bool? value) {
            setState(() {
              _selectedHarfTur = value! ? 2 : null;
            });

          },
          title: Text(
            'Esre',
            style: TextStyle(
              color: Color(0xff935ccf),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        CheckboxListTile(
          value: _selectedHarfTur == 3,
          onChanged: (bool? value) {
            setState(() {
              _selectedHarfTur = value! ? 3 : null;
            });

          },
          title: Text(
            'Ötre',
            style: TextStyle(
              color: Color(0xff935ccf),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }*/
  Widget checBox(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: RadioListTile(
            value: 1,
            groupValue: _selectedHarfTur,
            onChanged: (int? value) {
              setState(() {
                _selectedHarfTur = value!;
              });
            },
            title: Text(
              'Üstün',
              style: GoogleFonts.comicNeue(
                color: Color(0xff935ccf),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Expanded(
          child: RadioListTile(
            value: 2,
            groupValue: _selectedHarfTur,
            onChanged: (int? value) {
              setState(() {
                _selectedHarfTur = value!;
              });
            },
            title: Text(
              'Esre',
              style: GoogleFonts.comicNeue(
                color: Color(0xff935ccf),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Expanded(
          child: RadioListTile(
            value: 3,
            groupValue: _selectedHarfTur,
            onChanged: (int? value) {
              setState(() {
                _selectedHarfTur = value!;
              });
            },
            title: Text(
              'Ötre',
              style: GoogleFonts.comicNeue(
                color: Color(0xff935ccf),
                fontSize: 15,
                fontWeight: FontWeight.w700,
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

  Future<void> saveToDatabase() async {
    var result = await dbHelper.insertHarfharake(
      Harfharake(
        harfharakename: txtharfharakename.text,
        harfharakeannotation: txtlharfharakeannotation.text,
        harfharakeimage_path: harfharakeimage_path,
        harfharakemusic_path: harfharakemusic_path,
        harfTur: _selectedHarfTur,
      ),
    );
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
                txtharfharakename.text,
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

  void _hatashowResendDialog(context) {
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
                'Lütfen Hareke seçin!',
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
                      Navigator.pop(context);
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
                                    game: game,
                                    log: widget.log,
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

  void _handleMenuButtonPressed() {
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_name', harfharakename));
    properties.add(StringProperty('_aciklama', harfharakeannotation));
  }
}
