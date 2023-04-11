import 'package:elifbauygulamasi/data/dbHelper.dart';
import 'package:elifbauygulamasi/LoginScreens/code.dart';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {}

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);
  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPasswordPage> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  var dbHelper=DbHelper();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final height = MediaQuery.of(context).size.height;
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
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
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
  Widget _submitButton() {
    return TextButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CodePage()));
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
          'Email Gönder',
          style: GoogleFonts.comicNeue(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> mailGonder(String x) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var result = await dbHelper.checkEmail(x);
      if (result != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CodePage()));
      } else {
        print("Mail Bulunamadı");
      }
    }
  }

  Widget buildForgetPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator: validateForgetPassword, //
            onSaved: (String? value) {
              _email = value!;
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_email', _email));
  }
}
