class Harfharake {
  int? id;
  String? harfharakename;
  String? harfharakeannotation;
  String? harfharakeimage_path;
  String? harfharakemusic_path;
  bool isMatched = false;
  bool isSelected = false;
  bool temp=false;
  int? harfTur=0;


  Harfharake({this.id, this.harfharakename, this.harfharakeannotation,
  this.harfharakeimage_path , this.harfharakemusic_path,this.harfTur});

  Harfharake copyWith({
    int? id,
    String? harfharakename,
    String? harfharakeannotation,
    String? harfharakeimage_path,
    String? harfharakemusic_path,
    int? harfTur,
  }) {
    return Harfharake(
      id: id ?? this.id,
      harfharakename: harfharakename ?? this.harfharakename,
      harfharakeannotation: harfharakeannotation ?? this.harfharakeannotation,
      harfharakeimage_path: harfharakeimage_path ?? this.harfharakeimage_path,
      harfharakemusic_path: harfharakemusic_path ?? this.harfharakemusic_path,
      harfTur: harfTur ?? this.harfTur,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'harfharakename': harfharakename,
      'harfharakeannotation': harfharakeannotation,
      'harfharakeimage_path': harfharakeimage_path,
      'harfharakemusic_path': harfharakemusic_path,
      'harfTur': harfTur,
    };
  }


  factory Harfharake.fromMap(Map<String, dynamic> map) {
    return Harfharake(
      id: map['id'],
      harfharakename: map['harfharakename'],
      harfharakeannotation: map['harfharakeannotation'],
      harfharakeimage_path: map['harfharakeimage_path'],
      harfharakemusic_path: map['harfharakemusic_path'],
      harfTur: map['harfTur'],
    );
  }

  Harfharake.fromObject(dynamic o) {
    this.id = o["id"] != null ? int.tryParse(o["id"].toString()) : null;
    this.harfharakename = o["harfharakename"];
    this.harfharakeannotation = o["harfharakeannotation"];
    this.harfharakeimage_path = o["harfharakeimage_path"];
    this.harfharakemusic_path = o["harfharakemusic_path"];
    this.harfTur=o["harfTur"];
  }
}
