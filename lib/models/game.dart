class Game {
  int? id;
  String? level;
  bool temp = false;
  int? durum = 0;
  bool temp1 = false;
  int? seviyeKilit = 0;
  int? kullaniciId;

  Game({
    this.id,
    this.level,
    required this.durum,
    required this.seviyeKilit,
    required this.kullaniciId,
  });

  Game copyWith({
    int? id,
    String? level,
    int? durum,
    int? seviyeKilit,
    int? kullaniciId,

  }) {
    return Game(
      id: id ?? this.id,
      level: level ?? this.level,
      durum: durum ?? this.durum,
      seviyeKilit: seviyeKilit ?? this.seviyeKilit,
      kullaniciId: kullaniciId ?? this.kullaniciId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'durum': durum,
      'seviyeKilit': seviyeKilit,
      'kullaniciId': kullaniciId,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      level: map['level'],
      durum: map['durum'],
      seviyeKilit: map['seviyeKilit'],
      kullaniciId: map['kullaniciId'],
    );
  }

  Game.fromObject(dynamic o) {
    this.id = o["id"] != null ? int.tryParse(o["id"].toString()) : null;
    this.level = o["level"];
    this.durum = o["durum"];
    this.seviyeKilit = o["seviyeKilit"];
    this.kullaniciId = o["kullaniciId"];
  }
}
