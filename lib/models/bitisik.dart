class BitisikHarfler {
  int? id;
  String? harfinadi;
  String? harfinaciklamasi;
  String? ses_path;
  String? image_path;



  BitisikHarfler({this.id, this.harfinadi, this.harfinaciklamasi,
    this.ses_path , this.image_path});

  BitisikHarfler copyWith({
    int? id,
    String? harfadi,
    String? harfaciklamasi,
    String? music_path,
    String? image_path,
    int? harfTur,
  }) {
    return BitisikHarfler(
      id: id ?? this.id,
      harfinadi: harfadi ?? this.harfinadi,
      harfinaciklamasi: harfaciklamasi ?? this.harfinaciklamasi,
      ses_path: music_path ?? this.ses_path,
      image_path: image_path ?? this.image_path,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'harfinadi': harfinadi,
      'harfinaciklamasi': harfinaciklamasi,
      'ses_path': ses_path,
      'image_path': image_path,
    };
  }


  factory BitisikHarfler.fromMap(Map<String, dynamic> map) {
    return BitisikHarfler(
      id: map['id'],
      harfinadi: map['harfinadi'],
      harfinaciklamasi: map['harfinaciklamasi'],
      ses_path: map['ses_path'],
      image_path: map['image_path'],
    );
  }

  BitisikHarfler.fromObject(dynamic o) {
    this.id = o["id"] != null ? int.tryParse(o["id"].toString()) : null;
    this.harfinadi = o["harfinadi"];
    this.harfinaciklamasi = o["harfinaciklamasi"];
    this.ses_path = o["ses_path"];
    this.image_path = o["image_path"];
  }
}
