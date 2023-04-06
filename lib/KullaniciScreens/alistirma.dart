import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../data/dbHelper.dart';
import '../models/letter.dart';

class MatchingGame extends StatefulWidget {
  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  List<String> matchedLetters = [];

  String? firstLetter;
  String? secondLetter;
  var dbHelper = DbHelper();
  late Future<List<Letter>> _lettersFuture;
  late Future<List<Letter>> _lettersFuture2;
  int? selectedLetterIndex;
  int? previousSelectedLetterIndex;
  bool canTap = true;

  @override
  void initState() {
    super.initState();
    _lettersFuture = liste();
    _lettersFuture2 = liste();
  }

  Future<List<Letter>> liste() async {
    final result = await dbHelper.getLetters();
    final list = (result)..shuffle();
    final duplicateList = List<Letter>.from(list)..addAll(list); // duplicate the list
    return duplicateList;
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
          onPressed: () {},
        ),
      ),
      body: Container(
        child: Column(
          children: [
            customSizedBox(),
            _title(),
            customSizedBox(),
            Expanded(
              child: FutureBuilder<List<Letter>>(
                future: _lettersFuture,
                builder: (context, snapshot1) {
                  if (snapshot1.hasData) {
                    return FutureBuilder<List<Letter>>(
                      future: _lettersFuture2,
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: 29,
                            itemBuilder: (context, index) {
                              final letter = snapshot1.data![index];
                              bool isSelected = false;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSelected = !isSelected;
                                  });
                                },
                                child: kutuu(letter),
                              );
                            },
                          );

                        } else if (snapshot2.hasError) {
                          return Text('${snapshot2.error}');
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  } else if (snapshot1.hasError) {
                    return Text('${snapshot1.error}');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
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

  Widget kutuu(Letter letter) {
    bool isMatched = matchedLetters.contains(letter.imagePath);
    bool isSelected = firstLetter == letter.imagePath || secondLetter == letter.imagePath;

    return InkWell(
      onTap: canTap ? () {
        setState(() {
          if (isSelected) {
            // if the letter is already selected, unselect it
            if (firstLetter == letter.imagePath) {
              firstLetter = null;
            } else if (secondLetter == letter.imagePath) {
              secondLetter = null;
            }
          } else {
            // if the letter is not selected, select it
            if (firstLetter == null) {
              firstLetter = letter.imagePath;
            } else {
              secondLetter = letter.imagePath;
              canTap = false; // disable tapping while checking for matches
              if (firstLetter == secondLetter) {
                // if the letters match, add them to the matched letters list
                matchedLetters.add(firstLetter!);
                firstLetter = null;
                secondLetter = null;
              } else {
                // if the letters do not match, reset the selection after a delay
                Future.delayed(Duration(milliseconds: 500), () {
                  setState(() {
                    firstLetter = null;
                    secondLetter = null;
                    canTap = true; // enable tapping again
                  });
                });
              }
            }
          }
        });
      } : null,
      child: Container(
        decoration: BoxDecoration(
          color: isMatched ? Colors.grey : Color(0xffbea1ea),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: isSelected || isMatched
              ? Image.file(File(letter.imagePath ?? ""))
              : Text('?', style: TextStyle(fontSize: 24.0)),
        ),
      ),
    );
  }

}
