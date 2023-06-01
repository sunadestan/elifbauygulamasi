import 'dart:io';
import 'package:elifbauygulamasi/AdminScreens/admin.dart';
import 'package:elifbauygulamasi/AdminScreens/detay/detay.dart';
import 'package:elifbauygulamasi/AdminScreens/listemen%C3%BC.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../LoginScreens/login_page.dart';
import '../../data/dbHelper.dart';
import '../../models/Log.dart';
import '../../models/game.dart';
import '../../models/letter.dart';
import '../../models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../harfeklememenü.dart';
import '../log.dart';

class ListePage extends StatefulWidget {
  final User user;
  final int deneme;
  final int denemeiki;
  Log log;
  ListePage({Key? key, required this.user,required this.deneme,required this.denemeiki,required this.log}) : super(key: key);
  @override
  State<ListePage> createState() => _ListePage();
}

class _ListePage extends State<ListePage> {
  late Future<List<Letter>> _lettersFuture;
  var dbHelper = DbHelper();
  final _advancedDrawerController = AdvancedDrawerController();
  var letter=Letter(imagePath: "");
  final game = Game(durum: 0, kullaniciId: 0,seviyeKilit: 0);


  @override
  void initState() {
    super.initState();
    _lettersFuture = liste();
  }

  Future<List<Letter>> liste() async {
    final result = await dbHelper.getLetters();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ListeMenu(   log: widget.log,denemeiki: widget.denemeiki,user: widget.user, deneme: widget.deneme,)),
              (route) => false,
        );
        return false; // Geri tuşu işleme alınmadı
      },
      child: AdvancedDrawer(
        backdropColor: Color(0xffad80ea),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 0.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Harfler",
                style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900)),
            backgroundColor: Color(0xFF975FD0),
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context)=> ListeMenu(   log: widget.log,denemeiki: widget.denemeiki,user: widget.user,deneme: widget.deneme,)), (route) => false);
                  },
                  icon: Icon(Icons.exit_to_app)
              )
            ],
          ),
          body: Column(
            children: [
              customSizedBox(),
              _title(),
              Expanded(
                child: FutureBuilder<List<Letter>>(
                  future: _lettersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final letters = snapshot.data;
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: GridView.count(
                          crossAxisCount: 4,
                          childAspectRatio: 0.8,
                          children: List.generate(
                            letters!.length,
                                (index) => kutuu(letters[index]),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Hata: ${snapshot.error}',
                            style: GoogleFonts.comicNeue()),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: Container(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 300.0,
                    height: 200.0,
                    margin: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 64.0,
                      right: 10,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/resim/Elif-Baa.png'),
                        fit: BoxFit.cover,
                      ),
                      //color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                  ),ListTile(
                    onTap: ()  {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>AdminPage(   log: widget.log,denemeiki: widget.denemeiki,user:widget.user,deneme: widget.deneme,)),
                    );},
                    leading: Icon(Icons.home),
                    title: Text(
                      'Ana Sayfa',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: ()  {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListeMenu(   log: widget.log,denemeiki: widget.denemeiki,user:widget.user,deneme: widget.deneme,)),
                      );},
                    leading: Icon(Icons.list),
                    title: Text(
                      'Harfleri Listele',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HarfeklemeMenu(   log: widget.log,denemeiki: widget.denemeiki,user: widget.user,deneme: widget.deneme ,)),
                      );
                    },
                    leading: Icon(Icons.add),
                    title:Text(
                      'Harf Ekle',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LogGiris(
                              user: widget.user,
                              deneme: widget.deneme,
                              denemeiki: widget.denemeiki,
                              log: widget.log,
                            )),
                      );
                    },
                    leading: Icon(Icons.verified_user_outlined),
                    title: Text(
                      'Giriş Bilgileri',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _showResendDialogg(context);
                    },
                    leading: Icon(Icons.power_settings_new),
                    title: Text(
                      'Çıkış Yap',
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Spacer(),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child:Text(
                        'Hizmet Şartları | Gizlilik Politikası',
                        style: GoogleFonts.comicNeue(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
  void _showResendDialogg(context) {
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
                'Güvenli Çıkış Yapın!',
                style: GoogleFonts.comicNeue(
                  color: Colors.lightBlueAccent,
                  fontSize: 24,
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
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'Hayır',
                      style: GoogleFonts.comicNeue(
                        fontWeight: FontWeight.w600,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage(log: widget.log,game: game,user: widget.user,)), (route) => false);

                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Evet',
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
  void _handleMenuButtonPressed() {
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
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

  Widget kutuu(Letter letters) {
    return InkWell(
      onTap: (){Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetayPage(log: widget.log,denemeiki: widget.denemeiki,letter: letters,user: widget.user,deneme: widget.deneme,)),);},
      child: Container(
        alignment: Alignment.center,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Color(0xffbea1ea),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.file(
                    File(letters.imagePath ?? ""),
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

