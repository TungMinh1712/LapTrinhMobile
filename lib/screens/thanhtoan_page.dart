import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class ThanhToanPage extends StatelessWidget {
  const ThanhToanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh Toán'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Trang Thanh Toán'),
      ),
    );
  }
}