class ClientLoginModel {
  ClientLoginModel({
      this.status, 
      this.message, 
      this.userId, 
      this.token, 
      this.user,});

  ClientLoginModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    userId = json['userId'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  num? status;
  String? message;
  num? userId;
  String? token;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['userId'] = userId;
    map['token'] = token;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

class User {
  User({
      this.id, 
      this.name, 
      this.email, 
      this.role,});

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
  }
  num? id;
  String? name;
  String? email;
  String? role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['role'] = role;
    return map;
  }

}