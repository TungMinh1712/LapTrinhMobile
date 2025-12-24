import 'package:flutter/material.dart';

class LienHePage extends StatefulWidget {
  const LienHePage({super.key});

  @override
  State<LienHePage> createState() => _LienHePageState();
}

class _LienHePageState extends State<LienHePage> {
  int selectedIndex = 0;

  final List<Map<String, String>> campuses = [
    {
      "name": "Cơ sở 1 – HUTECH",
      "address": "475A Điện Biên Phủ, Phường 25, Quận Bình Thạnh, TP.HCM",
      "phone": "(028) 5445 7777",
      "email": "hutech@hutech.edu.vn",
      "website": "https://www.hutech.edu.vn",
      "image": "assets/images/hutech_cs1.jpg",
      "map": "assets/images/map_cs1.png",
    },
    {
      "name": "Cơ sở 2 – HUTECH",
      "address": "31/36 Ung Văn Khiêm, Phường 25, Quận Bình Thạnh, TP.HCM",
      "phone": "(028) 5445 7777",
      "email": "hutech@hutech.edu.vn",
      "website": "https://www.hutech.edu.vn",
      "image": "assets/images/hutech_cs2.jpg",
      "map": "assets/images/map_cs2.png",
    },
    {
      "name": "Cơ sở 3 – HUTECH",
      "address":
          "Khu Công nghệ cao XLHN, Hiệp Phú, Thủ Đức, Thành phố Hồ Chí Minh, Việt Nam",
      "phone": "(028) 5445 7777",
      "email": "hutech@hutech.edu.vn",
      "website": "https://www.hutech.edu.vn",
      "image": "assets/images/hutech_cs3.jpg",
      "map": "assets/images/map_cs3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final campus = campuses[selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xffeaf6ff),
      body: Column(
        children: [
          _buildHeader(campus["image"]!),
          _buildTabs(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInfoCard(campus),
                  const SizedBox(height: 12),
                  _buildMap(campus["map"]!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(String imagePath) {
    return Stack(
      children: [
        Image.asset(
          imagePath,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.2),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: 40,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const Positioned(
          left: 16,
          bottom: 20,
          child: Text(
            "Liên hệ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ================= TABS =================
  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(campuses.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  "Cơ sở ${index + 1}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ================= INFO CARD =================
  Widget _buildInfoCard(Map<String, String> campus) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          Text(
            campus["name"]!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on, campus["address"]!),
          _buildInfoRow(Icons.phone, campus["phone"]!),
          _buildInfoRow(Icons.email, campus["email"]!),
          _buildInfoRow(Icons.language, campus["website"]!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ================= MAP =================
  Widget _buildMap(String mapPath) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          mapPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
