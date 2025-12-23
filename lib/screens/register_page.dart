import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../utils/password_utils.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final phoneController = TextEditingController();
  String verificationId = "";

  String normalizePhone(String phone) {
    phone = phone.replaceAll(" ", "");
    if (phone.startsWith("+84")) return "0${phone.substring(3)}";
    if (phone.startsWith("84")) return "0${phone.substring(2)}";
    return phone;
  }

  Future<void> sendOTP() async {
    final phone = normalizePhone(phoneController.text);

    await fb.FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+84${phone.substring(1)}",
      codeSent: (id, _) {
        verificationId = id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RegisterOtpPage(
              phone: phone,
              verificationId: verificationId,
            ),
          ),
        );
      },
      verificationCompleted: (c) async {
        await fb.FirebaseAuth.instance.signInWithCredential(c);
      },
      verificationFailed: (e) {
        show(e.message ?? "Lỗi gửi OTP");
      },
      codeAutoRetrievalTimeout: (id) => verificationId = id,
    );
  }

  void show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      appBar: AppBar(
        title: const Text("Đăng ký"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Center(
              child: Text(
                "Đăng ký tài khoản",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            _input(phoneController, "Số điện thoại", Icons.phone),
            const SizedBox(height: 20),
            _primaryButton("Gửi OTP", sendOTP),
          ],
        ),
      ),
    );
  }
}

class RegisterOtpPage extends StatefulWidget {
  final String phone;
  final String verificationId;

  const RegisterOtpPage({
    super.key,
    required this.phone,
    required this.verificationId,
  });

  @override
  State<RegisterOtpPage> createState() => _RegisterOtpPageState();
}

class _RegisterOtpPageState extends State<RegisterOtpPage> {
  final otpController = TextEditingController();

  Future<void> verifyOTP() async {
    try {
      final credential = fb.PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text,
      );

      await fb.FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterInfoPage(phone: widget.phone),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("OTP không đúng")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      appBar: AppBar(
        title: const Text("Xác thực OTP"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _input(otpController, "Nhập OTP", Icons.sms),
            const SizedBox(height: 20),
            _primaryButton("Xác thực", verifyOTP),
          ],
        ),
      ),
    );
  }
}

class RegisterInfoPage extends StatefulWidget {
  final String phone;

  const RegisterInfoPage({super.key, required this.phone});

  @override
  State<RegisterInfoPage> createState() => _RegisterInfoPageState();
}

class _RegisterInfoPageState extends State<RegisterInfoPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  DateTime? birthDate;
  String gender = "Nam";
  final genders = ["Nam", "Nữ"];

  Future<void> saveUser() async {
    if (birthDate == null ||
        nameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      show("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    if (await UserService.isPhoneExists(widget.phone)) {
      show("Số điện thoại đã tồn tại");
      return;
    }

    final user = UserModel(
      name: nameController.text,
      email: emailController.text,
      phone: widget.phone,
      password: PasswordUtils.hash(passwordController.text),
      birthDate: birthDate!,
      gender: gender,
    );

    await UserService.createUser(user);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input(nameController, "Họ tên", Icons.person),
              _input(emailController, "Email", Icons.email),
              _input(passwordController, "Mật khẩu", Icons.lock, obscure: true),
              DropdownButtonFormField(
                value: gender,
                decoration: _decoration("Giới tính", Icons.wc),
                items: genders
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => gender = v!,
              ),
              const SizedBox(height: 15),
              ListTile(
                tileColor: Colors.white,
                leading: const Icon(Icons.cake),
                title: const Text("Ngày sinh"),
                subtitle: Text(
                  birthDate == null
                      ? "Chưa chọn"
                      : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}",
                ),
                onTap: pickBirthDate,
              ),
              const SizedBox(height: 30),
              _primaryButton("Hoàn tất đăng ký", saveUser),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => birthDate = picked);
  }
}

Widget _input(TextEditingController c, String hint, IconData icon,
    {bool obscure = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: TextField(
      controller: c,
      obscureText: obscure,
      decoration: _decoration(hint, icon),
    ),
  );
}

InputDecoration _decoration(String hint, IconData icon) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  );
}

Widget _primaryButton(String text, VoidCallback onTap) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    ),
  );
}
