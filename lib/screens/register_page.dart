import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/user_session.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedGender = "Nam";
  String selectedRole = "Người dùng";
  DateTime? birthDate;

  final List<String> genders = ["Nam", "Nữ"];

  Future<void> _pickBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => birthDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Họ tên"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Số điện thoại"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Mật khẩu"),
            ),

            const SizedBox(height: 15),

            /// GIỚI TÍNH
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(labelText: "Giới tính"),
              items: genders
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedGender = value!);
              },
            ),

            const SizedBox(height: 15),

            /// NGÀY SINH
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Ngày sinh"),
              subtitle: Text(
                birthDate == null
                    ? "Chưa chọn"
                    : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}",
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickBirthDate,
            ),

            const SizedBox(height: 15),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      birthDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Vui lòng nhập đầy đủ thông tin"),
                      ),
                    );
                    return;
                  }

                  /// ✅ LƯU USER ĐÃ ĐĂNG KÝ
                  UserSession.registeredUser = User(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    role: selectedRole,
                    gender: selectedGender,
                    birthDate: birthDate!,
                  );

                  Navigator.pop(context);
                },
                child: const Text("Đăng ký"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
