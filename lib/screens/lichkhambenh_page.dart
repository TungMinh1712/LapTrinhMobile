import 'package:flutter/material.dart';
import '../services/doctor_service.dart';
import '../models/doctor_model.dart';

class LichKhamBenhPage extends StatefulWidget {
  const LichKhamBenhPage({super.key});

  @override
  State<LichKhamBenhPage> createState() => _LichKhamBenhPageState();
}

class _LichKhamBenhPageState extends State<LichKhamBenhPage> {
  final DoctorService _doctorService = DoctorService();

  String selectedDepartment = "Tất cả";

  final List<String> departments = [
    "Tất cả",
    "Nội tổng quát",
    "Ngoại khoa",
    "Tim mạch",
    "Nhi khoa",
    "Da liễu",
    "Tai mũi họng",
    "Răng hàm mặt",
    "Sản phụ khoa",
    "Thần kinh",
    "Cơ xương khớp",
    "Tiêu hóa",
    "Hô hấp",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch khám bệnh"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDepartmentFilter(),
          Expanded(
            child: StreamBuilder<List<Doctor>>(
              stream: _doctorService.getDoctors(
                department: selectedDepartment,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Không có bác sĩ"));
                }

                final doctors = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return _buildDoctorItem(doctor);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILTER =================
  Widget _buildDepartmentFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          final isSelected = dept == selectedDepartment;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(dept),
              selected: isSelected,
              selectedColor: Colors.blue,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
              onSelected: (_) {
                setState(() => selectedDepartment = dept);
              },
            ),
          );
        },
      ),
    );
  }

  // ================= DOCTOR ITEM =================
  Widget _buildDoctorItem(Doctor doctor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          doctor.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Khoa: ${doctor.department}"),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text("Đặt lịch"),
        ),
      ),
    );
  }
}
