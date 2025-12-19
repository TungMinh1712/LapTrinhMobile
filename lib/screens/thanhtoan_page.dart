import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'lichsu_thanhtoan_page.dart';
import 'lienket_hoso_page.dart';

/// ================= ENUM =================
enum PaymentStatus { unpaid, pending, paid, canceled }
enum BillType { service, medicine }

/// ================= MODEL =================
class PatientProfile {
  final String id;
  final String name;
  final String relation;

  PatientProfile({
    required this.id,
    required this.name,
    required this.relation,
  });
}

class Bill {
  final String id;
  final BillType type;
  final String name;
  final int amount;
  PaymentStatus status;

  Bill({
    required this.id,
    required this.type,
    required this.name,
    required this.amount,
    this.status = PaymentStatus.unpaid,
  });
}

class ThanhToanPage extends StatefulWidget {
  const ThanhToanPage({super.key});

  @override
  State<ThanhToanPage> createState() => _ThanhToanPageState();
}

class _ThanhToanPageState extends State<ThanhToanPage> {
  /// ================= FAKE DATA =================
  final List<PatientProfile> profiles = [];

  final List<Bill> bills = [
    Bill(
      id: "PCD001",
      type: BillType.service,
      name: "Phiếu chỉ định: Khám tổng quát",
      amount: 150000,
    ),
    Bill(
      id: "PCD002",
      type: BillType.service,
      name: "Phiếu chỉ định: Xét nghiệm máu",
      amount: 220000,
    ),
  ];

  bool get hasProfile => profiles.isNotEmpty;

  String formatMoney(int vnd) {
    return "${vnd.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    )} ₫";
  }

  /// ================= QR MOMO =================
  void _showMomoQR(Bill bill, PatientProfile profile) {
    final qrPayload = """
{
  "orderId":"${bill.id}",
  "amount":${bill.amount},
  "profile":"${profile.name}"
}
""";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Quét mã MoMo để thanh toán",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffE91E63),
                ),
              ),
              const SizedBox(height: 16),
              QrImageView(
                data: qrPayload,
                size: 220,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                "${bill.name}\nHồ sơ: ${profile.name}\nSố tiền: ${formatMoney(bill.amount)}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xff1F2937),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Hủy"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE91E63),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          bill.status = PaymentStatus.paid;
                        });
                      },
                      child: const Text(
                        "Xác nhận",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F9FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Thanh toán viện phí",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LichSuThanhToanPage(),
                ),
              );
            },
            child: const Text(
              "Lịch sử thanh toán →",
              style: TextStyle(
                color: Color(0xff0B5ED7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: hasProfile ? _buildPaymentList() : _buildEmptyProfile(),
    );
  }

  /// ================= CHƯA CÓ HỒ SƠ =================
  Widget _buildEmptyProfile() {
    return Column(
      children: [
        const SizedBox(height: 48),

        Image.asset(
          "assets/images/empty_profile.png",
          height: 240,
          errorBuilder: (_, __, ___) {
            return const Icon(
              Icons.person_outline,
              size: 140,
              color: Color(0xff94A3B8),
            );
          },
        ),

        const SizedBox(height: 24),

        const Text(
          "Chưa có hồ sơ bệnh nhân",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff1E293B),
          ),
        ),

        const SizedBox(height: 8),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            "Vui lòng liên kết hồ sơ để tiếp tục thanh toán viện phí.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xff475569),
            ),
          ),
        ),

        const Spacer(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LienKetHoSoPage(),
                  ),
                );

                if (result == true) {
                  setState(() {
                    profiles.add(
                      PatientProfile(
                        id: "HS01",
                        name: "Nguyễn Văn A",
                        relation: "Bản thân",
                      ),
                    );
                  });
                }
              },
              child: const Text(
                "Liên kết hồ sơ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ================= DANH SÁCH THANH TOÁN =================
  Widget _buildPaymentList() {
    final profile = profiles.first;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: bills.map((bill) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: Color(0xff0B5ED7),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Số tiền: ${formatMoney(bill.amount)}",
                        style: const TextStyle(color: Color(0xff475569)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0B5ED7),
                  ),
                  onPressed: () => _showMomoQR(bill, profile),
                  child: const Text(
                    "Thanh toán",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
