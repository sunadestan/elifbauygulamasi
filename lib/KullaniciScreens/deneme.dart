import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../data/dbHelper.dart';
import '../models/letter.dart';

class MyGamePage extends StatefulWidget {
  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  List<Letter> _letters = [];
  int? _selectedLetterIndex;
  List<Letter> _selectedLetters = [];
  List<Letter> harfler = [];
  var dbHelper = DbHelper();
  List<Letter> _matchedLetters=[];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await _init();
  }

  Future<void> _init() async {
    _letters = await dbHelper.getLetters();
    _selectedLetters = _letters.sublist(0, 10)..addAll(_letters.sublist(0, 10));
    _selectedLetters.shuffle();
    _selectedLetters = _selectedLetters.sublist(0, 20);

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eşleştirme Oyunu'),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: List.generate(_selectedLetters.length, (index) {
          return InkWell(
            onTap: () {
              if (_selectedLetterIndex == null) { // hiçbir kutu seçili değil
                setState(() {
                  _selectedLetterIndex = index;
                  _selectedLetters[index].isSelected = true;
                });
              } else { // bir kutu seçili
                if (_selectedLetters[_selectedLetterIndex!].imagePath == _selectedLetters[index].imagePath &&
                    _selectedLetterIndex != index) {
                  // eşleşti
                  _selectedLetters[_selectedLetterIndex!].isMatched = true;
                  _selectedLetters[index].isMatched = true;
                  setState(() {
                    _selectedLetterIndex = null;
                  });
                } else {
                  // eşleşmedi
                  _selectedLetters[_selectedLetterIndex!].isSelected = false;
                  _selectedLetters[index].isSelected = true;
                  setState(() {
                    _selectedLetterIndex = index;
                  });
                }
              }

            },
            child: Card(
              elevation: 4.0,
              // set id value for card
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Stack(
                children: [
                  // add the image widget to the stack
                  if (_selectedLetters[index].isSelected)
                    Image.file(
                      File(_selectedLetters[index].imagePath!),
                      fit: BoxFit.cover,
                    ),

                  if (_selectedLetters[index].isMatched)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
