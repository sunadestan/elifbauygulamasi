import 'dart:math';
import 'package:elifbauygulamasi/LoginScreens/forgetpassword.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:elifbauygulamasi/reset/Deneme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../data/dbHelper.dart';
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
  var deneme = ResetPasswordPageUser();
  final int _initialSeconds = 120; // başlangıç süresini 2 dakikaya ayarla
  int _secondsRemaining = 120;
  late Timer _timer;
  late int zaman = 0;
  @override
  Widget build(BuildContext context) {
    var f = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Şifre sıfırlama kodu e-posta adresinize gönderildi.',
                  style: GoogleFonts.comicNeue(
                    fontSize: 16,
                    color: Color(0xff935ccf),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Şifre Sıfırlama Kodu',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Kod zorunlu';
                      } else if (value.length != 6) {
                        return 'Kod 6 haneli olmalı';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
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
    );
  }

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
                              builder: (context) => const LoginPage()));
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
                      Navigator.of(context).pop();
                      _startTimer();
                      sendEmail();
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

  Widget _entryField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.comicNeue(
              color: Color(0xff935ccf),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: kutucuk(),
          ),
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("6 Haneli Kodu Girin"),
      ],
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
        _stopTimer();
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
                              'Başarılı!',
                              style: GoogleFonts.comicNeue(
                                color: Colors.lightBlueAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              textAlign: TextAlign.center,
                              'Şifre sıfırlandıi',
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PasswordRecover(
                                              email: widget.email,
                                            )));
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

  Widget _gonderButton() {
    return ElevatedButton(
      child: _isLoading ? CircularProgressIndicator() : Text('Devam'),
      onPressed: _isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                if (widget.kod == codeController.text) {
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
                              'Başarılı!',
                              style: GoogleFonts.comicNeue(
                                color: Colors.lightBlueAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              textAlign: TextAlign.center,
                              'Şifre sıfırlanma ekranına gidiliyor.',
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
                                    _stopTimer();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PasswordRecover(
                                                  email: widget.email,
                                                )));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
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
            },
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
          "<h1>Merhaba</h1>\n<p>Şifrenizi sıfırlamak için aşağıdaki kodu kullanın: <strong>$resetCode</strong></p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('E-posta gönderildi: ' + sendReport.toString());
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
                  'Başarılı!',
                  style: GoogleFonts.comicNeue(
                    color: Colors.lightBlueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,
                  'Şifre sıfırlama bağlantısı gönderildi',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CodePage(
                                      email: widget.email,
                                      kod: resetCode,
                                    )));
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
    } on MailerException catch (e) {
      print('Hata: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hata'),
          content: Text('E-posta gönderilemedi'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } catch (e) {
      print('Hata: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hata'),
          content: Text('Beklenmeyen bir hata oluştu'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  List<Widget> kutucuk() {
    return List.generate(
      6,
      (index) => Container(
        height: 50,
        width: 50,
        child: TextFormField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: GoogleFonts.comicNeue(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
              fillColor: Color(0xfff3f3f4),
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              counter: null),
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus(); // bir sonraki kutuya odaklan
            }
          },
        ),
      ),
    );
  }
}

class PasswordRecover extends StatefulWidget {
  final String email;
  PasswordRecover({Key? key, required this.email}) : super(key: key);

  @override
  State<PasswordRecover> createState() => _PasswordRecoverState();
}

class _PasswordRecoverState extends State<PasswordRecover>
    with ValidationMixin {
  var txtpassWord = TextEditingController();
  var txtpassWord2 = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var dbHelper = DbHelper();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ForgetPasswordPage(
              )),
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
    return Scaffold(
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
                  buildPassword(),
                  buildPassword2(),
                  buildSaveButton(),
                ]),
          ),
        ),
      ),
    );
  }

  Widget buildPassword() {
    bool isPassword = true;
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
            validator: validatePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            controller: txtpassWord,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          )
        ],
      ),
    );
  }

  Widget buildPassword2() {
    bool isPassword = true;
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
            validator: validatePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            controller: txtpassWord2,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }

  late String _password;

  buildSaveButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate()){
          formKey.currentState!.save();
          var temp=await dbHelper.getUserByEmail(widget.email);
          if(txtpassWord.text==txtpassWord2.text){
            temp!.password=txtpassWord.text;
            await dbHelper.update(temp);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
          }
        }
      },
      child: Text(
        "Şifreyi güncelle",
        style: GoogleFonts.comicNeue(
          fontSize: 17,
          color: Color(0xff935ccf),
          fontWeight: FontWeight.w700,
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
