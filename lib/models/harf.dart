class Harf {
  int? id;
  String? harfname;
  String? harfannotation;
  String? harfimagePath;
  String? harfmusicPath;
  bool isMatched = false;
  bool isSelected = false;

  Harf({this.id, this.harfname, this.harfannotation, required this.harfimagePath , this.harfmusicPath});
  Harf copyWith({
    int? id,
    String? harfname,
    String? harfannotation,
    String? harfimagePath,
    String? harfmusicPath,
  }) {
    return Harf(
      id: id ?? this.id,
      harfname: harfname ?? this.harfname,
      harfannotation: harfannotation ?? this.harfannotation,
      harfimagePath: harfimagePath ?? this.harfimagePath,
      harfmusicPath: harfmusicPath ?? this.harfmusicPath,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'harfname': harfname,
      'harfannotation': harfannotation,
      'harfimage_path': harfimagePath,
      'harfmusic_path': harfmusicPath,
    };
  }


  factory Harf.fromMap(Map<String, dynamic> map) {
    return Harf(
      id: map['id'],
      harfname: map['harfname'],
      harfannotation: map['harfannotation'],
      harfimagePath: map['harfimage_path'],
      harfmusicPath: map['harfmusic_path'],
    );
  }

  Harf.fromObject(dynamic o) {
    this.id = o["id"] != null ? int.tryParse(o["id"].toString()) : null;
    this.harfname = o["harfname"];
    this.harfannotation = o["harfannotation"];
    this.harfimagePath = o["harfimage_path"];
    this.harfmusicPath = o["harfmusic_path"];
  }
}
