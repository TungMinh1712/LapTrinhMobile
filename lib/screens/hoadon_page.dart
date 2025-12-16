import 'package:flutter/material.dart';

class HoaDonPage extends StatelessWidget {
  const HoaDonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hóa đơn")),
      body: const Center(child: Text("Trang Hóa đơn")),
    );
  }
}
