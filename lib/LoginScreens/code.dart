import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';

void main() {}

class CodePage extends StatefulWidget {
  const CodePage({Key? key}) : super(key: key);

  @override
  State<CodePage> createState() => _CodeState();
}

class _CodeState extends State<CodePage> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();

  final int _initialSeconds = 10; // başlangıç süresini 2 dakikaya ayarla
  int _secondsRemaining = 10;
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
                _emailPasswordWidget(),
                SizedBox(height: 20),
                Text(
                  "Kalan Saniye: $_secondsRemaining",
                  style: GoogleFonts.comicNeue(
                    color: Color(0xff935ccf),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                _gonderButton(),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginPage()));
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
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
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
        Navigator.pop(context);
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

  Widget _gonderButton() {
    return TextButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 75,),
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
          "Gönder",
          style: GoogleFonts.comicNeue(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
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
