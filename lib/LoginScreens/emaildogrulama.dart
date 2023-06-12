import 'package:elifbauygulamasi/data/dbHelper.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../data/googlesign.dart';
import '../models/Log.dart';
import '../models/game.dart';
import '../models/user.dart';
import 'login_page.dart';
import 'package:intl/intl.dart';

class MailDogrulama extends StatefulWidget {
  final String email;
  final String kod;
  final User user;
  MailDogrulama({
    Key? key,
    required this.email,
    required this.kod,
    required this.user,
  }) : super(key: key);

  @override
  State<MailDogrulama> createState() => _MailDogrulamaState();
}

class _MailDogrulamaState extends State<MailDogrulama> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  var codeController = TextEditingController();
  var dbhelper = DbHelper();
  bool _isLoading = false;
  final int _initialSeconds = 120;
  int _secondsRemaining = 120;
  late Timer _timer;
  late int zaman = 0;
  final game = Game(durum: 0, kullaniciId: 0, seviyeKilit: 0);
  final log = Log();

  @override
  Widget build(BuildContext context) {
    var f = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    game: game,
                    log: log,
                    user: widget.user,
                  )),
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

  Widget customSizedBox() => SizedBox(
        height: 20,
      );
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

  Widget buildForgetPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Mail Doğrulama Kodu",
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
                      _timer.cancel();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(
                                  log: log, game: game, user: widget.user)));
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
                      initState();
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

  Widget _backButton() {
    return InkWell(
      onTap: () {
        if (GoogleSignInApi != null) {
          GoogleSignInApi.logout();
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      game: game,
                      user: widget.user,
                      log: log,
                    )));
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

  Future<void> _saveUserAndLog() async {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('dd.MM.yyyy HH:mm:ss').format(now);

    int createdUser = await dbhelper.insert(widget.user);
    await dbhelper.insertLog(
      Log(
        girisTarih: "",
        cikisTarih: "",
        kayitTarih: formattedDateTime,
        yapilanIslem: "Kayıt",
        name: widget.user.name ?? "",
        lastname: widget.user.lastname ?? "",
        username: widget.user.username,
        durum: 0,
        kullaniciId: createdUser,
      ),
    );
  }

  Widget _gonderButtton() {
    return TextButton(
      onPressed: _isLoading
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                if (widget.kod == codeController.text) {
                  await _saveUserAndLog();
                  _timer.cancel();
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
                              'Mail doğrulandı',
                              style: GoogleFonts.comicNeue(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              widget.user.username.toString(),
                              style: GoogleFonts.comicNeue(
                                color: Colors.black,
                                //fontSize: 24,
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
                                  onPressed: () async {
                                    _timer.cancel();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage(
                                                  game: game,
                                                  log: log,
                                                  user: widget.user,
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
                } else {
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
                              'Kod yanlış',
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
                                    Navigator.of(context).pop();
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
      ..from = Address(username, 'Mail doğrulama ')
      ..recipients.add(widget.email)
      ..subject = 'Mail doğrulama İsteği'
      ..text =
          'Merhaba , mailinizi doğrulamak için aşağıdaki kodu kullanın: $resetCode'
      ..html =
          "<h1>Merhaba1</h1>\n<p>Mailinizi doğrulamak için aşağıdaki kodu kullanın: <strong>$resetCode</strong></p>";

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
                  'Mail doğrulama bağlantısı gönderildi',
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
                        Navigator.of(context).pop();
                        _startTimer();
                        _secondsRemaining = 120;
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
                  'E-posta gönderilemedi.',
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
                        Navigator.of(context).pop();
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
                  'Beklenmeyen bir hata oluştu.',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      game: game,
                                      user: widget.user,
                                      log: log,
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
}
