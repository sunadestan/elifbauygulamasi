import 'package:elifbauygulamasi/KullaniciScreens/home.dart';
import 'package:elifbauygulamasi/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../LoginScreens/login_page.dart';
import '../data/dbHelper.dart';
import '../models/letter.dart';
import '../models/validation.dart';

class AyarlarPage extends StatefulWidget {
  AyarlarPage({Key? key, required this.letter, required this.user})
      : super(key: key);
  final Letter letter;
  final User user;

  @override
  State<AyarlarPage> createState() => _AyarlarPageState(user);
}

enum Options { delete, update }

class _AyarlarPageState extends State<AyarlarPage> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
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

  User user;
  _AyarlarPageState(this.user);
  @override
  void initState() {
    txtname.text = user.name!;
    txtlastname.text = user.lastname!;
    txtemail.text = user.email!;
    txtusername.text = user.username!;
    txtpassword.text = user.password!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Ayarlar",
            style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900)),
        backgroundColor: Color(0xFF975FD0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        letter: widget.letter,
                        user: widget.user,
                      )),
            );
          },
        ),
        actions: <Widget>[
          PopupMenuButton<Options>(
              onSelected: selectProcess,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
                    PopupMenuItem<Options>(
                      value: Options.delete,
                      child: Text("Hesabı sil"),
                    ),
                    PopupMenuItem<Options>(
                      value: Options.update,
                      child: Text("Kaydet"),
                    ),
                  ])
        ],
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
              ],
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
              hintText: '${widget.user.name}',
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
              hintText: '${widget.user.lastname}',
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
              border: InputBorder.none, //kenarlıkları yok eder
              filled: true, hintText: '${widget.user.username}',
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
              filled: true, hintText: '${widget.user.email}',
            ),
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
    String password = widget.user.password; // kullanıcının şifresi
    String hint =
        '*' * password.length; // şifrenin uzunluğu kadar noktalı dize oluştur

    bool isPassword = true;
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
            controller: txtpassword,
            obscureText: isPassword,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none, //kenarlıkları yok eder
              filled: true,
              hintText: hint,
            ),
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

  void selectProcess(Options options) async {
    switch (options) {
      case Options.delete:
        _showResendDialog();
        break;
      case Options.update:
        await dbHelper.update(User.withId(
            user.id,
            txtusername.text,
            txtpassword.text,
            txtemail.text,
            txtname.text,
            "${widget.user.address}",
            txtlastname.text,
            "${widget.user.phone}",
            isadmin: 0));
        Navigator.pop(context, true);
        setState(() {});
        break;
      default:
    }
  }

  void _showResendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hesabı kalıcı olarak silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            child: Text("Hayır"),
          ),
          TextButton(
            onPressed: () {
              dbHelper.delete(user.id!);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              setState(() {});
            },
            child: Text("Evet"),
          ),
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
    properties.add(StringProperty('_email', _email));
    properties.add(StringProperty('_password', _password));
    properties.add(StringProperty('_userName', _userName));
    properties.add(StringProperty('_name', _name));
    properties.add(StringProperty('_lastname', _lastname));
  }
}
