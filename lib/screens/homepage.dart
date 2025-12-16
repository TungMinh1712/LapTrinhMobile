import 'package:flutter/material.dart';
import 'datkham_page.dart';
import 'hoadon_page.dart';
import 'hososuckhoe_page.dart';
import 'ketqua_page.dart';
import 'hotro_page.dart';
import 'lichsudatkham_page.dart';
import 'thanhtoan_page.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
              children: [
                _menuItem(
                  context,
                  "assets/icons/dat_kham.jpg",
                  "Đặt khám",
                  const DatKhamPage(),
                ),
                _menuItem(
                  context,
                  "assets/icons/lich.png",
                  "Lịch sử đặt khám",
                  const LichSuDatKhamPage(),
                ),
                _menuItem(
                  context,
                  "assets/icons/thanhtoan.png",
                  "Thanh toán viện phí",
                  const ThanhToanPage(),
                ),
                _menuItem(
                  context,
                  "assets/icons/hoadon.png",
                  "Hoá đơn điện tử",
                  const HoaDonPage(),
                ),
                _menuItem(
                  context,
                  "assets/icons/hoso.png",
                  "Hồ sơ sức khoẻ",
                  const HoSoSucKhoePage(),
                ),
                _menuItem(
                  context,
                  "assets/icons/canlam.png",
                  "Kết quả cận lâm sàng",
                  const KetQuaPage(),
                ),
                _menuItem(
                  context,
                  "assets/icons/hotro.png",
                  "Hỗ trợ",
                  const HoTroPage(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/images/benhvien.jpg",
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 70),
        ],
      ),
    );
  }

  static Widget _menuItem(
    BuildContext context,
    String icon,
    String title,
    Widget page,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(icon, width: 40, height: 40),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
