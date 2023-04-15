import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Soru {
  final String harf;
  final String resim1;
  final String resim2;
  final String resim3;
  final String dogruCevap;

  Soru(this.harf, this.resim1, this.resim2, this.resim3, this.dogruCevap);
}

class SoruSayfasi extends StatefulWidget {
  @override
  _SoruSayfasiState createState() => _SoruSayfasiState();
}

class _SoruSayfasiState extends State<SoruSayfasi> {
  late Soru _resim;
  static List<Soru> _resimler = [
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
    Soru("ze","ustun/ze_üstün.png", "esre/ze_esre.png", "otre/ze_ötre.png","otre"),
    Soru("sin","ustun/sin_üstün.png", "esre/sin_esre.png", "otre/sin_ötre.png","ustun"),
    Soru("şin","ustun/şin_üstün.png", "esre/şin_esre.png", "otre/şin_ötre.png","otre"),
    Soru("sad","ustun/sad_üstün.png", "esre/sad_esre.png", "otre/sad_ötre.png","esre"),
    Soru("dad","ustun/dad_üstün.png", "esre/dad_esre.png", "otre/dad_ötre.png","ustun"),
    Soru("ta","ustun/tı_üstün.png", "esre/tı_esre.png", "otre/tı_ötre.png","esre"),
    Soru("ayın","ustun/ayın_üstün.png", "esre/ayın_esre.png", "otre/ayın_ötre.png","otre"),
    Soru("ğayn","ustun/gayın_üstün.png", "esre/gayın_esre.png", "otre/gayın_ötre.png","ustun"),
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
  void _soruYukle() {
    // Soru listesinden rastgele bir soru seç
    final rastgeleSoru = Random().nextInt(_resimler.length);
    _resim = _resimler[rastgeleSoru];
    _dogruSik = _resim.dogruCevap; // doğru şıkkı takip et
  }

  @override
  void initState() {
    super.initState();
    _resimler;
    _soruYukle();
    _soruYenile();
  }

  Random _random = Random();
  late int _randomIndex;
  List<String> _sorularr = [
    'Harfin üstün hali nedir?',
    'Harfin esre hali nedir?',
    'Harfin ötre hali nedir?'];

  void _soruYenile() {
    setState(() {
      _soruYuklee();
      _secilenSik = null; // seçilen şıkı sıfırla
      _dogruMu = false; // doğru yanıtı sıfırla
    });
  }
  void _soruYuklee() {
    _randomIndex = _random.nextInt(_sorularr.length);
  }

  // Değişkenler
  String? _secilenSik;
  String? _dogruSik;
  bool _dogruMu = false;

  void _cevapKontrol(String cevap) {
    if (cevap == _resim.dogruCevap) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Tebrikler!'),
          content: Text('Cevabınız doğru.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //_soruYenile();
              },
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Üzgünüz!'),
          content: Text('Cevabınız yanlış.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //_soruYenile();
              },
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soru Sayfası'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150.0,
              height: 150.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 64.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage( 'assets/elifba/${_resim.harf}.png',),
                  fit: BoxFit.scaleDown,
                ),
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
            ),
            // Rastgele seçilen harf resmini göster
            Text('${_sorularr[_randomIndex]}'),
            SizedBox(height: 20),
            // Şıkları liste halinde göster
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    _cevapKontrol(_resim.resim1.contains(_resim.dogruCevap) ? 'ustun' : _resim.resim1.contains('esre') ? 'esre' : 'otre');

                  },
                  child: Image.asset(
                    'assets/elifba/${_resim.resim1}',
                    width: 100,
                    height: 100,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _cevapKontrol(_resim.resim2.contains(_resim.dogruCevap) ? 'esre' : _resim.resim2.contains('otre') ? 'otre' : 'ustun');
                  },
                  child: Image.asset(
                    'assets/elifba/${_resim.resim2}',
                    width: 100,
                    height: 100,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _cevapKontrol(_resim.resim3.contains(_resim.dogruCevap) ? 'otre' : _resim.resim3.contains('ustun') ? 'ustun' : 'esre');
                  },
                  child: Image.asset(
                    'assets/elifba/${_resim.resim3}',
                    width: 100,
                    height: 100,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_secilenSik', _secilenSik));
    properties.add(StringProperty('_dogruSik', _dogruSik));
    properties.add(DiagnosticsProperty<bool>('_dogruMu', _dogruMu));
  }
}
