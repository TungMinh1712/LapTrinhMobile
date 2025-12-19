import 'package:flutter/material.dart';

class LichSuThanhToanPage extends StatelessWidget {
  const LichSuThanhToanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xffF4F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xff1F5BD8),
          elevation: 0,
          foregroundColor: Colors.white, // ✅ chữ + icon TRẮNG
          title: const Text(
            "Lịch sử thanh toán",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Column(
              children: [
                // ====== CHỌN KHOẢNG NGÀY ======
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff2A66E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Từ\n19/09/2025",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.white),
                      Text(
                        "Đến\n19/12/2025",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // ====== TAB BAR ======
                const TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white, // ✅ chữ tab TRẮNG
                  unselectedLabelColor: Color(0xffD6E1FF),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(text: "Phiếu chỉ định"),
                    Tab(text: "Đơn thuốc"),
                    Tab(text: "Viện phí nội trú"),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ====== NỘI DUNG TAB ======
        body: const TabBarView(
          children: [
            _EmptyTab(),
            _EmptyTab(),
            _EmptyTab(),
          ],
        ),
      ),
    );
  }
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff94A9D6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          "Không có dữ liệu!",
          style: TextStyle(
            color: Colors.white, // ✅ TRẮNG
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
