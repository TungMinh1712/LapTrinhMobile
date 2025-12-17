import 'package:flutter/material.dart';

class HoTroPage extends StatefulWidget {
  const HoTroPage({super.key});

  @override
  State<HoTroPage> createState() => _HoTroPageState();
}

class _HoTroPageState extends State<HoTroPage>
    with SingleTickerProviderStateMixin {
  bool isQuyTrinh = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hỗ trợ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// THÔNG TIN TỔNG ĐÀI
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Trang thông tin hỗ trợ khách hàng\nSố tổng đài: 1234 5678",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),

            const SizedBox(height: 16),

            /// SEGMENTED CONTROL: QUY TRÌNH / FAQ
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => isQuyTrinh = true);
                    },
                    icon: const Icon(Icons.list),
                    label: const Text("QUY TRÌNH"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isQuyTrinh
                          ? Colors.blue
                          : Colors.grey.shade300,
                      foregroundColor: isQuyTrinh ? Colors.white : Colors.blue,
                      elevation: isQuyTrinh ? 2 : 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => isQuyTrinh = false);
                    },
                    icon: const Icon(Icons.help_outline),
                    label: const Text("CÂU HỎI THƯỜNG GẶP"),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !isQuyTrinh
                          ? Colors.blue
                          : Colors.transparent,
                      foregroundColor: !isQuyTrinh ? Colors.white : Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// CONTENT
            Expanded(child: isQuyTrinh ? const QuyTrinhList() : _buildFAQ()),
          ],
        ),
      ),
    );
  }

  /// ================= FAQ =================
  Widget _buildFAQ() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: "Vấn đề chung"),
            Tab(text: "Tài khoản"),
            Tab(text: "Thanh toán"),
            Tab(text: "Quy trình"),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildList([
                "Lợi ích khi sử dụng phần mềm đăng ký khám bệnh?",
                "Làm sao để sử dụng phần mềm?",
              ]),
              _buildList(["Hướng dẫn quản lý tài khoản"]),
              _buildList(["Hướng dẫn thanh toán"]),
              _buildList(["Quy trình khám bệnh"]),
            ],
          ),
        ),
      ],
    );
  }

  /// ================= LIST DÙNG CHUNG (FAQ) =================
  static Widget _buildList(List<String> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.help_outline,
              color: Colors.blue,
              size: 22,
            ),
            title: Text(
              items[index],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 22,
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}

/// ================= QUY TRÌNH =================
class QuyTrinhList extends StatelessWidget {
  const QuyTrinhList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      "Hướng dẫn đồng bộ số hồ sơ người bệnh trên ứng dụng di động ",
      "Hướng dẫn quy trình đặt khám",
      "Hướng dẫn hủy phiếu đặt khám",
      "Hướng dẫn quy trình khám bệnh",
      "Hướng dẫn thanh toán đơn thuốc trên ứng dụng",
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.blue),
            title: Text(
              items[index],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey, // ✅ mũi tên xám
            ),
            onTap: () {
              // Navigator.push sang trang chi tiết
            },
          ),
        );
      },
    );
  }
}
