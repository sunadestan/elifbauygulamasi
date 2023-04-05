class User {
  int? id;
  late String username;
  late String name;
  late String lastname;
  late String phone;
  late String address;
  late String password;
  late String email;
  bool temp=false;
  int? isadmin=0;

  User( this.username,this.password,this.email,this.name,this.address,this.lastname,this.phone,{required int isadmin}) {}
  User.withId(this.id,this.username, this.password , this.email,this.name,this.address,this.lastname,this.phone,{required int isadmin}) {}

  Map<String,dynamic> toMap(){
    var map =  Map<String,dynamic>();
    map["username"]=username;
    map["name"]=name;
    map["lastname"]=lastname;
    map["phone"]=phone;
    map["address"]=address;
    map["password"]=password;
    map["email"]=email;
    map["isadmin"]=isadmin;
    if(id!=null){
      map["id"]=id;
    }
    return map;
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
    this.isadmin=o["isadmin"];
  }
}

