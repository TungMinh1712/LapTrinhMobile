import 'package:flutter/material.dart';

class HuongDanPage extends StatelessWidget {
  const HuongDanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f6fb),
      appBar: AppBar(
        title: const Text("Hướng dẫn khách hàng"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildGuideItem(
              title: "Trải nghiệm hành trình khám bệnh thường quy",
              imagePath: "assets/images/hanhtrinhkhambenh.jpg",
            ),
            _buildGuideItem(
              title: "Hướng dẫn thủ tục khám chữa bệnh bảo hiểm",
              imagePath: "assets/images/thutuckhambenh.jpg",
            ),
            _buildGuideItem(
              title: "Thanh toán đơn thuốc trực tiếp trên ứng dụng",
              imagePath: "assets/images/thanhtoanhoadononline.jpg",
            ),
            _buildGuideItem(
              title: "Hướng dẫn giấy chuyển tuyến người bệnh",
              imagePath: "assets/images/huongdanchuyenvien.jpg",
            ),
            _buildGuideItem(
              title: "Thông tin hướng dẫn người nuôi bệnh tại khoa",
              imagePath: "assets/images/huongdannguoinuoibenh.jpg",
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff6fb1fc),
            Color(0xff4364f7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Hướng dẫn khách hàng",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Thông tin & hướng dẫn sử dụng dịch vụ",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ================= ITEM =================
  Widget _buildGuideItem({
    required String title,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          // IMAGE
          Container(
            width: 90,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xffe3f2fd),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.blue,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // TITLE
          Expanded(
            child: Text(
              title.toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff1a3c7c),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
