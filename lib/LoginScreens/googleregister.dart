import 'dart:math';
import 'package:elifbauygulamasi/LoginScreens/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../data/dbHelper.dart';
import '../data/googlesign.dart';
import '../models/Log.dart';
import '../models/game.dart';
import '../models/user.dart';
import '../models/validation.dart';
import 'emaildogrulama.dart';

class Googleregister extends StatefulWidget {
  Googleregister({
    Key? key,
    required this.name,
    required this.lastname,
    required this.email,
    //required this.user
  }) : super(key: key);
  var name;
  var lastname;
  var email;
  //User user;

  @override
  State<Googleregister> createState() => _GoogleregisterState();
}

class _GoogleregisterState extends State<Googleregister> with ValidationMixin {
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
  var txtphone = TextEditingController();
  var txtemail = TextEditingController();
  var txtadres = TextEditingController();
  var txtname = TextEditingController();
  var txtlastname = TextEditingController();
  final user = User(isadmin: 0, isVerified: 0,  hesapAcik: 0);
  final game = Game(durum: 0, kullaniciId: 0, seviyeKilit: 0);
  final log = Log();

  @override
  void initState() {
    txtemail.text = widget.email;
    txtname.text = widget.name;
    txtlastname.text = widget.lastname;
    super.initState();
  }

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
                Text(
                  "Merhaba" +
                      " " +
                      (widget.lastname) +
                      " " +
                      "Google ile kayıt ol.",
                  style: GoogleFonts.comicNeue(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                customSizedBox(),
                customSizedBox(),
                buildUserNameField(),
                buildPhoneField(),
                buildAddressField(),
                buildPasswordField(),
                buildPasswordField2(),
                _submitButton(),
                //_loginAccountLabel(),
              ],
            ),
          ),
        ),
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
              showFlags: true,
            ),
            ignoreBlank: true,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle:
                TextStyle(color: Colors.black, fontFamily: 'Comic Neue'),
            //initialValue: PhoneNumber(isoCode: ''), // başlangıç ülke kodu
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

  Widget _submitButton() {
    return TextButton(
      onPressed: () async {
        print(widget.email);
        if (txtpassword.text == txtpassword2.text) {
          await kayit(
            txtusername.text,
          );
        } else {
          _showResendDialogg();
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

  Future<void> addUser() async {
    int isAdmin = widget.email.endsWith('@elifba.com') ? 1 : 0;
    if (isAdmin == 1) {
      var result = await dbHelper.insert(
        User(
            username: txtusername.text,
            name: txtname.text,
            lastname: txtlastname.text,
            phone: txtphone.text,
            address: txtadres.text,
            password: txtpassword.text,
            email: txtemail.text,
            isadmin: isAdmin,
            isVerified: 1,
            hesapAcik: 0),
      );
      if (result > 0) {
        print("Kullanıcı başarıyla eklendi.");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      log: log,
                      game: game,
                      user: user,
                    )));
      } else {
        print("Kullanıcı eklenirken bir hata oluştu.");
      }
    } else if (isAdmin == 0) {
      await sendEmail(widget.email.toString());
      print(widget.email);
    }
  }

  Future<void> kayit(String kullaniciAdi) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool kullaniciVarMi = await dbHelper.kullaniciAdiKontrolEt(kullaniciAdi);
      if (kullaniciVarMi == false) {
        addUser();
      } else {
        _showResendDialog();
      }
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

  Future<String> sendEmail(
    String recipientEmail,
  ) async {
    String username = 'sunasumeyyedestan@gmail.com'; // gönderen e-posta adresi
    String password = 'ptuetlymfkuqklyu'; // gönderen e-posta adresi şifresi
    final smtpServer = gmail(username, password);
    var deneme = User(
        username: txtusername.text,
        name: txtname.text,
        lastname: txtlastname.text,
        phone: txtphone.text,
        address: txtadres.text,
        password: txtpassword.text,
        email: txtemail.text,
        isadmin: 0,
        isVerified: 0,

        hesapAcik: 0);
    final random = Random();
    final resetCode = random
        .nextInt(1000000)
        .toString()
        .padLeft(6, '0'); // 6 haneli rastgele sayı oluştur
    final message = Message()
      ..from = Address(username, 'Mail doğrulama')
      ..recipients.add(widget.email)
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MailDogrulama(
                                    email: txtemail.text,
                                    kod: resetCode,
                                    user: deneme)));
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
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      log: log,
                                      game: game,
                                      user: user,
                                    )),
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
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      log: log,
                                      game: game,
                                      user: user,
                                    )),
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
    return resetCode;
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
                      log: log,
                      game: game,
                      user: user,
                    )));
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
}
