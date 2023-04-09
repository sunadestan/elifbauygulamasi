import 'package:elifbauygulamasi/KullaniciScreens/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

import '../models/letter.dart';
import '../models/user.dart';

class ResimEslestirme extends StatefulWidget {
  ResimEslestirme({Key? key, required this.user, required this.letter})
      : super(key: key);
  User user;
  Letter letter;
  @override
  _ResimEslestirmeState createState() => _ResimEslestirmeState();
}

class _ResimEslestirmeState extends State<ResimEslestirme>
    with TickerProviderStateMixin {
  int seciliIndex = -1;
  bool eslesmeTamamlandi = false;
  int _secondsLeft = 120;
  int _pausedTime = 0;
  bool _isPaused = false;
  late Timer _timer;
  late AnimationController _animationController;
  //var letter = Letter(name: "", annotation: "", imagePath: "", musicPath: "");
  //var user = User("", "", "", "", "", "", "", isadmin: 0);

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

  void liste() {
    setState(() {
      resimler.shuffle(Random());
    });
  }

  void reset() {
    setState(() {
      resimler.shuffle();
      gizliResimler =
          List<String>.filled(gizliResimler.length, 'assets/resim/Elif.png');
      eslesmeTamamlandi = false;
    });
  }

  void togglePause() {
    if (_isPaused) {
      startTimer();
      _animationController.forward();
      setState(() {
        _isPaused = false;
      });
    } else {
      _timer.cancel();
      _animationController.reverse(from: 1);
      setState(() {
        _isPaused = true;
        _pausedTime = _secondsLeft;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    liste();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Oyun Hakkında"),
            content: Text("Bu oyunda..."),
            actions: <Widget>[
              TextButton(
                child: Text("Tamam"),
                onPressed: () {
                  Navigator.of(context).pop();
                  startTimer();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_secondsLeft < 1) {
            timer.cancel();
            _showDialog();
          } else {
            _secondsLeft = _secondsLeft - 1;
          }
        },
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Oyunu yeniden başlatmak ister misiniz?"),
          actions: <Widget>[
            TextButton(
              child: Text("Evet"),
              onPressed: () {
                Navigator.of(context).pop();
                _secondsLeft = 120;
                startTimer();
              },
            ),
            TextButton(
              child: Text("Hayır"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  IconData getIcon() {
    if (_isPaused) {
      return Icons.hourglass_empty;
    } else if (_secondsLeft <= 0) {
      _animationController.forward();
      return Icons.hourglass_empty;
    } else {
      return Icons.alarm;
    }
  }

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
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage(user:widget.user, letter: widget.letter,)));},
        ),
      ),
      body: Column(
        children: [
          customSizedBox(),
          timer(),
          customSizedBox(),
          Expanded(
            child: Center(
              child: GridView.builder(
                itemCount: resimler.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
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
                              if (gizliResimler.every((resim) =>
                                  resim != 'assets/resim/Elif.png')) {
                                eslesmeTamamlandi = true;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Tebrikler!'),
                                      content:
                                          Text('Tüm resimleri eşleştirdiniz!'),
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
                                    gizliResimler[index] =
                                        'assets/resim/Elif.png';
                                    gizliResimler[seciliIndex] =
                                        'assets/resim/Elif.png';
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
                      color: Colors.lightBlueAccent,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Color(0xffbea1ea), width: 2),
                        ),
                        child: Image.asset(
                          gizliResimler[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget timer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            onTap: togglePause,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  color: Colors.lightBlueAccent,
                  progress: _animationController,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                getIcon(),
                color: Colors.lightBlueAccent,
                size: 20,
              ),
              Text(
                _isPaused ? '$_pausedTime' : '$_secondsLeft',
                style: GoogleFonts.comicNeue(
                    color: Colors.lightBlueAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
            ],
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
    properties.add(DiagnosticsProperty<Timer>('_timer', _timer));
  }
}
