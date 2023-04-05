import 'package:elifbauygulamasi/LoginScreens/login_page.dart';
import 'package:elifbauygulamasi/AdminScreens/harfekle.dart';
import 'package:elifbauygulamasi/AdminScreens/liste.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/dbHelper.dart';
import '../models/user.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  State<AdminPage> createState() => _AdminState();
}

class _AdminState extends State<AdminPage> {
  var dbHelper = DbHelper();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _advancedDrawerController = AdvancedDrawerController();
  User user= User("", "", "", "", "", "", "", isadmin: 0);
  var result;

  /*0xFFA07BC9*/
  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
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
        key: _scaffoldKey,
        appBar: AppBar(
          key: _formKey,
          backgroundColor: Color(0xFF975FD0),
          title:
          Text(
            'Hoş geldin' +
                "  " +
                '${widget.user.name} ${widget.user.lastname}',
            style: GoogleFonts.comicNeue(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
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
        ),
        body: Center(
          child: Column(
            children: [
              customSizedBox(),
              _title(),
            ],
          ),
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
                ),
                ListTile(
                  onTap: ()  {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListePage(user:widget.user)),
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
                      MaterialPageRoute(builder: (context) => HarfEkle(user: widget.user,)),
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
                /*ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text(
                    'Ayarlar',
                    style: GoogleFonts.comicNeue(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),*/
                ListTile(
                  onTap: () {
                    _showResendDialog();
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
    );
  }
  void _showResendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
        Text(
          'Güvenli Çıkış Yapın',
          style: GoogleFonts.comicNeue(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child:  Text(
              'Hayır',
              style: GoogleFonts.comicNeue(

                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              'Evet',
              style: GoogleFonts.comicNeue(
                fontWeight: FontWeight.w600,
              ),
            ),
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
  Widget customSizedBox() => SizedBox(
        height: 20,
      );
  void _handleMenuButtonPressed() {
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
