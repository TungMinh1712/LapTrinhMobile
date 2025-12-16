import 'package:flutter/material.dart';

class CaNhanPage extends StatelessWidget {
  const CaNhanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef7ff),
      appBar: AppBar(title: const Text("Cá nhân")),
      body: const Center(
        child: Text("Trang Cá nhân", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
