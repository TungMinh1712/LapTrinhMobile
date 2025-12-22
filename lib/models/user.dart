class User {
  String name;
  String email;
  String phone;
  DateTime birthDate;
  String gender;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.gender,
  });
}

class UserSession {
  static User? currentUser; // user đang đăng nhập
  static User? registeredUser; // user đã đăng ký
}
