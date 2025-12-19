import 'package:flutter/material.dart';
import '../models/user_session.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late String selectedRole;
  late DateTime selectedBirthDate;
  late String selectedGender;

  final List<String> genders = ["Nam", "Nữ"];

  @override
  void initState() {
    final user = UserSession.currentUser!;
    nameController = TextEditingController(text: user.name);
    phoneController = TextEditingController(text: user.phone);
    selectedRole = user.role;
    selectedBirthDate = user.birthDate;
    selectedGender = user.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa thông tin")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Họ tên
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Họ tên"),
              ),

              const SizedBox(height: 15),

              // Số điện thoại
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Số điện thoại"),
              ),

              const SizedBox(height: 15),

              // Ngày sinh
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cake),
                title: const Text("Ngày sinh"),
                subtitle: Text(
                  "${selectedBirthDate.day}/${selectedBirthDate.month}/${selectedBirthDate.year}",
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedBirthDate,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedBirthDate = pickedDate;
                    });
                  }
                },
              ),

              const SizedBox(height: 15),

              // Giới tính
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  labelText: "Giới tính",
                  border: OutlineInputBorder(),
                ),
                items: genders
                    .map(
                      (gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),

              const SizedBox(height: 30),

              // Lưu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    UserSession.currentUser!
                      ..name = nameController.text
                      ..phone = phoneController.text
                      ..role = selectedRole
                      ..birthDate = selectedBirthDate
                      ..gender = selectedGender;

                    Navigator.pop(context);
                  },
                  child: const Text("Lưu thay đổi"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
