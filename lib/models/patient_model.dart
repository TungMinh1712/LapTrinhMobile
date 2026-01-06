import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  String id;
  String fullName;
  String phone;
  String cccd;
  String gender;
  DateTime birthDate;
  String address;
  String job;

  PatientModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.cccd,
    required this.gender,
    required this.birthDate,
    required this.address,
    required this.job,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'cccd': cccd,
      'gender': gender,
      'birthDate': birthDate,
      'address': address,
      'job': job,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
