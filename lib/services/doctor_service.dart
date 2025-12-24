import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor_model.dart';

class DoctorService {
  final _ref = FirebaseFirestore.instance.collection('doctors');

  Stream<List<Doctor>> getDoctors({String? department}) {
    Query query = _ref;

    if (department != null && department != "Tất cả") {
      query = query.where('department', isEqualTo: department);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList();
    });
  }
}
