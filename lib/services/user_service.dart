import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/password_utils.dart';

class UserService {
  static final _db = FirebaseFirestore.instance;
  static const _collection = 'users';

  static Future<bool> isPhoneExists(String phone) async {
    final doc = await _db.collection(_collection).doc(phone).get();
    return doc.exists;
  }

  static Future<void> createUser(UserModel user) async {
    await _db.collection(_collection).doc(user.phone).set(user.toMap());
  }

  static Future<UserModel?> login(
    String phone,
    String password,
  ) async {
    final doc = await _db.collection(_collection).doc(phone).get();
    if (!doc.exists) return null;

    final user = UserModel.fromMap(doc.data()!);
    final inputHash = PasswordUtils.hash(password);

    if (user.password != inputHash) return null;

    return user;
  }
}
