class Dangki {
  int user_id;
  String user_name;
  String user_email;
  String user_password;

  Dangki(this.user_id, this.user_name, this.user_email, this.user_password);

  factory Dangki.fromJson(Map<String, dynamic> json){
    return Dangki(
      int.parse(json['user_id']), 
      json['user_name'],
      json['user_email'],
      json['user_password'],
    );
  }

  Map<String, dynamic> toJson() =>{
    'user_id': user_id.toString(),
    'user_name': user_name,
    'user_email': user_email,
    'user_password': user_password,
  };
}