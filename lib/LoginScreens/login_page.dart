import 'package:elifbauygulamasi/data/dbHelper.dart';
import 'package:elifbauygulamasi/AdminScreens/admin.dart';
import 'package:elifbauygulamasi/LoginScreens/forgetpassword.dart';
import 'package:elifbauygulamasi/KullaniciScreens/home.dart';
import 'package:elifbauygulamasi/LoginScreens/register.dart';
import 'package:elifbauygulamasi/models/letter.dart';
import 'package:elifbauygulamasi/models/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/googlesign.dart';
import '../models/user.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

//0xffa875ea
class _LoginPageState extends State<LoginPage> with ValidationMixin {
  var dbHelper = DbHelper();
  final _formKey = GlobalKey<FormState>();
  late String _password;
  late String _userName;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late String _errorMessage;
  GoogleSignInAccount? user;

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
                Container(
                  height: height * .20,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/topImage.png")),
                  ),
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
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _LoginButton(),
                        _submitButton(),
                        SizedBox(
                          height: 10,
                        ),
                        buildcizgi(),
                        SizedBox(
                          height: 10,
                        ),
                        _googleButton(),
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

  Future<void> girisYap(String x, String y) async {
    var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var result = await dbHelper.checkUser(x, y);
      bool isAdmin = result?.isadmin == 1;
      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    user: result,
                    letter: letter,
                  )),
        );
        if (isAdmin == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminPage(
                      user: result,
                    )),
          );
        }
      } else {
        _showResendDialog();
        print("Hatalı Giriş");
      }
    }
  }

  Future<User> _convertGoogleSignInToUser(GoogleSignInAccount account) async {
    final GoogleSignInAuthentication auth = await account.authentication;
    final String email = account.email;
    final String token = auth.accessToken.toString();
    return User(email, "", "", "", "", "", "", isadmin: 0);
  }

  Future<void> signIn() async {
    var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(
        'Oturum açma başarısız!',
        style: GoogleFonts.comicNeue(),),));
    } else {
      final convertedUser = await _convertGoogleSignInToUser(user);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(
                user: convertedUser,
                letter: letter,
              )));
    }
  }

  void _showResendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
        Text(
          "Kullanıcı Bulunamadı",
          style: GoogleFonts.comicNeue(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,

          ),
        ),
        //Text("Kullanıcı Bulunamadı"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            child:
            Text(
              "Kayıt olmak ister misin?",
              style: GoogleFonts.comicNeue(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            //Text("Kayıt olmak ister misin?"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
              );
            },
            child:
            Text(
              "Şifreni mi unuttun?",
              style: GoogleFonts.comicNeue(
                color: Colors.black,
                fontWeight: FontWeight.w600,

              ),
            ),
            //Text("Şifreni mi unuttun?"),
          ),
        ],
      ),
    );
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
  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_password', _password));
    properties.add(StringProperty('_userName', _userName));
    properties.add(StringProperty('_errorMessage', _errorMessage));
  }
}
