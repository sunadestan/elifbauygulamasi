class User {
  int? id;
   String? username;
   String? name;
   String? lastname;
   String? phone;
   String? address;
   String? password;
   String? email;
  bool temp=false;
  int? isadmin=0;
  bool tempp=false;
  int? isVerified=0;
  bool temp1=false;
  int? hesapAcik = 0;

  User( {this.id,this.username,this.password,this.email,this.name,this.address,this.lastname,this.phone,
        isadmin,   isVerified,   hesapAcik }) ;

  User.withId(this.id,this.username, this.password , this.email,this.name,this.address,this.lastname,this.phone,{required int isadmin,
    required int isVerified, required int hesapAcik}) {}

  User copyWith({
    int? id,
    String? username,
    String? name,
    String? lastname,
    String? phone,
    String? address,
    String? password,
    String? email,
    int? isadmin,
    int? isVerified,
    int? hesapAcik,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      password: password ?? this.password,
      email: email ?? this.email,
      isadmin: isadmin ?? this.isadmin,
      isVerified: isVerified ?? this.isVerified,
      hesapAcik: hesapAcik ?? this.hesapAcik,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'lastname': lastname,
      'phone': phone,
      'address': address,
      'password': password,
      'email': email,
      'isadmin': isadmin,
      'isVerified': isVerified,
      'hesapAcik': hesapAcik,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      name: map['name'],
      lastname: map['lastname'],
      phone: map['phone'],
      address: map['address'],
      password: map['password'],
      email: map['email'],
      isadmin: map['isadmin'],
      isVerified: map['isVerified'],
      hesapAcik: map['hesapAcik'],
    );
  }

  User.fromObject(dynamic o) {
    this.id = o["id"] != null ? int.tryParse(o["id"].toString()) : null;
    this.username = o["username"];
    this.name = o["name"];
    this.lastname = o["lastname"];
    this.phone = o["phone"];
    this.address = o["address"];
    this.password = o["password"];
    this.email = o["email"];
    this.isadmin = o["isadmin"];
    this.isVerified = o["isVerified"];
    this.hesapAcik = o["hesapAcik"];
  }


}

