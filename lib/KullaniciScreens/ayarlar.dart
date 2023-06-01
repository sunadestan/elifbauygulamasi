import 'package:elifbauygulamasi/KullaniciScreens/home.dart';
import 'package:elifbauygulamasi/KullaniciScreens/oyunmenü.dart';
import 'package:elifbauygulamasi/KullaniciScreens/sifreyenile.dart';
import 'package:elifbauygulamasi/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../LoginScreens/login_page.dart';
import '../data/dbHelper.dart';
import '../data/googlesign.dart';
import '../models/Log.dart';
import '../models/game.dart';
import '../models/letter.dart';
import '../models/validation.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'dersmenü.dart';
import 'package:intl/intl.dart';

class AyarlarPage extends StatefulWidget {
  AyarlarPage(
      {Key? key,
      required this.letter,
      required this.user,
      required this.game,
      required this.name,
      required this.lastname,
      required this.email,
      required this.username})
      : super(key: key);
  final Letter letter;
  final User user;
  Game game;
  final name;
  final email;
  final username;
  final lastname;

  @override
  State<AyarlarPage> createState() => _AyarlarPageState(user);
}

enum Options { delete, update }

class _AyarlarPageState extends State<AyarlarPage> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _advancedDrawerController = AdvancedDrawerController();
  var txtusername = TextEditingController();
  var txtpassword = TextEditingController();
  var txtemail = TextEditingController();
  var txtname = TextEditingController();
  var txtlastname = TextEditingController();
  late String _email;
  late String _password;
  late String _userName;
  late String _name;
  late String _lastname;
  var dbHelper = DbHelper();
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  final log = Log();
  var dbhelper = DbHelper();

  User user;
  _AyarlarPageState(this.user);

  @override
  void initState() {
    txtname.text = user.name;
    txtlastname.text = user.lastname;
    txtpassword.text = user.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
        }
        Navigator.pushAndRemoveUntil(
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Ayarlar",
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
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customSizedBox(),
                    customSizedBox(),
                    Text(
                      "Hesap Bilgileri",
                      style: GoogleFonts.comicNeue(
                        color: Color(0xff935ccf),
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    customSizedBox(),
                    buildNameField(),
                    buildLastNameField(),
                    buildUserNameField(),
                    buildMailField(),
                    buildPasswordField(),
                    buildSaveButton(),
                  ],
                ),
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
                                    user: user,
                                    letter: widget.letter,
                                    name: widget.name,
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
                                    email: widget.email,
                                    lastname: widget.lastname,
                                    username: widget.username,
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
      ),
    );
  }

  Widget buildNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Ad",
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
            controller: txtname,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none, //kenarlıkları yok eder
              filled: true,
              hintText: (widget.name) + (widget.user.name),
            ),
            validator: validateName, //
            onSaved: (String? value) {
              _name = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget buildLastNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Soyad",
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
            controller: txtlastname,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none, //kenarlıkları yok eder
              filled: true,
              hintText: (widget.lastname) + (widget.user.lastname),
            ),
            validator: validateLastName, //
            onSaved: (String? value) {
              _lastname = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget buildUserNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Kullanıcı Adı",
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
            controller: txtusername,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              hintText: (widget.user.username),
            ),
            validator: validateUserName, //
            onSaved: (String? value) {
              _userName = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget buildMailField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "E-Posta",
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
            controller: txtemail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none, //kenarlıkları yok eder
              filled: true,
              hintText: (widget.email),
            ),
            validator: validateForgetPassword,
            onSaved: (String? value) {
              _email = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget buildPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Şifre",
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SifreYenile(
                            letter: widget.letter,
                            user: widget.user,
                            name: widget.name,
                            username: widget.username,
                            lastname: widget.lastname,
                            email: widget.email,
                            game: widget.game,
                          )));
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: "Şifreni yenile"),
          ),
        ],
      ),
    );
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User user = widget.user;
      //User? dbUser = await dbHelper.getUserById(user.id!);

      try {
        await dbHelper.updateUser(User.withId(
          user.id,
          txtusername.text,
          "",
          txtemail.text,
          txtname.text,
          "${widget.user.address}",
          txtlastname.text,
          "${widget.user.phone}",
          isadmin: 0,
          isVerified: 1,
        ));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Kullanıcı güncellendi"),
          duration: const Duration(seconds: 3),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Hata: Kullanıcı güncellenemedi"),
          duration: const Duration(seconds: 3),
        ));
      }
    }
  }

  Widget buildSaveButton() {
    return TextButton(
      onPressed: () async {
        _saveForm();
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
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff823ac6),
                  Color(0xff703dd0),
                ])),
        child: Text(
          "Kaydet",
          style: GoogleFonts.comicNeue(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void selectProcess(Options options) async {
    switch (options) {
      case Options.delete:
        _showResendDialog();
        break;
      default:
    }
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
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      String formattedDateTime =
                          DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
                      List<Log> logList = await dbhelper.getLog();
                      if (logList.isNotEmpty) {
                        Log existingLog = logList.first;
                        existingLog.durum = 0;
                        existingLog.cikisTarih = formattedDateTime;
                        existingLog.girisTarih;
                        await dbhelper.updateLog(existingLog);
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

  void logOut() {
    setState(() {
      if (GoogleSignInApi != null) {
        GoogleSignInApi.logout();
      }
    });
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
                textAlign: TextAlign.center,
                "Uyarı",
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                textAlign: TextAlign.center,
                "Hesabı kalıcı olarak silmek istediğinize emin misiniz?",
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontSize: 16,
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
                      dbHelper.delete(user.id!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(
                                  user: widget.user,
                                  game: widget.game,
                                  log: log,
                                )),
                      );
                      setState(() {});
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
    properties.add(StringProperty('_email', _email));
    properties.add(StringProperty('_password', _password));
    properties.add(StringProperty('_userName', _userName));
    properties.add(StringProperty('_name', _name));
    properties.add(StringProperty('_lastname', _lastname));
  }
}
