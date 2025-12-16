import 'package:flutter/material.dart';
import 'homepage.dart';
import 'thongbao_page.dart';
import 'chucnang_page.dart';
import 'canhan_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Homepage(),
    ThongBaoPage(),
    ChucNangPage(),
    CaNhanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef7ff),

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Trang chủ"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined), label: "Thông báo"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined), label: "Chức năng"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Cá nhân"),
        ],
      ),
    );
  }
}
