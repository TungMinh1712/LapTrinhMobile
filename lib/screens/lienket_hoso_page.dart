import 'package:flutter/material.dart';

class LienKetHoSoPage extends StatefulWidget {
  const LienKetHoSoPage({super.key});

  @override
  State<LienKetHoSoPage> createState() => _LienKetHoSoPageState();
}

class _LienKetHoSoPageState extends State<LienKetHoSoPage> {
  final TextEditingController _maNguoiBenhCtrl = TextEditingController();
  final TextEditingController _cccdCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text(
            "Hồ sơ khám bệnh",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xff0B5ED7),
            labelColor: Color(0xff0B5ED7),
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: "Nhập mã người bệnh"),
              Tab(text: "Quên hồ sơ"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNhapMaNguoiBenh(),
            _buildQuenHoSo(),
          ],
        ),
      ),
    );
  }

  /// ================= TAB 1: NHẬP MÃ =================
  Widget _buildNhapMaNguoiBenh() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vui lòng nhập chính xác mã người bệnh",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _maNguoiBenhCtrl,
                  decoration: InputDecoration(
                    hintText: "N18-000XXXX",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0B5ED7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // 👉 TRẢ DATA VỀ
                    Navigator.pop(context, {
                      "ma": _maNguoiBenhCtrl.text,
                      "ten": "NGUYỄN DUY PHONG",
                      "phone": "077****712",
                    });
                  },
                  child: const Text(
                    "Tìm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Text(
            "Quên mã người bệnh?",
            style: TextStyle(color: Color(0xff0B5ED7)),
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.info_outline, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Mã người bệnh được in trên đơn thuốc, phiếu chỉ định hoặc phiếu trả kết quả cận lâm sàng.",
                  style: TextStyle(color: Colors.black54, height: 1.4),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Text(
            "Xem gợi ý →",
            style: TextStyle(color: Color(0xff0B5ED7)),
          ),
        ],
      ),
    );
  }

  /// ================= TAB 2: QUÊN HỒ SƠ =================
  Widget _buildQuenHoSo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nhập thông tin để tìm hồ sơ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _cccdCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Số CCCD / CMND",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Số điện thoại",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0B5ED7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // 👉 TRẢ DATA VỀ
                Navigator.pop(context, {
                  "ma": "N18-0001234",
                  "ten": "NGUYỄN DUY PHONG",
                  "phone": "077****712",
                });
              },
              child: const Text(
                "Tìm hồ sơ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
