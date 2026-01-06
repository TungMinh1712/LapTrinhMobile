import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LichSuDatKhamPage extends StatelessWidget {
  const LichSuDatKhamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F8FF),
        appBar: AppBar(
          title: const Text('Lịch sử đặt khám'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          elevation: 1,
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'Đã đặt'),
              Tab(text: 'Hoàn thành'),
              Tab(text: 'Đã hủy'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BookingList(status: 'pending'),
            _BookingList(status: 'completed'),
            _BookingList(status: 'canceled'),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final String status;

  const _BookingList({required this.status});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: status)
          .snapshots(), // ❌ BỎ orderBy
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const _EmptyState();
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return _BookingCard(data: docs[index]);
          },
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final QueryDocumentSnapshot data;

  const _BookingCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (data['status']) {
      case 'pending':
        statusColor = Colors.blue;
        statusText = 'Đã đặt';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusText = 'Hoàn thành';
        break;
      case 'canceled':
        statusColor = Colors.red;
        statusText = 'Đã hủy';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Không rõ';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${data['time']} • ${data['date']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _statusChip(statusText, statusColor),
            ],
          ),
          const Divider(height: 24),
          _infoRow(Icons.person, 'Bệnh nhân', data['patientName']),
          _infoRow(Icons.medical_services, 'Bác sĩ', data['doctorName']),
          _infoRow(Icons.local_hospital, 'Chuyên khoa', data['department']),
          _infoRow(Icons.meeting_room, 'Phòng', data['room']),
        ],
      ),
    );
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

/// ================= EMPTY STATE =================
class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Chưa có lịch khám',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
