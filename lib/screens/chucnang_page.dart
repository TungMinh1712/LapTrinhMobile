import 'package:flutter/material.dart';
import 'huongdan_page.dart';
import 'lienhe_page.dart';

class ChucNangPage extends StatelessWidget {
  const ChucNangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef7ff),
      appBar: AppBar(
        title: const Text("Chức năng"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCardItem(
              icon: Icons.calendar_month,
              title: "Lịch khám bệnh",
              onTap: () {},
            ),
            _buildCardItem(
              icon: Icons.price_change,
              title: "Bảng giá dịch vụ",
              onTap: () {},
            ),
            _buildCardItem(
              icon: Icons.phone,
              title: "Liên hệ",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LienHePage(),
                  ),
                );
              },
            ),
            _buildCardItem(
              icon: Icons.menu_book,
              title: "Hướng dẫn khách hàng",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HuongDanPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xffe3f2fd),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.blue,
          size: 28,
        ),
      ),
    );
  }
}
