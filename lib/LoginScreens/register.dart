import 'package:elifbauygulamasi/models/user.dart';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/dbHelper.dart';
import 'login_page.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';
import 'package:elifbauygulamasi/LoginScreens/emaildogrulama.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    Key? key,
  }) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> with ValidationMixin {
  var dbHelper = DbHelper();
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  late String _userName;
  late String _name;
  late String _lastname;
  late String _phone;
  late String _address;
  var txtusername = TextEditingController();
  var txtpassword = TextEditingController();
  var txtpassword2 = TextEditingController();
  var txtemail = TextEditingController();
  var txtname = TextEditingController();
  var txtlastname = TextEditingController();
  var txtphone = TextEditingController();
  var txtadres = TextEditingController();

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
                buildNameField(),
                buildLastNameField(),
                buildUserNameField(),
                buildPhoneField(),
                buildAddressField(),
                buildMailField(),
                buildPasswordField(),
                buildPasswordField2(),
                _submitButton(),
                _loginAccountLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
                filled: true),
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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
                filled: true),
            validator: validateLastName, //
            onSaved: (String? value) {
              _lastname = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget buildPhoneField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Telefon Numarası",
            style: GoogleFonts.comicNeue(
              color: Color(0xff935ccf),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              // burada numarayı aldığınızda yapılması gereken işlemleri yapabilirsiniz
            },
            onSaved: (PhoneNumber? number) {
              txtphone.text = number?.phoneNumber ?? '';
            },
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.DIALOG,
            ),
            ignoreBlank: true,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle:
                TextStyle(color: Colors.black, fontFamily: 'Comic Neue'),
            initialValue: PhoneNumber(isoCode: 'TR'), // başlangıç ülke kodu
            formatInput: true,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            inputDecoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
            ),
            maxLength: 13,
            validator: validatePhoneNumber,
          ),
        ],
      ),
    );
  }

  Widget buildAddressField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Adres",
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
            controller: txtadres,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator: validateAddress, //
            onSaved: (String? value) {
              _address = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget buildUserNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
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
            controller: txtemail,
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

  Widget buildPasswordField() {
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
            controller: txtpassword,
            obscureText: isPassword,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator:
                validatePassword, // form alanına ait formatın uygunluğu mesela isim için 2 karekter lazım gibi
            onSaved: (String? value) {
              _password = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget buildPasswordField2() {
    bool isPassword = true;
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
            controller: txtpassword2,
            obscureText: isPassword,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true),
            validator:
                validatePassword, // form alanına ait formatın uygunluğu mesela isim için 2 karekter lazım gibi
            onSaved: (String? value) {
              _password = value!;
            },
          ),
        ],
      ),
    );
  }

  Future<void> mailKontrol(String mail) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await dbHelper.makeAdmin();
      print(
          "Tüm @elifba.com domain'ine sahip kullanıcıların isadmin alanı 1 olarak güncellendi.");
    }
  }

  Future<void> kayit(String kullaniciAdi) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool kullaniciVarMi = await dbHelper.kullaniciAdiKontrolEt(kullaniciAdi);
      if (kullaniciVarMi == false) {
        addUser();
        mailKontrol(txtemail.text);
      } else {
        _showResendDialog();
      }
    }
  }

  Future<void> addUser() async {
    int isAdmin = txtemail.text.endsWith('@elifba.com') ? 1 : 0;
    if (isAdmin == 1) {
      var result = await dbHelper.insert(
        User(
          txtusername.text,
          txtpassword.text,
          txtemail.text,
          txtname.text,
          txtadres.text,
          txtlastname.text,
          txtphone.text,
          isadmin: isAdmin,
          isVerified: 1, // yeni kullanıcıların doğrulanmamış olduğunu varsayalım
        ),
      );
      if (result > 0) {
        print("Kullanıcı başarıyla eklendi.");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        print("Kullanıcı eklenirken bir hata oluştu.");
      }
    } else if (isAdmin == 0) {
      await sendEmail(txtemail.text);

    }
  }

  Widget _submitButton() {
    return TextButton(
      onPressed: () async {
        if (txtpassword.text == txtpassword2.text) {
          await kayit(txtusername.text,);}
        else {_showResendDialogg();}
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
          "Kayıt Ol",
          style: GoogleFonts.comicNeue(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Zaten hesabınız var mı ?",
              style: GoogleFonts.comicNeue(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Giriş Yap",
              style: GoogleFonts.comicNeue(
                color: Color(0xff935ccf),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
                'Uyarı!',
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Parolalar eşleşmiyor.',
                style: GoogleFonts.comicNeue(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
  void _showResendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Kullanıcı Adı Alınmıştır",
          style: GoogleFonts.comicNeue(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<String> sendEmail(String recipientEmail,) async {
    String username = 'sunasumeyyedestan@gmail.com'; // gönderen e-posta adresi
    String password = 'ptuetlymfkuqklyu'; // gönderen e-posta adresi şifresi
    final smtpServer = gmail(username, password);
    var deneme = User(txtusername.text, txtpassword.text, txtemail.text,
        txtname.text, txtadres.text, txtlastname.text, txtphone.text,
        isadmin: 0, isVerified: 0);
    final random = Random();
    final resetCode = random
        .nextInt(1000000)
        .toString()
        .padLeft(6, '0'); // 6 haneli rastgele sayı oluştur
    final message = Message()
      ..from = Address(username, 'Mail doğrulama')
      ..recipients.add(txtemail.text)
      ..subject = 'Mail doğrulama İsteği'
      ..text =
          'Merhaba, mailinizi doğrulamak için aşağıdaki kodu kullanın: $resetCode'
      ..html =
          "<h1>Merhaba2</h1>\n<p>Mailinizi doğrulamak için aşağıdaki kodu kullanın: <strong>$resetCode</strong></p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('E-posta gönderildi: ' + sendReport.toString());
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
                  'Başarılı',
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            MailDogrulama(email: txtemail.text, kod: resetCode, user: deneme)));
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
                  'Hata',
                  style: GoogleFonts.comicNeue(
                    color: Colors.lightBlueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,
                  'E-posta gönderilemedi. Daha sonra tekrar deneyin',
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
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
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
                  'Hata',
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
                SizedBox(height: 20),
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
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
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
    return resetCode;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_email', _email));
    properties.add(StringProperty('_password', _password));
    properties.add(StringProperty('_userName', _userName));
    properties.add(StringProperty('_name', _name));
    properties.add(StringProperty('_lastname', _lastname));
    properties.add(StringProperty('_phone', _phone));
    properties.add(StringProperty('_address', _address));
  }
}
