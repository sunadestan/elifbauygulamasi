import 'dart:io';
import 'package:elifbauygulamasi/AdminScreens/admin.dart';
import 'package:elifbauygulamasi/AdminScreens/detay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/dbHelper.dart';
import '../models/letter.dart';
import '../models/user.dart';
import 'package:google_fonts/google_fonts.dart';


class ListePage extends StatefulWidget {
  final User user;
  ListePage({Key? key, required this.user}) : super(key: key);
  @override
  State<ListePage> createState() => _ListePage();
}

class _ListePage extends State<ListePage> {
  late Future<List<Letter>> _lettersFuture;
  var dbHelper = DbHelper();

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Harfler",
            style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900)),
        backgroundColor: Color(0xFF975FD0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () { Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPage(user: widget.user)),);},
        ),
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
    );
  }

  Widget customSizedBox() => SizedBox(
    height: 20,
  );
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Elif',
          style: TextStyle(
              fontFamily: 'OpenSans',
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.grey,
                  offset: Offset(2.0, 2.0),
                ),
              ],
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xff935ccf)
          ),
          children: [
            TextSpan(
              text: '-',
              style: TextStyle(color: Color(0xffad80ea), fontSize: 30),
            ),
            TextSpan(
              text: 'Ba',
              style: TextStyle(color: Color(0xff935ccf), fontSize: 30),
            ),
          ]),
    );
  }
  Widget kutuu(Letter letters) {
    return InkWell(
      onTap: (){Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetayPage(letter: letters,user: widget.user,)),);},
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

