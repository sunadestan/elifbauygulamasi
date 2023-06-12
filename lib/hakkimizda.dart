import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Hakkimizda extends StatefulWidget {
  const Hakkimizda({Key? key}) : super(key: key);

  @override
  State<Hakkimizda> createState() => _HakkimizdaState();
}

class _HakkimizdaState extends State<Hakkimizda> {
  final _formKey = GlobalKey<FormState>();

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

                  ],
                ),
                _title(),
                SizedBox(height: 16),
                _aboutText(),
                SizedBox(height: 16),
                _privacyPolicyText(),
                SizedBox(height: 16),
                _termsOfServiceText(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _privacyPolicyText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [Color(0xffbea1ea), Color(0xffad80ea)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Column(
        children: [
          Text(
            "Gizlilik Politikası",
            style: GoogleFonts.comicNeue(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Kullanıcı verileri kesinlikle gizli tutulur ve üçüncü şahıslarla paylaşılmaz.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Kullanıcı verileri yalnızca uygulamanın işlevselliğini sağlamak için kullanılır.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Kullanıcı verilerinin güvenliği için uygun önlemler alınır.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Kullanıcı verileri kullanıcının izni olmadan reklam veya pazarlama amaçlarıyla kullanılmaz.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _termsOfServiceText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [Color(0xffbea1ea), Color(0xffad80ea)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Column(
        children: [
          Text(
            "Hizmet Şartları",
            style: GoogleFonts.comicNeue(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Uygulamamızdaki içeriği yalnızca kişisel kullanımınız için kullanabilirsiniz.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Uygulamamızın herhangi bir kısmını veya içeriğini kopyalayamaz, değiştiremez veya dağıtamazsınız.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Uygulamamızı yasadışı amaçlarla kullanamazsınız veya başkalarının kullanımını engelleyemezsiniz.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Uygulamamızın sağladığı hizmetlerden kaynaklanan sorumluluk size aittir.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _aboutText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [Color(0xffbea1ea), Color(0xffad80ea)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Column(
        children: [
          Text(
            "Uygulamamız X şirketi tarafından geliştirilmiş bir uygulamadır. "
                "Amacımız kullanıcılara X hizmetini sağlamak ve kullanıcı deneyimini geliştirmektir.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Uygulamamız size şunları sunar:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Kur'an-ı Kerim harflerini eğlenerek öğrenebilirsiniz.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Oyunlar oynayarak seviyenizi ölçebilir ve eğlenceli vakit geçirebilirsiniz.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.fiber_manual_record, color: Colors.black, size: 10),
            title: Text(
              "Özelleştirilebilir kullanıcı profilinizle kendinizi ifade edebilirsiniz.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          // Add more bullet points here if desired
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'HAKKIMIZDA',
          style: GoogleFonts.comicNeue(
            fontSize: 35,
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
}
