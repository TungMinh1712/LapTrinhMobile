import 'package:flutter/material.dart';
import '../models/user_model.dart';
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
        centerTitle: true,
        automaticallyImplyLeading: false,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar + tên
            Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),

            const SizedBox(height: 25),

            // Thông tin cá nhân
            _infoItem(Icons.phone, "Số điện thoại", user.phone),
            _infoItem(
              Icons.cake,
              "Ngày sinh",
              "${user.birthDate.day}/${user.birthDate.month}/${user.birthDate.year}",
            ),
            _infoItem(Icons.wc, "Giới tính", user.gender),
            _infoItem(Icons.email, "Email", user.email),

            const Spacer(),

            // Đăng xuất
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Đăng xuất",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
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
              ),
            )
          ],
        ),
      ),
    );
  }

  // Item info giống style form
  Widget _infoItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController lastNameController;
  late TextEditingController firstNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  late DateTime selectedBirthDate;
  late String selectedGender;

  final List<String> genders = ["Nam", "Nữ"];

  @override
  void initState() {
    super.initState();
    final user = UserSession.currentUser!;
    final nameParts = user.name.split(" ");

    lastNameController = TextEditingController(
      text: nameParts.sublist(0, nameParts.length - 1).join(" "),
    );
    firstNameController = TextEditingController(text: nameParts.last);

    phoneController = TextEditingController(text: user.phone);
    emailController = TextEditingController(text: user.email);

    selectedBirthDate = user.birthDate;
    selectedGender = user.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin cá nhân")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.person, size: 35),
                ),
              ),
              const SizedBox(height: 20),
              _label("Số điện thoại"),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 15),
              _label("Họ và tên lót"),
              TextField(
                controller: lastNameController,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 15),
              _label("Tên"),
              TextField(
                controller: firstNameController,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Ngày sinh"),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedBirthDate,
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedBirthDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${selectedBirthDate.day}/${selectedBirthDate.month}/${selectedBirthDate.year}",
                                ),
                                const Spacer(),
                                const Icon(Icons.calendar_today, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Giới tính"),
                        DropdownButtonFormField<String>(
                          value: selectedGender,
                          items: genders
                              .map(
                                (g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedGender = v!;
                            });
                          },
                          decoration: _inputDecoration(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _label("Email"),
              TextField(
                controller: emailController,
                readOnly: true,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    UserSession.currentUser!
                      ..name =
                          "${lastNameController.text} ${firstNameController.text}"
                      ..phone = phoneController.text
                      ..birthDate = selectedBirthDate
                      ..gender = selectedGender;

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cập nhật thông tin",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
