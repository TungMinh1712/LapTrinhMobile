import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_model.dart';

/// =======================================================
/// ================== TRANG CHỌN HỒ SƠ ===================
/// =======================================================
class KetQuaPage extends StatelessWidget {
  const KetQuaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = UserSession.currentUser!.phone;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kết quả cận lâm sàng"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final patients = snapshot.data!.docs;

          if (patients.isEmpty) {
            return const Center(
              child:
                  Text("Chưa có hồ sơ", style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final p = patients[index];

              return _HoSoItem(
                ten: p['fullName'],
                sdt: p['phone'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KetQuaCanLamSangPage(
                        patientId: p.id,
                        patientName: p['fullName'],
                 
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// ================= ITEM HỒ SƠ =================
class _HoSoItem extends StatelessWidget {
  final String ten;
  final String sdt;
  final VoidCallback onTap;

  const _HoSoItem({
    required this.ten,
    required this.sdt,
    required this.onTap,
  });

  String maskPhone(String phone) {
    if (phone.length < 7) return phone;
    return phone.replaceRange(3, phone.length - 3, "****");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE3F2FD),
          child: Icon(Icons.folder_shared, color: Colors.blue),
        ),
        title: Text(
          ten.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        subtitle: Text("SĐT: ${maskPhone(sdt)}"),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/// =======================================================
/// ============ TRANG KẾT QUẢ CẬN LÂM SÀNG =================
/// =======================================================
class KetQuaCanLamSangPage extends StatefulWidget {
  final String patientId;
  final String patientName;

  const KetQuaCanLamSangPage({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<KetQuaCanLamSangPage> createState() => _KetQuaCanLamSangPageState();
}

class _KetQuaCanLamSangPageState extends State<KetQuaCanLamSangPage> {
  String? selectedType;
  int selectedYear = DateTime.now().year;


  final List<String> types = const [
    "X Quang",
    "CT Scan",
    "MRI",
    "Siêu âm",
    "Xét nghiệm",
    "Nội soi",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kết quả cận lâm sàng"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== TÊN BỆNH NHÂN =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
                widget.patientName.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
          ),

          /// ===== FILTER =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _FilterItem(
                    label: "Chọn loại",
                    value: selectedType ?? "Chưa chọn",
                    onTap: _chonLoai,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _FilterItem(
                    label: "Chọn năm",
                    value: selectedYear.toString(),
                    onTap: _chonNam,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          /// ===== DANH SÁCH KẾT QUẢ =====
          Expanded(
            child: selectedType == null
                ? const _ChuaChonLoai()
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('clinical_results')
                        .where('patientId', isEqualTo: widget.patientId)
                        .where('type', isEqualTo: selectedType)
                        .where('year', isEqualTo: selectedYear)
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "Không có kết quả",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final d = docs[index];
                          final date = (d['date'] as Timestamp).toDate();

                          return _KetQuaItem(
                            title: "${d['title']} (${d['code']})",
                            date: "${date.day}/${date.month}/${date.year}",
                            fileUrl: d['fileUrl'],
                          );
                        },
                      );
                    },
                  ),
          ),

        ],
      ),
    );
  }

  /// ===== CHỌN LOẠI =====
  void _chonLoai() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ListView(
        shrinkWrap: true,
        children: types.map((e) {
          return ListTile(
            title: Text(e),
            onTap: () {
              setState(() => selectedType = e);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  /// ===== CHỌN NĂM =====
  void _chonNam() {
    final years = List.generate(6, (i) => DateTime.now().year - i);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ListView(
        shrinkWrap: true,
        children: years.map((y) {
          return ListTile(
            title: Text(y.toString()),
            onTap: () {
              setState(() => selectedYear = y);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
class _ChuaChonLoai extends StatelessWidget {
  const _ChuaChonLoai();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_list, size: 80, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "Vui lòng chọn loại kết quả",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// ================= ITEM KẾT QUẢ =================
class _KetQuaItem extends StatelessWidget {
  final String title;
  final String date;
  final String fileUrl;

  const _KetQuaItem({
    required this.title,
    required this.date,
    required this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(fileUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.picture_as_pdf, color: Colors.red, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(date),
          ],
        ),
      ),
    );
  }
}

/// ================= FILTER ITEM =================
class _FilterItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _FilterItem({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
