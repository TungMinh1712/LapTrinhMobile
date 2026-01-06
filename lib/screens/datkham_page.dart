import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doanlaptrinhmobile/models/patient_model.dart';
import 'package:doanlaptrinhmobile/models/appointment_model.dart';
import 'dart:math';
import 'package:doanlaptrinhmobile/screens/main_navigation.dart';

/// ================= ENTRY PAGE =================
class DatKhamPage extends StatelessWidget {
  const DatKhamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt khám')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Chọn hồ sơ đặt khám',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          /// ==== AVATAR HỒ SƠ ====
          SizedBox(
            height: 130,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('patients').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _avatarAdd(context),
                    ...docs.map((doc) => _avatarProfile(context, doc)).toList(),
                  ],
                );
              },
            ),
          ),

          const Divider(),

          /// ==== DANH SÁCH HỒ SƠ ====
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('patients').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: snapshot.data!.docs.map((doc) {
                    return _patientCard(context, doc);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ================= UI =================

  Widget _avatarAdd(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TaoHoSoPage()),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.blue.shade50,
            child: const Icon(Icons.add, color: Colors.blue, size: 32),
          ),
          const SizedBox(height: 8),
          const Text(
            'Thêm mới\nhồ sơ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _avatarProfile(BuildContext context, QueryDocumentSnapshot doc) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChonNgayKhamPage(
                patientId: doc.id,
                patientName: doc['fullName'],
              ),
            ),
          );
        },
        child: Column(
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              doc['fullName'],
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _patientCard(BuildContext context, QueryDocumentSnapshot doc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(doc['fullName'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(doc['phone']),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChonNgayKhamPage(
                patientId: doc.id,
                patientName: doc['fullName'],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ================= TẠO HỒ SƠ =================
class TaoHoSoPage extends StatefulWidget {
  const TaoHoSoPage({super.key});

  @override
  State<TaoHoSoPage> createState() => _TaoHoSoPageState();
}

class _TaoHoSoPageState extends State<TaoHoSoPage> {
  final _formKey = GlobalKey<FormState>();

  String fullName = '';
  String phone = '';
  String cccd = '';
  String gender = 'Nam';
  DateTime? birthDate;
  String address = '';
  String job = '';

  Future<void> _savePatient() async {
    final patient = PatientModel(
      id: '',
      fullName: fullName,
      phone: phone,
      cccd: cccd,
      gender: gender,
      birthDate: birthDate!,
      address: address,
      job: job,
    );

    await FirebaseFirestore.instance
        .collection('patients')
        .add(patient.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tạo hồ sơ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _input(
                          icon: Icons.person,
                          label: 'Họ tên',
                          onSaved: (v) => fullName = v,
                        ),
                        _input(
                          icon: Icons.phone,
                          label: 'Số điện thoại',
                          keyboardType: TextInputType.phone,
                          onSaved: (v) => phone = v,
                        ),
                        _input(
                          icon: Icons.badge,
                          label: 'CCCD',
                          keyboardType: TextInputType.number,
                          onSaved: (v) => cccd = v,
                        ),

                        /// ===== GIỚI TÍNH =====
                        DropdownButtonFormField<String>(
                          value: gender,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.wc),
                            labelText: 'Giới tính',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                            DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                          ],
                          onChanged: (v) => setState(() => gender = v!),
                        ),

                        const SizedBox(height: 16),

                        /// ===== NGÀY SINH =====
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now()
                                  .subtract(const Duration(days: 365 * 20)),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => birthDate = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.cake),
                              labelText: 'Ngày sinh',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              birthDate == null
                                  ? 'Chọn ngày sinh'
                                  : '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
                              style: TextStyle(
                                color: birthDate == null
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),

                        if (birthDate == null)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                            ),
                          ),

                        const SizedBox(height: 16),

                        _input(
                          icon: Icons.work,
                          label: 'Nghề nghiệp',
                          onSaved: (v) => job = v,
                        ),
                        _input(
                          icon: Icons.location_on,
                          label: 'Địa chỉ',
                          maxLines: 2,
                          onSaved: (v) => address = v,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// ===== NÚT XÁC NHẬN =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate() && birthDate != null) {
                    _formKey.currentState!.save();
                    await _savePatient();
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'XÁC NHẬN',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ===== INPUT DÙNG CHUNG =====
  Widget _input({
    required IconData icon,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required Function(String) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Không được để trống' : null,
        onSaved: (v) => onSaved(v!),
      ),
    );
  }
}

/// ================= CHỌN NGÀY KHÁM =================
class ChonNgayKhamPage extends StatefulWidget {
  final String patientId;
  final String patientName;
  const ChonNgayKhamPage(
      {required this.patientId, required this.patientName, super.key});

  @override
  State<ChonNgayKhamPage> createState() => _ChonNgayKhamPageState();
}

class _ChonNgayKhamPageState extends State<ChonNgayKhamPage> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);

    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    /// Thứ trong tuần (T2 = 1 ... CN = 7)
    final startWeekday = firstDayOfMonth.weekday; // 1 - 7

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chọn ngày khám'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          /// ===== HEADER THÁNG =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month - 1,
                      );
                    });
                  },
                ),
                Text(
                  'Tháng ${_currentMonth.month}/${_currentMonth.year}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          /// ===== THỨ TRONG TUẦN =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _Weekday('T2'),
                _Weekday('T3'),
                _Weekday('T4'),
                _Weekday('T5'),
                _Weekday('T6'),
                _Weekday('T7'),
                _Weekday('CN'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// ===== LỊCH =====
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: daysInMonth + (startWeekday - 1),
              itemBuilder: (_, index) {
                /// Ô trống đầu tháng
                if (index < startWeekday - 1) {
                  return const SizedBox();
                }

                final day = index - (startWeekday - 2);
                final date = DateTime(
                  _currentMonth.year,
                  _currentMonth.month,
                  day,
                );

                final isPast = date
                    .isBefore(DateTime.now().subtract(const Duration(days: 1)));

                return GestureDetector(
                  onTap: isPast
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChonChuyenKhoaPage(
                                patientId: widget.patientId,
                                patientName: widget.patientName,
                                date: date,
                              ),
                            ),
                          );
                        },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isPast
                          ? Colors.grey.shade300
                          : const Color.fromARGB(255, 121, 192, 253),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: isPast ? Colors.grey : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ===== WIDGET THỨ =====
class _Weekday extends StatelessWidget {
  final String label;
  const _Weekday(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// ================= CHỌN CHUYÊN KHOA=================
class ChonChuyenKhoaPage extends StatelessWidget {
  final String patientId;
  final String patientName;
  final DateTime date;

  ChonChuyenKhoaPage({
    required this.patientId,
    required this.patientName,
    required this.date,
    super.key,
  });

  final departments = const [
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

  final int price = 150000;

  String formatPrice(int value) {
    return '${value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chọn chuyên khoa'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final d = departments[index];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChonBacSiVaGioPage(
                    patientId: patientId,
                    patientName: patientName,
                    date: date,
                    department: d,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  /// ICON INFO
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// TÊN KHOA
                  Expanded(
                    child: Text(
                      d.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  /// GIÁ TIỀN
                  Text(
                    formatPrice(price),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ================= CHỌN BÁC SĨ =================

class ChonBacSiVaGioPage extends StatelessWidget {
  final String patientId;
  final String patientName;
  final DateTime date;
  final String department;

  ChonBacSiVaGioPage({
    required this.patientId,
    required this.patientName,
    required this.date,
    required this.department,
    super.key,
  });

  final times = const [
    '06:30 - 07:30',
    '07:30 - 08:30',
    '08:30 - 09:30',
    '09:30 - 10:30',
    '10:30 - 11:30',
  ];

  String formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chọn khung giờ khám'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .where('department', isEqualTo: department)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final doctors = snapshot.data!.docs;

          if (doctors.isEmpty) {
            return const Center(child: Text('Chưa có bác sĩ'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doc = doctors[index];

              /// ✅ GÁN PHÒNG THEO THỨ TỰ BÁC SĨ
              final room = 'Phòng ${index + 1}';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ===== TÊN BÁC SĨ =====
                    Text(
                      doc['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// ===== PHÒNG =====
                    Text(
                      '$room - Buổi sáng',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// ===== NGÀY =====
                    Text(
                      '${formatDate(date)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green.shade700,
                      ),
                    ),

                    const Divider(height: 24),

                    /// ===== KHUNG GIỜ =====
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: times.map((t) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            final appointmentData = {
                              'patientId': patientId,
                              'patientName': patientName,
                              'doctorId': doc.id,
                              'doctorName': doc['name'],
                              'department': department,
                              'date': formatDate(date),
                              'time': t,
                              'room': room,
                              'status': 'pending',
                            };

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => XacNhanLichKhamPage(
                                  appointmentData: appointmentData,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Text(
                              t,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// ================= XÁC NHẬN LỊCH KHÁM =================
class XacNhanLichKhamPage extends StatefulWidget {
  final Map<String, dynamic> appointmentData;

  const XacNhanLichKhamPage({
    required this.appointmentData,
    super.key,
  });

  @override
  State<XacNhanLichKhamPage> createState() => _XacNhanLichKhamPageState();
}

class _XacNhanLichKhamPageState extends State<XacNhanLichKhamPage> {
  bool hasBHYT = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.appointmentData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Xác nhận lịch khám')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info('Bệnh nhân', data['patientName']),
            _info('Chuyên khoa', data['department']),
            _info('Bác sĩ', data['doctorName']),
            _info('Ngày', data['date']),
            _info('Giờ', data['time']),
            _info('Phòng', data['room']),

            const SizedBox(height: 20),

            /// ===== BHYT =====
            CheckboxListTile(
              value: hasBHYT,
              title: const Text('Có bảo hiểm y tế (BHYT)'),
              onChanged: (v) => setState(() => hasBHYT = v ?? false),
            ),

            const Spacer(),

            /// ===== XÁC NHẬN =====
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: const Text(
                  'XÁC NHẬN ĐẶT KHÁM',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  final finalData = {
                    ...data,
                    'hasBHYT': hasBHYT,
                    'createdAt': FieldValue.serverTimestamp(),
                  };

                  await FirebaseFirestore.instance
                      .collection('appointments')
                      .add(finalData);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigation()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
