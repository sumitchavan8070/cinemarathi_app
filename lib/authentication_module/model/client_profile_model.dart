class ClientProfileModel {
  ClientProfileModel({
      this.status, 
      this.message, 
      this.profile, 
      this.classroom,});

  ClientProfileModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    classroom = json['classroom'] != null ? Classroom.fromJson(json['classroom']) : null;
  }
  num? status;
  String? message;
  Profile? profile;
  Classroom? classroom;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (profile != null) {
      map['profile'] = profile?.toJson();
    }
    if (classroom != null) {
      map['classroom'] = classroom?.toJson();
    }
    return map;
  }

}

class Classroom {
  Classroom({
      this.id, 
      this.name, 
      this.schoolId,});

  Classroom.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    schoolId = json['schoolId'];
  }
  num? id;
  String? name;
  num? schoolId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['schoolId'] = schoolId;
    return map;
  }

}

class Profile {
  Profile({
      this.id, 
      this.userId, 
      this.fullName, 
      this.gender, 
      this.dob, 
      this.address, 
      this.phone, 
      this.user,});

  Profile.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    fullName = json['fullName'];
    gender = json['gender'];
    dob = json['dob'];
    address = json['address'];
    phone = json['phone'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  num? id;
  num? userId;
  String? fullName;
  String? gender;
  String? dob;
  String? address;
  String? phone;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['fullName'] = fullName;
    map['gender'] = gender;
    map['dob'] = dob;
    map['address'] = address;
    map['phone'] = phone;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

class User {
  User({
      this.id, 
      this.username, 
      this.email, 
      this.password, 
      this.roleId, 
      this.schoolId, 
      this.fcmToken, 
      this.classes, 
      this.leaves, 
      this.salaries, 
      this.role, 
      this.school,});

  User.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    roleId = json['roleId'];
    schoolId = json['schoolId'];
    fcmToken = json['fcmToken'];
    if (json['classes'] != null) {
      classes = [];
      json['classes'].forEach((v) {
        classes?.add(Classes.fromJson(v));
      });
    }
    if (json['leaves'] != null) {
      leaves = [];
      json['leaves'].forEach((v) {
        leaves?.add(Leaves.fromJson(v));
      });
    }
    if (json['salaries'] != null) {
      salaries = [];
      json['salaries'].forEach((v) {
        salaries?.add(Salaries.fromJson(v));
      });
    }
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    school = json['school'] != null ? School.fromJson(json['school']) : null;
  }
  num? id;
  String? username;
  String? email;
  String? password;
  num? roleId;
  num? schoolId;
  String? fcmToken;
  List<Classes>? classes;
  List<Leaves>? leaves;
  List<Salaries>? salaries;
  Role? role;
  School? school;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['password'] = password;
    map['roleId'] = roleId;
    map['schoolId'] = schoolId;
    map['fcmToken'] = fcmToken;
    if (classes != null) {
      map['classes'] = classes?.map((v) => v.toJson()).toList();
    }
    if (leaves != null) {
      map['leaves'] = leaves?.map((v) => v.toJson()).toList();
    }
    if (salaries != null) {
      map['salaries'] = salaries?.map((v) => v.toJson()).toList();
    }
    if (role != null) {
      map['role'] = role?.toJson();
    }
    if (school != null) {
      map['school'] = school?.toJson();
    }
    return map;
  }

}

class School {
  School({
      this.id, 
      this.name, 
      this.code, 
      this.address, 
      this.phone, 
      this.email, 
      this.principalName, 
      this.establishedYear, 
      this.status, 
      this.createdAt,});

  School.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    principalName = json['principalName'];
    establishedYear = json['establishedYear'];
    status = json['status'];
    createdAt = json['createdAt'];
  }
  num? id;
  String? name;
  String? code;
  String? address;
  String? phone;
  String? email;
  String? principalName;
  num? establishedYear;
  String? status;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['address'] = address;
    map['phone'] = phone;
    map['email'] = email;
    map['principalName'] = principalName;
    map['establishedYear'] = establishedYear;
    map['status'] = status;
    map['createdAt'] = createdAt;
    return map;
  }

}

class Role {
  Role({
      this.id, 
      this.name,});

  Role.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  num? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class Salaries {
  Salaries({
      this.id, 
      this.staffId, 
      this.month, 
      this.year, 
      this.baseSalary, 
      this.bonus, 
      this.deductions, 
      this.totalSalary, 
      this.schoolId, 
      this.staffTableId,});

  Salaries.fromJson(dynamic json) {
    id = json['id'];
    staffId = json['staffId'];
    month = json['month'];
    year = json['year'];
    baseSalary = json['baseSalary'];
    bonus = json['bonus'];
    deductions = json['deductions'];
    totalSalary = json['totalSalary'];
    schoolId = json['schoolId'];
    staffTableId = json['staffTableId'];
  }
  num? id;
  num? staffId;
  String? month;
  num? year;
  num? baseSalary;
  num? bonus;
  num? deductions;
  num? totalSalary;
  num? schoolId;
  num? staffTableId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['staffId'] = staffId;
    map['month'] = month;
    map['year'] = year;
    map['baseSalary'] = baseSalary;
    map['bonus'] = bonus;
    map['deductions'] = deductions;
    map['totalSalary'] = totalSalary;
    map['schoolId'] = schoolId;
    map['staffTableId'] = staffTableId;
    return map;
  }

}

class Leaves {
  Leaves({
      this.id, 
      this.userId, 
      this.startDate, 
      this.endDate, 
      this.reason, 
      this.status, 
      this.type, 
      this.appliedOn, 
      this.schoolId,});

  Leaves.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    reason = json['reason'];
    status = json['status'];
    type = json['type'];
    appliedOn = json['appliedOn'];
    schoolId = json['schoolId'];
  }
  num? id;
  num? userId;
  String? startDate;
  String? endDate;
  String? reason;
  String? status;
  String? type;
  String? appliedOn;
  num? schoolId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['reason'] = reason;
    map['status'] = status;
    map['type'] = type;
    map['appliedOn'] = appliedOn;
    map['schoolId'] = schoolId;
    return map;
  }

}

class Classes {
  Classes({
      this.id, 
      this.name, 
      this.schoolId, 
      this.classTeacherId,});

  Classes.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    schoolId = json['schoolId'];
    classTeacherId = json['classTeacherId'];
  }
  num? id;
  String? name;
  num? schoolId;
  num? classTeacherId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['schoolId'] = schoolId;
    map['classTeacherId'] = classTeacherId;
    return map;
  }

}