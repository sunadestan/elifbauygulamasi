class Log {
  int? id;
  String? girisTarih;
  String? cikisTarih;
  String? kayitTarih;
  String? yapilanIslem;
  String? name;
  String? lastname;
  String? username;
  bool temp = false;
  int? durum = 0;
  int? kullaniciId;

  Log({
    this.id,
    this.girisTarih,
    this.cikisTarih,
    this.kayitTarih,
    this.yapilanIslem,
    this.name,
    this.lastname,
    this.username,
    this.durum,
    this.kullaniciId,
  });

  Log copyWith({
    int? id,
    String? girisTarih,
    String? cikisTarih,
    String? kayitTarih,
    String? yapilanIslem,
    String? name,
    String? lastname,
    String? username,
    int? durum,
    int? kullaniciId,
  }) {
    return Log(
      id: id ?? this.id,
      girisTarih: girisTarih ?? this.girisTarih,
      cikisTarih: cikisTarih ?? this.cikisTarih,
      kayitTarih: kayitTarih ?? this.kayitTarih,
      yapilanIslem: yapilanIslem ?? this.yapilanIslem,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
      durum: durum ?? this.durum,
      kullaniciId: kullaniciId ?? this.kullaniciId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'girisTarih': girisTarih,
      'cikisTarih': cikisTarih,
      'kayitTarih': kayitTarih,
      'yapilanIslem': yapilanIslem,
      'name': name,
      'lastname': lastname,
      'username': username,
      'durum': durum,
      'kullaniciId': kullaniciId,
    };
  }

  factory Log.fromMap(Map<String, dynamic> map) {
    return Log(
      id: map['id'],
      girisTarih: map['girisTarih'],
      cikisTarih: map['cikisTarih'],
      kayitTarih: map['kayitTarih'],
      yapilanIslem: map['yapilanIslem'],
      name: map['name'],
      lastname: map['lastname'],
      username: map['username'],
      durum: map['durum'],
      kullaniciId: map['kullaniciId'],
    );
  }

  Log.fromObject(dynamic o) {
    this.id = o["id"] != null ? int.tryParse(o["id"].toString()) : null;
    this.girisTarih = o["girisTarih"];
    this.cikisTarih = o["cikisTarih"];
    this.kayitTarih = o["kayitTarih"];
    this.yapilanIslem = o["yapilanIslem"];
    this.name = o["name"];
    this.lastname = o["lastname"];
    this.username = o["username"];
    this.durum = o["durum"];
    this.kullaniciId = o["kullaniciId"];
  }
}
