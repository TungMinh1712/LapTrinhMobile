import 'package:flutter/material.dart';

class LichSuDatKhamPage extends StatefulWidget {
  const LichSuDatKhamPage({super.key});

  @override
  State<LichSuDatKhamPage> createState() => _LichSuDatKhamPageState();
}

class _LichSuDatKhamPageState extends State<LichSuDatKhamPage> {
  // Dữ liệu giả lập (Mock Data)
  // Trong thực tế, bạn sẽ lấy list này từ API trả về
  final List<Map<String, dynamic>> allBookings = [
    {
      "id": "BK001",
      "doctorName": "BS. Nguyễn Văn A",
      "specialty": "Nội khoa",
      "date": "20/12/2025",
      "time": "08:00",
      "status": "upcoming", // upcoming, completed, cancelled
      "patientName": "Nguyễn Văn Test"
    },
    {
      "id": "BK002",
      "doctorName": "BS. Trần Thị B",
      "specialty": "Nhi khoa",
      "date": "22/12/2025",
      "time": "09:30",
      "status": "upcoming",
      "patientName": "Trần Bé Bi"
    },
    {
      "id": "BK003",
      "doctorName": "BS. Lê Văn C",
      "specialty": "Tim mạch",
      "date": "10/12/2025",
      "time": "14:00",
      "status": "completed",
      "patientName": "Nguyễn Văn Test"
    },
    {
      "id": "BK004",
      "doctorName": "BS. Phạm Thị D",
      "specialty": "Da liễu",
      "date": "01/12/2025",
      "time": "10:00",
      "status": "cancelled",
      "patientName": "Nguyễn Văn Test"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Dùng DefaultTabController để quản lý Tabs đơn giản
    return DefaultTabController(
      length: 3, // Tổng số tab (Sắp tới, Hoàn thành, Đã hủy)
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lịch sử khám bệnh"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(text: "Sắp tới"),
              Tab(text: "Hoàn thành"),
              Tab(text: "Đã hủy"),
            ],
          ),
        ),
        body: Container(
          color: Colors.grey[100], // Màu nền nhẹ cho ứng dụng
          child: TabBarView(
            children: [
              _buildListByStatus("upcoming"),
              _buildListByStatus("completed"),
              _buildListByStatus("cancelled"),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm lọc danh sách theo trạng thái và hiển thị
  Widget _buildListByStatus(String status) {
    // Lọc dữ liệu
    final displayList =
        allBookings.where((item) => item['status'] == status).toList();

    // Nếu không có dữ liệu thì hiện thông báo trống
    if (displayList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              "Chưa có lịch khám nào",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Nếu có dữ liệu thì hiện ListView
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final booking = displayList[index];
        return _buildBookingCard(booking);
      },
    );
  }

  // Widget hiển thị từng thẻ lịch khám (Card)
  Widget _buildBookingCard(Map<String, dynamic> booking) {
    Color statusColor;
    String statusText;

    // Xử lý màu sắc và chữ dựa trên trạng thái
    switch (booking['status']) {
      case 'upcoming':
        statusColor = Colors.blue;
        statusText = "Sắp tới";
        break;
      case 'completed':
        statusColor = Colors.green;
        statusText = "Đã khám";
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = "Đã hủy";
        break;
      default:
        statusColor = Colors.grey;
        statusText = "Không rõ";
    }

    return Card(
      elevation: 2, // Độ nổi của thẻ
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dòng 1: Thời gian và Trạng thái
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      "${booking['time']} - ${booking['date']}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 25), // Đường kẻ ngang

            // Dòng 2: Thông tin bác sĩ
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  radius: 25,
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['doctorName'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Chuyên khoa: ${booking['specialty']}",
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Bệnh nhân: ${booking['patientName']}",
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Dòng 3 (Optional): Nút hành động nếu là Sắp tới
            if (booking['status'] == 'upcoming') ...[
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Xử lý sự kiện xem chi tiết hoặc hủy
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Chi tiết lịch hẹn"),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
