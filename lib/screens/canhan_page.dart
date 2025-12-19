import 'package:flutter/material.dart';
import '../models/user_session.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';

class CaNhanPage extends StatelessWidget {
  const CaNhanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserSession.currentUser;

    if (user == null) {
      return const Center(child: Text("Chưa đăng nhập"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cá nhân"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfilePage(),
                ),
              ).then((_) => (context as Element).markNeedsBuild());
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),

            const SizedBox(height: 10),

            Text(
              user.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              user.email,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            _infoTile(Icons.phone, "Số điện thoại", user.phone),

            _infoTile(Icons.cake, "Ngày sinh",
                "${user.birthDate.day}/${user.birthDate.month}/${user.birthDate.year}"),

            _infoTile(Icons.wc, "Giới tính", user.gender),

            _infoTile(Icons.badge, "Vai trò", user.role),

            _infoTile(Icons.email, "Email", user.email),

            const Spacer(),

            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Đăng xuất"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                UserSession.currentUser = null;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
