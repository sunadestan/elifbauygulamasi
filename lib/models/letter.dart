class Letter {
  int? id;
  String? name;
  String? annotation;
  String? imagePath;
  String? musicPath;
  bool isMatched = false;
  bool isSelected = false;

  Letter({this.id, this.name, this.annotation, required this.imagePath , this.musicPath});
  Letter copyWith({
    int? id,
    String? name,
    String? annotation,
    String? imagePath,
    String? musicPath,
  }) {
    return Letter(
      id: id ?? this.id,
      name: name ?? this.name,
      annotation: annotation ?? this.annotation,
      imagePath: imagePath ?? this.imagePath,
      musicPath: musicPath ?? this.musicPath,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'annotation': annotation,
      'image_path': imagePath,
      'music_path': musicPath,
    };
  }


  factory Letter.fromMap(Map<String, dynamic> map) {
    return Letter(
      id: map['id'],
      name: map['name'],
      annotation: map['annotation'],
      imagePath: map['image_path'],
      musicPath: map['music_path'],
    );
  }

  Letter.fromObject(dynamic o) {
    this.id = o["id"] != null ? int.tryParse(o["id"].toString()) : null;
    this.name = o["name"];
    this.annotation = o["annotation"];
    this.imagePath = o["image_path"];
    this.musicPath = o["music_path"];
  }
}
