import 'package:flutter/material.dart';

class KetQuaPage extends StatelessWidget {
  const KetQuaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kết quả")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            HoSoItem(
              ten: "TRẦN TÙNG MINH",
              ma: "W25-0555247",
              sdt: "038****034",
            ),
          ],
        ),
      ),
    );
  }
}

class HoSoItem extends StatelessWidget {
  final String ten;
  final String ma;
  final String sdt;

  const HoSoItem({
    super.key,
    required this.ten,
    required this.ma,
    required this.sdt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE3F2FD),
          child: Icon(Icons.info, color: Colors.blue),
        ),
        title: Text(
          ten,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.confirmation_number, size: 16),
                  const SizedBox(width: 6),
                  Text(ma),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16),
                  const SizedBox(width: 6),
                  Text(sdt),
                ],
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const ChonChucNangSheet(),
          );
        },
      ),
    );
  }
}

class ChonChucNangSheet extends StatelessWidget {
  const ChonChucNangSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nút đóng
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          const Text(
            "CHỌN CHỨC NĂNG",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          const Text(
            "Hồ sơ: TRẦN TÙNG MINH (W25-0555247)",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue),
          ),

          const SizedBox(height: 20),
          _buildButton("XEM KẾT QUẢ CẬN LÂM SÀNG"),
          _buildButton("XEM HÌNH ẢNH CHỤP"),
        ],
      ),
    );
  }

  Widget _buildButton(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
