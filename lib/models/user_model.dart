class UserModel {
  String name;
  String email;
  String phone;
  String password;
  DateTime birthDate;
  String gender;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.birthDate,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      birthDate: DateTime.parse(map['birthDate']),
      gender: map['gender'],
    );
  }
}

class UserSession {
  static UserModel? currentUser;
}
