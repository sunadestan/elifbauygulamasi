import 'dart:io';
import 'dart:math';
import 'package:elifbauygulamasi/LoginScreens/login_page.dart';
import 'package:elifbauygulamasi/data/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'deneme2.dart';


class ResetPasswordPageUser extends StatefulWidget {
  @override
  _ResetPasswordPageStateUser createState() => _ResetPasswordPageStateUser();
}

class _ResetPasswordPageStateUser extends State<ResetPasswordPageUser> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xffbf1922),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
          },
        ),
        title: Text('Şifre Sıfırlama'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta Adresi',
                  hintText: 'example@example.com',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'E-posta adresi zorunlu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>( Color(0xffbf1922)),
                ),
                child: Text('Şifre Sıfırlama Bağlantısı Gönder'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                   var temp= await dbHelper.mailkontrolet(emailController.text);
                    if(temp){
                      sendEmail();
                    }else{
                     _showResendDialog();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showResendDialog() {
    AlertDialog alert = AlertDialog(
      title: Text("Uyarı"),
      content: Text("Bu Kullanıcı Kayıtlı Değil"),
      actions: [
        ElevatedButton(
          child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  void sendEmail() async {
    String username = 'sunasumeyyedestan@gmail.com'; // gönderen e-posta adresi
    String password = 'ptuetlymfkuqklyu'; // gönderen e-posta adresi şifresi
    final smtpServer = gmail(username, password);


    final random = Random();
    final resetCode = random.nextInt(1000000).toString().padLeft(6, '0'); // 6 haneli rastgele sayı oluştur

    final message = Message()
      ..from = Address(username, 'Şifre Sıfırlama Uygulaması')
      ..recipients.add(emailController.text)
      ..subject = 'Şifre Sıfırlama İsteği'
      ..text = 'Merhaba, şifrenizi sıfırlamak için aşağıdaki kodu kullanın: $resetCode'
      ..html = "<h1>Merhaba</h1>\n<p>Şifrenizi sıfırlamak için aşağıdaki kodu kullanın: <strong>$resetCode</strong></p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('E-posta gönderildi: ' + sendReport.toString());
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Başarılı'),
              content: Text('Şifre sıfırlama bağlantısı gönderildi'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Tamam'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPasswordVerificationPageUser(email: emailController.text,kod: resetCode,)));
                  },
                ),
              ],
            ),
      );
    } on MailerException catch (e) {
      print('Hata: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
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
        builder: (context) =>
            AlertDialog(
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
  }}