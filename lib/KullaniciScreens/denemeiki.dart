import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';


class ResimEslestirme extends StatefulWidget {
  @override
  _ResimEslestirmeState createState() => _ResimEslestirmeState();
}

class _ResimEslestirmeState extends State<ResimEslestirme> {

  @override
  void initState() {
    super.initState();

    liste();
  }

  List<String> resimler = [
    'assets/elifba/ayın.png',
    'assets/elifba/ayın.png',
    'assets/elifba/be.png',
    'assets/elifba/be.png',
    'assets/elifba/cim.png',
    'assets/elifba/cim.png',
    'assets/elifba/dad.png',
    'assets/elifba/dad.png',
    'assets/elifba/dal.png',
    'assets/elifba/dal.png',
    'assets/elifba/elif.png',
    'assets/elifba/elif.png',
    'assets/elifba/fe.png',
    'assets/elifba/fe.png',
    'assets/elifba/gaf.png',
    'assets/elifba/gaf.png',
    'assets/elifba/ha.png',
    'assets/elifba/ha.png',
    'assets/elifba/he.png',
    'assets/elifba/he.png',
    'assets/elifba/kef.png',
    'assets/elifba/kef.png',
    'assets/elifba/lam.png',
    'assets/elifba/lam.png',
    'assets/elifba/lamelif.jpg',
    'assets/elifba/lamelif.jpg',
    'assets/elifba/mim.png',
    'assets/elifba/mim.png',
    'assets/elifba/nun.png',
    'assets/elifba/nun.png',
    'assets/elifba/peltekSe.png',
    'assets/elifba/peltekSe.png',
    'assets/elifba/ra.png',
    'assets/elifba/ra.png',
    'assets/elifba/sad.png',
    'assets/elifba/sad.png',
    'assets/elifba/sin.png',
    'assets/elifba/sin.png',
    'assets/elifba/ta.png',
    'assets/elifba/ta.png',
    'assets/elifba/te.png',
    'assets/elifba/te.png',
    'assets/elifba/vav.png',
    'assets/elifba/vav.png',
    'assets/elifba/ye.png',
    'assets/elifba/ye.png',
    'assets/elifba/za.png',
    'assets/elifba/za.png',
    'assets/elifba/ze.png',
    'assets/elifba/ze.png',
    'assets/elifba/zel.png',
    'assets/elifba/zel.png',
    'assets/elifba/ğayn.png',
    'assets/elifba/ğayn.png',
    'assets/elifba/ğhı.png',
    'assets/elifba/ğhı.png',
    'assets/elifba/şin.png',
    'assets/elifba/şin.png',
  ];

  void liste(){
    setState(() {
      resimler.shuffle(Random());
    });
  }

  List<String> gizliResimler = [
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
    'assets/resim/Elif.png',
  ];

  int seciliIndex = -1;
  bool eslesmeTamamlandi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Hadi Oyun Oynayalım",
              style: GoogleFonts.comicNeue(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900)),
        backgroundColor: Color(0xFF975FD0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          customSizedBox(),
          _title(),
          customSizedBox(),
          Expanded(
            child: Center(
              child: GridView.builder(
                itemCount: resimler.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (BuildContext context, int index) {return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!eslesmeTamamlandi) {
                        if (seciliIndex == -1) {
                          seciliIndex = index;
                          gizliResimler[index] = resimler[index];
                        } else if (seciliIndex != index) {
                          if (resimler[index] == resimler[seciliIndex]) {
                            gizliResimler[index] = resimler[index];
                            seciliIndex = -1;
                            if (gizliResimler.every(
                                    (resim) => resim != 'assets/resim/Elif.png')) {
                              eslesmeTamamlandi = true;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Tebrikler!'),
                                    content: Text('Tüm resimleri eşleştirdiniz!'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text('Tekrar Oyna'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          reset();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            gizliResimler[index] = resimler[index];
                            Timer(Duration(milliseconds: 500), () {
                              if (seciliIndex != -1) {
                                if (index != seciliIndex) {
                                  gizliResimler[index] = 'assets/resim/Elif.png';
                                  gizliResimler[seciliIndex] = 'assets/resim/Elif.png';
                                  seciliIndex = -1;
                                  setState(() {});
                                }
                              }
                            });
                          }
                        }
                      }
                    });
                  },
                  child: Card(
                    color: Color(0xffbea1ea),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xffbea1ea),width: 2),
                      ),
                    child: Image.asset(
                      gizliResimler[index],
                      fit: BoxFit.cover,
                    ),
                    ),
                  ),);

                },
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

  void reset() {
    setState(() {
      resimler.shuffle();
      gizliResimler =
          List<String>.filled(gizliResimler.length, 'assets/resim/Elif.png');
      eslesmeTamamlandi = false;
    });
  }
}
