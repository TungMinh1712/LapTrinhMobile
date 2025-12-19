import 'package:flutter/material.dart';
import 'lienket_hoso_page.dart';

class HoaDonPage extends StatefulWidget {
  const HoaDonPage({super.key});

  @override
  State<HoaDonPage> createState() => _HoaDonPageState();
}

class _HoaDonPageState extends State<HoaDonPage> {
  /// ====== HỒ SƠ (FAKE) ======
  Map<String, dynamic>? profile;

  /// ====== HÓA ĐƠN FAKE (3 HÓA ĐƠN) ======
  final List<Map<String, dynamic>> fakeBills = [
    {
      "ma": "HD001",
      "ten": "Khám tổng quát",
      "ngay": "19/12/2025",
      "soTien": 150000,
      "trangThai": "Đã thanh toán",
    },
    {
      "ma": "HD002",
      "ten": "Xét nghiệm máu",
      "ngay": "18/12/2025",
      "soTien": 220000,
      "trangThai": "Đã thanh toán",
    },
    {
      "ma": "HD003",
      "ten": "Đơn thuốc sau khám",
      "ngay": "18/12/2025",
      "soTien": 180000,
      "trangThai": "Đã thanh toán",
    },
  ];

  String _formatMoney(int vnd) {
    return "${vnd.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    )} ₫";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Xem hóa đơn",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: profile == null ? _emptyView() : _contentView(),
    );
  }

  /// ================= CHƯA LIÊN KẾT =================
  Widget _emptyView() {
    return Column(
      children: [
        const Spacer(),
        const Text(
          "Bạn chưa liên kết hồ sơ",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0B5ED7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _linkProfile,
              child: const Text(
                "Liên kết hồ sơ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ================= ĐÃ LIÊN KẾT =================
  Widget _contentView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// ====== THẺ HỒ SƠ ======
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xffE0E0E0)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xffE7F0FF),
                child: Icon(Icons.person, color: Color(0xff0B5ED7)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile!["ten"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0B5ED7),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(profile!["ma"]),
                    Text(profile!["phone"]),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),

        const SizedBox(height: 24),

        /// ====== DANH SÁCH HÓA ĐƠN ======
        const Text(
          "Danh sách hóa đơn",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        ...fakeBills.map(
          (bill) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.green, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill["ten"],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text("Ngày: ${bill["ngay"]}"),
                      Text("Số tiền: ${_formatMoney(bill["soTien"])}"),
                    ],
                  ),
                ),
                Column(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(height: 4),
                    Text(
                      "Đã TT",
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ================= LIÊN KẾT HỒ SƠ =================
  Future<void> _linkProfile() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const LienKetHoSoPage()),
    );

    if (result != null) {
      setState(() {
        profile = result;
      });
    }
  }
}
