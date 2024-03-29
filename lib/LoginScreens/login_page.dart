import 'package:elifbauygulamasi/data/dbHelper.dart';
import 'package:elifbauygulamasi/AdminScreens/admin.dart';
import 'package:elifbauygulamasi/LoginScreens/forgetpassword.dart';
import 'package:elifbauygulamasi/KullaniciScreens/home.dart';
import 'package:elifbauygulamasi/LoginScreens/register.dart';
import 'package:elifbauygulamasi/models/Log.dart';
import 'package:elifbauygulamasi/models/letter.dart';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/googlesign.dart';
import '../models/game.dart';
import '../models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'googleregister.dart';

class LoginPage extends StatefulWidget {
  LoginPage(
      {Key? key, required this.user, required this.game, required this.log,})
      : super(key: key);
  User user;
  Game game;
  Log log;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

//0xffa875ea
class _LoginPageState extends State<LoginPage> with ValidationMixin {
  var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  var dbHelper = DbHelper();
  final _formKey = GlobalKey<FormState>();
  late String _password;
  late String _userName;
  late String email = "";
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late String _errorMessage;
  GoogleSignInAccount? user;
  int deneme = 1;


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffad80ea),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: height * .20,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/topImage.png"),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 0,
                      child: logo(),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 170,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/resim/Elif-Baa.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        customSizedBox(),
                        buildUserNameField(),
                        buildPasswordField(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgetPasswordPage()),
                                ); // Şifremi unuttum butonuna tıklandığında yapılacak işlemler
                              },
                              child: Text(
                                "Şifremi Unuttum ?",
                                style: GoogleFonts.comicNeue(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _LoginButton(),
                        _submitButton(),
                        buildcizgi(),
                        _googleButton(),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Kullanıcı Adı",
            style: GoogleFonts.comicNeue(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: _usernameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: InputBorder.none, //kenarlıkları yok eder
                  filled: true),
              validator:
                  validateUserName, // form alanına ait formatın uygunluğu mesela isim için 2 karekter lazım gibi
              onSaved: (String? value) {
                _userName = value!;
              }),
        ],
      ),
    );
  }

  Widget buildPasswordField() {
    bool isPassword = true;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Şifre",
            style: GoogleFonts.comicNeue(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
              controller: _passwordController,
              obscureText: isPassword,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: InputBorder.none, //kenarlıkları yok eder
                filled: true,
              ),
              validator:
                  validatePasswordd, // form alanına ait formatın uygunluğu mesela isim için 2 karekter lazım gibi
              onSaved: (String? value) {
                _password = value!;
              }),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 55),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xff9964d5),
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

  Widget _LoginButton() {
    return TextButton(
      onPressed: () async {
        await girisYap(_usernameController.text, _passwordController.text);
        if (girisYap == true) {}
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 55),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xff9964d5),
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
          "Giriş Yap",
          style: GoogleFonts.comicNeue(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _googleButton() {
    return TextButton(
      onPressed: () async {
        signIn();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 55),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xffa06dd7),
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, Colors.white],
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/google.png"),
            fit: BoxFit.contain, // resim boyutunu ayarlamak için fit özelliği
            alignment: Alignment.centerLeft,
          ),
        ),
        child: Center(
          child: Text(
            textAlign: TextAlign.end,
            'Google ile giriş yap ',
            style: GoogleFonts.comicNeue(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Container(
      margin: EdgeInsets.only(
        left: 300,
      ),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Diyanet.png'),
        ),
      ),
    );
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
                "Kullanıcı Bulunamadı",
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 24),
              Divider(
                color: Colors.white,
                thickness: 2,
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                ),
                child: Text(
                  "Kayıt olmak ister misin?",
                  style: GoogleFonts.comicNeue(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgetPasswordPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                ),
                child: Text(
                  "Şifreni mi unuttun?",
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResendDialogg({String message = ""}) {
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
                "Uyarı!",
                style: GoogleFonts.comicNeue(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.lightBlueAccent,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24),
              Divider(
                color: Colors.white,
                thickness: 2,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                ),
                child: Text(
                  "Tamam",
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    final user = await GoogleSignInApi.login();
    email = user!.email ?? "";
    var result = await dbHelper.getUserByEmail(email);
    final surname = user.displayName?.split(" ").last ?? "";
    final name = user.displayName?.split(" ").first ?? "";
    final formattedName = name[0].toUpperCase() + name.substring(1);
    final formattedLastName = surname[0].toUpperCase() + surname.substring(1);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Kullanıcı kayıtlı değil!',
          style: GoogleFonts.comicNeue(fontWeight: FontWeight.w600),
        ),
      ));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Googleregister(
                name: formattedName,
                lastname: formattedLastName,
                email: email,
              )));
      //GoogleSignInApi.logout();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Oturum açma başarısız!',
            style: GoogleFonts.comicNeue(fontWeight: FontWeight.w600),
          ),
        ));
      }
    } else {
      final name = user.displayName?.split(" ").first ?? "";
      final formattedName = name[0].toUpperCase() + name.substring(1);
      final lastname = user.displayName?.split(" ").last ?? "";
      final formattedLastName =
          lastname[0].toUpperCase() + lastname.substring(1);
      User? convertedUser = await dbHelper.getUserByEmail(user.email);

      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
      List<Log> logList = await dbHelper.getLogusername(convertedUser!.username!);
      if (logList.isNotEmpty) {
        Log existingLog = logList.first;
        Log updatedLog = Log(
          id: existingLog.id,
          girisTarih: formattedDateTime,
          cikisTarih: existingLog.cikisTarih,
          kayitTarih: existingLog.kayitTarih,
          yapilanIslem: "Google ile giriş",
          name: existingLog.name,
          lastname: existingLog.lastname,
          username: existingLog.username,
          durum: 1,
          kullaniciId: existingLog.kullaniciId,
        );
        await dbHelper.updateLog(updatedLog);
      }

      result.hesapAcik = 1;
      await dbHelper.updateUserhesap(result);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(
                user: convertedUser,
                letter: letter,
                name: formattedName,
                username: formattedName,
                email: email,
                lastname: formattedLastName,
                game: widget.game,
              )));
    }
  }

  Future<void> girisYap(String x, String y) async {
    String tempname = "";
    String templastname = "";
    String tempusername = "";
    var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var result = await dbHelper.checkUser(x, y);
      bool isAdmin = result?.isadmin == 1;
      bool isVerified = result?.isVerified == 1;

      if (result != null && isAdmin) {
        result.hesapAcik = 1;
        await dbHelper.updateUserhesap(result);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(
              denemeiki: deneme,
              user: result,
              deneme: deneme,
              log: widget.log,
            ),
          ),
        );
      } else if (result != null && isVerified) {
        result.hesapAcik = 1;
        await dbHelper.updateUserhesap(result);

        DateTime now = DateTime.now();
        String formattedDateTime = DateFormat('dd.MM.yyyy HH:mm:ss').format(now);
        List<Log> logList = await dbHelper.getLog();
        if (logList.isNotEmpty) {
          Log existingLog = logList.first;
          Log updatedLog = Log(
            id: existingLog.id,
            girisTarih: formattedDateTime,
            cikisTarih: existingLog.cikisTarih,
            kayitTarih: existingLog.kayitTarih,
            yapilanIslem: "Giriş",
            name: existingLog.name,
            lastname: existingLog.lastname,
            username: existingLog.username,
            durum: 1, // Set the durum field to 1 for login
            kullaniciId: existingLog.kullaniciId,
          );
          await dbHelper.updateLog(updatedLog);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              user: result,
              letter: letter,
              name: tempname,
              username: tempusername,
              email: email,
              lastname: templastname,
              game: widget.game,

            ),
          ),
        );
      } else if (result != null) {
        _showResendDialogg(message: "Hesabınızı doğrulamanız gerekiyor.");
      } else {
        _showResendDialog();
      }
    }
  }

  buildcizgi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 0.5,
            color: Colors.white,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Veya",
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
              child: Divider(
            thickness: 0.5,
            color: Colors.white,
          ))
        ],
      ),
    );
  }

  Widget customSizedBox() => SizedBox(
        height: 20,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_password', _password));
    properties.add(StringProperty('_userName', _userName));
    properties.add(StringProperty('_errorMessage', _errorMessage));
  }

}
