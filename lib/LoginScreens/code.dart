import 'dart:math';
import 'package:elifbauygulamasi/models/user.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../data/dbHelper.dart';
import '../models/Log.dart';
import '../models/game.dart';
import 'login_page.dart';

class CodePage extends StatefulWidget {
  final String email;
  final String kod;
  CodePage({required this.email, required this.kod});

  @override
  State<CodePage> createState() => _CodeState();
}

class _CodeState extends State<CodePage> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();
  bool _isLoading = false;
  final int _initialSeconds = 120; // başlangıç süresini 2 dakikaya ayarla
  int _secondsRemaining = 120;
  late Timer _timer;
  late int zaman = 0;
  Game? game;
  final log = Log();

  final user =User("", "", "", "", "", "", "", isadmin: 0, isVerified: 0, isGoogleUser: 0);
  @override
  Widget build(BuildContext context) {
    var f = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(user: user,game: game!,log: log,)),
              (route) => false,
        );
        return false; // Geri tuşu işleme alınmadı
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        height: f * .20,
                        //width:f* .100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/images/topImage.png")),
                        ),
                      ),
                      Positioned(
                          top: 0, left: 0, bottom: 0, child: _backButton()),
                      customSizedBox(),
                      customSizedBox(),
                    ],
                  ),
                  _title(),
                  customSizedBox(),
                  customSizedBox(),
                  buildForgetPasswordField(),
                  _gonderButtton(),
                  SizedBox(height: 20),
                  Text(
                    "Kalan Saniye: $_secondsRemaining",
                    style: GoogleFonts.comicNeue(
                      color: Color(0xff935ccf),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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
  Widget buildForgetPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Şifre Sıfırlama Kodu",
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
            controller: codeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Kod zorunlu';
              } else if (value.length != 6) {
                return 'Kod 6 haneli olmalı';
              }
              return null;
            },
          ),
        ],
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
  Widget customSizedBox() => SizedBox(height: 20,);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _stopTimer();
          _secondsRemaining = _initialSeconds;
          _showResendDialog();
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
    // _timer = 0;
  }

  void _showResendDialog() {
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
                "Süre Doldu",
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Yeniden gönderelim mi?",
                style: GoogleFonts.comicNeue(
                  //color: Colors.lightBlueAccent,
                  fontSize: 16,
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
                      _timer.cancel();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(log: log,game: game!,user: user,)));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      "İptal Et",
                      style: GoogleFonts.comicNeue(
                        fontWeight: FontWeight.w600,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      sendEmail();
                      _startTimer();
                      if (_formKey.currentState!.validate()) {
                        if (widget.kod == codeController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Kod doğru"))
                          );
                          _timer.cancel();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasswordRecover(
                                    email: widget.email,
                                  )));
                        }else{ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Kod yanlış"))
                        );}
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                    ),
                    child: Text(
                      "Yeniden Gönder",
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

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(user: user,game: game!,log: log,)),
              (route) => false,
        );
        _timer.cancel();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 15,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 0,
                top: 0,
                bottom: 0,
              ),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            Text(
              "Geri",
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gonderButtton() {
    return TextButton(
      onPressed: _isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                if (widget.kod == codeController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Kod doğru"))
                  );
                  _timer.cancel();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordRecover(
                            email: widget.email,
                          )));
                }else{ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Kod yanlış"))
                );}
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
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff823ac6),
                  Color(0xff703dd0),
                ])),
        child: Text(
          "Devam",
          style: GoogleFonts.comicNeue(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void sendEmail() async {
    String username = 'sunasumeyyedestan@gmail.com'; // gönderen e-posta adresi
    String password = 'ptuetlymfkuqklyu'; // gönderen e-posta adresi şifresi
    final smtpServer = gmail(username, password);

    final random = Random();
    final resetCode = random
        .nextInt(1000000)
        .toString()
        .padLeft(6, '0'); // 6 haneli rastgele sayı oluştur

    final message = Message()
      ..from = Address(username, 'Şifre Sıfırlama Uygulaması')
      ..recipients.add(widget.email)
      ..subject = 'Şifre Sıfırlama İsteği'
      ..text =
          'Merhaba, şifrenizi sıfırlamak için aşağıdaki kodu kullanın: $resetCode'
      ..html =
          "<h1>Merhaba2</h1>\n<p>Şifrenizi sıfırlamak için aşağıdaki kodu kullanın: <strong>$resetCode</strong></p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('E-posta gönderildi: ' + sendReport.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Şifre sıfırlama kodu e-posta adresinize gönderildi."))
      );
    } on MailerException catch (e) {
      print('Hata: $e');
      showDialog(
        barrierDismissible: false,
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
                  'Hata!',
                  style: GoogleFonts.comicNeue(
                    color: Colors.lightBlueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,
                  'E-posta gönderilemedi',
                  style: GoogleFonts.comicNeue(
                    color: Colors.black,
                    fontSize: 15,
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
                        _timer.cancel();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage(log: log,game: game!,user: user,)),
                                (route) => false);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text(
                        'Tamam',
                        style: GoogleFonts.comicNeue(
                          fontWeight: FontWeight.w600,
                          color: Colors.lightBlueAccent,
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
    } catch (e) {
      print('Hata: $e');
      showDialog(
        barrierDismissible: false,
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
                  'Hata!',
                  style: GoogleFonts.comicNeue(
                    color: Colors.lightBlueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,
                  'Beklenmeyen bir hata oluştu',
                  style: GoogleFonts.comicNeue(
                    color: Colors.black,
                    fontSize: 15,
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
                        _timer.cancel();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage(log: log,game: game!,user: user,)),
                                (route) => false);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text(
                        'Tamam',
                        style: GoogleFonts.comicNeue(
                          fontWeight: FontWeight.w600,
                          color: Colors.lightBlueAccent,
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
  }
}

class PasswordRecover extends StatefulWidget {
  final String email;
  PasswordRecover({Key? key, required this.email}) : super(key: key);

  @override
  State<PasswordRecover> createState() => _PasswordRecoverState();
}

class _PasswordRecoverState extends State<PasswordRecover> with ValidationMixin {
  var txtpassWord = TextEditingController();
  var txtpassWord2 = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var dbHelper = DbHelper();
  late String _password;
  final user =User("", "", "", "", "", "", "", isadmin: 0, isVerified: 0, isGoogleUser: 0);
  final game = Game(durum: 0, kullaniciId: 0,seviyeKilit: 0);
  final log = Log();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(game: game,user: user,log: log,)),
              (route) => false,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 15,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 0,
                top: 0,
                bottom: 0,
              ),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            Text(
              "Geri",
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var f = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(game: game,user: user,log: log,)),
              (route) => false,
        );
        return false; // Geri tuşu işleme alınmadı
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          height: f * .20,
                          //width:f* .100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/topImage.png")),
                          ),
                        ),
                        Positioned(
                            top: 0, left: 0, bottom: 0, child: _backButton()),
                      ],
                    ),
                    SizedBox(height: 16,),
                    buildForgetPasswordField(),
                    buildForgetPasswordField2(),
                    SizedBox(height: 16,),
                    buildSaveButton(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildForgetPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
            controller: txtpassWord,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator: validatePassword,
          ),
        ],
      ),
    );
  }
  Widget buildForgetPasswordField2() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Şifre Tekrar",
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
            controller: txtpassWord2,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator: validatePassword,
          ),
        ],
      ),
    );
  }

  buildSaveButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate()){
          formKey.currentState!.save();
          var temp=await dbHelper.getUserByEmail(widget.email);
          if(txtpassWord.text==txtpassWord2.text){
            temp!.password=txtpassWord.text;
            await dbHelper.update(temp);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(log: log,game: game,user: user,)));
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Şifre güncelendi!"))
            );
          } else {
            // Şifreler eşit değilse uyarı mesajı göster
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Girilen şifreler eşit değil!"))
            );
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
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff823ac6),
                  Color(0xff703dd0),
                ])),
        child: Text(
          "Şifreyi Güncelle",
          style: GoogleFonts.comicNeue(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_password', _password));
  }
}
