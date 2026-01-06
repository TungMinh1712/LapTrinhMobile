import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String id;
  String patientId;
  String department;
  String doctorId;
  DateTime date;
  String time;
  String room;
  bool hasBHYT;

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.department,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.room,
    required this.hasBHYT,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'department': department,
      'doctorId': doctorId,
      'date': date,
      'time': time,
      'room': room,
      'hasBHYT': hasBHYT,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
