import 'package:flutter/material.dart';

class ThongBaoPage extends StatelessWidget {
  const ThongBaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef7ff),
      appBar: AppBar(
          title: const Text("Thông báo"),
          centerTitle: true,
          automaticallyImplyLeading: false),
      body: const Center(
        child: Text("Trang Thông báo", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
