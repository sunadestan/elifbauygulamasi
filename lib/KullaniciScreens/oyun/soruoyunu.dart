import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/letter.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class SoruOyunu extends StatefulWidget {
  SoruOyunu({
    Key? key,
    required this.letter,
  }) : super(key: key);
  final Letter letter;
  @override
  State<SoruOyunu> createState() => _SoruOyunuState();
}

class _SoruOyunuState extends State<SoruOyunu> {

  List<String> _images = [
    'assets/elifba/elif.png',
    'assets/elifba/be.png',
    'assets/elifba/te.png',
    'assets/elifba/peltekSe.png',
    'assets/elifba/cim.png',
    'assets/elifba/ha.png',
    'assets/elifba/ğhı.png',
    'assets/elifba/dal.png',
    'assets/elifba/zel.png',
    'assets/elifba/ra.png',
    'assets/elifba/ze.png',
    'assets/elifba/sin.png',
    'assets/elifba/şin.png',
    'assets/elifba/sad.png',
    'assets/elifba/dad.png',

    'assets/elifba/ta.png',
    'assets/elifba/za.png',
    'assets/elifba/ayın.png',
    'assets/elifba/ğayn.png',
    'assets/elifba/fe.png',
    'assets/elifba/gaf.png',
    'assets/elifba/kef.png',
    'assets/elifba/lam.png',
    'assets/elifba/mim.png',
    'assets/elifba/nun.png',
    'assets/elifba/vav.png',
    'assets/elifba/he.png',
    'assets/elifba/lamelif.jpg',
    'assets/elifba/ye.png',
  ];
  Map<String, List<String>> harfResimleri = {
    "elif": ["elif_üstün.png", "elif_esre.png", "elif_ötre.png"],
    "be": ["be_üstün.png", "be_esre.png", "be_ötre.png"],
    "te": ["te_üstün.png", "te_esre.png", "te_ötre.png"],
    "peltekSe": ["se_üstün.png", "se_esre.png", "se_ötre.png"],
    "cim": ["cim_üstün.png", "cim_esre.png", "cim_ötre.png"],
    "ha": ["ha_üstün.png", "ha_esre.png", "ha_ötre.png"],
    "ğhı": ["hı_üstün.png", "hı_esre.png", "hı_ötre.png"],
    "dal": ["dal_üstün.png", "dal_esre.png", "dal_ötre.png"],
    "zel": ["zel_üstün.png", "zel_esre.png", "zel_ötre.png"],
    "ra": ["ra_üstün.png", "ra_esre.png", "ra_ötre.png"],
    "ze": ["ze_üstün.png", "ze_esre.png", "ze_ötre.png"],
    "sin": ["sin_üstün.png", "sin_esre.png", "sin_ötre.png"],
    "şin": ["şin_üstün.png", "şin_esre.png", "şin_ötre.png"],
    "sad": ["sad_üstün.png", "sad_esre.png", "sad_ötre.png"],
    "dad": ["dad_üstün.png", "dad_esre.png", "dad_ötre.png"],
    "ta": ["tı_üstün.png", "tı_esre.png", "tı_ötre.png"],
    "ayın": ["ayın_üstün.png", "ayın_esre.png", "ayın_ötre.png"],
    "ğayn": ["gayın_üstün.png", "gayın_esre.png", "gayın_ötre.png"],
    "fe": ["fe_üstün.png", "fe_esre.png", "fe_ötre.png"],
    "gaf": ["gaf_üstün.png", "gaf_esre.png", "gaf_ötre.png"],
    "kef": ["kef_üstün.png", "kef_esre.png", "kef_ötre.png"],
    "lam": ["lam_üstün.png", "lam_esre.png", "lam_ötre.png"],
    "mim": ["mim_üstün.png", "mim_esre.png", "mim_ötre.png"],
    "nun": ["nun_üstün.png", "nun_esre.png", "nun_ötre.png"],
    "vav": ["vav_üstün.png", "vav_esre.png", "vav_ötre.png"],
    "he": ["he_üstün.png", "he_esre.png", "he_ötre.png"],
    "ye": ["ye_üstün.png", "ye_esre.png", "ye_ötre.png"],
  };

  late Future<String> _randomImage;


  @override
  void initState() {
    super.initState();
    _getAssetImages();
  }

  Future<void> _getAssetImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final assetNames = manifestMap.keys
        .where((String key) => key.contains('assets/elifba/'))
        .toList();
    setState(() {
      _images = assetNames;
    });
    _randomImage = _getRandomImage();
  }

  Future<String> _getRandomImage() async {
    if (_images.isEmpty) {
      return '';
    }
    Random random = new Random();
    int index = random.nextInt(_images.length);
    final randomImage = _images[index];
    setState(() {
      _images.remove(randomImage);
    });
    return randomImage;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _randomImage,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: 1, // örnek olarak 2 resim gösteriyoruz
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        margin: const EdgeInsets.only(
                          top: 24.0,
                          bottom: 64.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(snapshot.data!),
                            fit: BoxFit.scaleDown,
                          ),
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    soru(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }


  Widget soru() {
    Random random = new Random();
    String randomHarf = harfResimleri.keys.toList()[random.nextInt(harfResimleri.length)];
    List<String> resimler = harfResimleri[randomHarf]!;
    String randomResim = resimler[random.nextInt(resimler.length)];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "1. Soru",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "Harfin esre hali aşağıdakilerden hangisidir?",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Container(
            width: 150.0,
            height: 150.0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(randomResim),
                fit: BoxFit.scaleDown,
              ),
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 20),
          // buraya cevap seçeneklerini ekleyebilirsin
        ],
      ),
    );
  }
}

class Soru {
  String harf;
  String ustunResim;
  String esreResim;
  String otreResim;
  String dogruCevap;

  Soru(this.harf, this.ustunResim, this.esreResim, this.otreResim, this.dogruCevap);
}

class SoruBankasi {
  static List<Soru> _sorular = [
    Soru("a", "ustun/a_ustun.png", "esre/a_esre.png", "otre/a_otre.png", "ustun"),
    Soru("b", "ustun/b_ustun.png", "esre/b_esre.png", "otre/b_otre.png", "esre"),
    Soru("c", "ustun/c_ustun.png", "esre/c_esre.png", "otre/c_otre.png", "otre"),
    Soru("elif","ustun/elif_üstün.png", "esre/elif_esre.png", "otre/elif_ötre.png","ustun"),
    Soru("be","ustun/be_üstün.png", "esre/be_esre.png", "otre/be_ötre.png","esre"),
    Soru("te","ustun/te_üstün.png", "esre/te_esre.png", "otre/te_ötre.png","otre"),
    Soru("peltekSe","ustun/se_üstün.png", "esre/se_esre.png", "otre/se_ötre.png","ustun"),
    Soru("cim","ustun/cim_üstün.png", "esre/cim_esre.png", "otre/cim_ötre.png","esre"),
    Soru("ha","ustun/ha_üstün.png", "esre/ha_esre.png", "otre/ha_ötre.png","otre"),
    Soru("ğhı","ustun/hı_üstün.png", "esre/hı_esre.png", "otre/hı_ötre.png","ustun"),
    Soru("dal","ustun/dal_üstün.png", "esre/dal_esre.png", "otre/dal_ötre.png","esre"),
    Soru("zel","ustun/zel_üstün.png", "esre/zel_esre.png", "otre/zel_ötre.png","otre"),
    Soru("ra","ustun/ra_üstün.png", "esre/ra_esre.png", "otre/ra_ötre.png","ustun"),
    Soru("ze","ustun/ze_üstün.png", "esre/ze_esre.png", "otreze_ötre.png","otre"),
    Soru("sin","ustun/sin_üstün.png", "esre/sin_esre.png", "otre/sin_ötre.png","ustun"),
    Soru("şin","ustun/şin_üstün.png", "esre/şin_esre.png", "otre/şin_ötre.png","otre"),
    Soru("sad","ustun/sad_üstün.png", "esre/sad_esre.png", "otre/sad_ötre.png","esre"),
    Soru("dad","ustun/dad_üstün.png", "esre/dad_esre.png", "otre/dad_ötre.png","ustun"),
    Soru("ta","ustun/tı_üstün.png", "esre/tı_esre.png", "otre/tı_ötre.png","esre"),
    Soru("ayın","ustun/ayın_üstün.png", "esre/ayın_esre.png", "otre/ayın_ötre.png","otre"),
    Soru("ğayn","gayın_üstün.png", "gayın_esre.png", "gayın_ötre.png","ustun"),
    Soru("fe","ustun/fe_üstün.png", "esre/fe_esre.png", "otre/fe_ötre.png","esre"),
    Soru("gaf","ustun/gaf_üstün.png", "esre/gaf_esre.png", "otre/gaf_ötre.png","otre"),
    Soru("kef","ustun/kef_üstün.png", "esre/kef_esre.png", "otre/kef_ötre.png","ustun"),
    Soru("lam","ustun/lam_üstün.png", "esre/lam_esre.png", "otre/lam_ötre.png","esre"),
    Soru("mim","ustun/mim_üstün.png", "esre/mim_esre.png", "otre/mim_ötre.png","ustun"),
    Soru("nun","ustun/nun_üstün.png", "esre/nun_esre.png", "otre/nun_ötre.png","esre"),
    Soru("vav","ustun/vav_üstün.png", "esre/vav_esre.png", "otre/vav_ötre.png","otre"),
    Soru("he","ustun/he_üstün.png", "esre/he_esre.png", "otre/he_ötre.png","ustun"),
    Soru("ye","ustun/ye_üstün.png", "esre/ye_esre.png", "otre/ye_ötre.png","esre"),
  ];

  static Soru rastgeleSoru() {
    Random random = new Random();
    int rastgeleIndis = random.nextInt(_sorular.length);
    return _sorular[rastgeleIndis];
  }
}

