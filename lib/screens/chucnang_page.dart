import 'package:flutter/material.dart';

class ChucNangPage extends StatelessWidget {
  const ChucNangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef7ff),
      appBar: AppBar(title: const Text("Chức năng")),
      body: const Center(
        child: Text("Trang Chức năng", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
