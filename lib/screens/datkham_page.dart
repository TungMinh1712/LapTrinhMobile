import 'package:flutter/material.dart';

// --- MÀN HÌNH CHÍNH: ĐẶT KHÁM ---
class DatKhamPage extends StatefulWidget {
  const DatKhamPage({super.key});

  @override
  State<DatKhamPage> createState() => _DatKhamPageState();
}

class _DatKhamPageState extends State<DatKhamPage> {
  // Dữ liệu giả lập
  final List<String> doctors = [
    "BS. Nguyễn Văn A - Nội khoa",
    "BS. Trần Thị B - Nhi khoa",
    "BS. Lê Văn C - Tim mạch",
    "BS. Phạm Thị D - Da liễu"
  ];

  final List<String> timeSlots = [
    "08:00",
    "08:30",
    "09:00",
    "09:30",
    "10:00",
    "10:30",
    "13:30",
    "14:00",
    "14:30",
    "15:00",
    "15:30",
    "16:00"
  ];

  // --- State quản lý dữ liệu ---
  int _selectedDoctorIndex = 0;
  int _selectedTimeIndex = -1;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  // Quản lý hồ sơ bệnh nhân
  // Biến này lưu danh sách các hồ sơ đã tạo
  List<Map<String, String>> _profiles = [];
  // Biến này lưu hồ sơ đang được chọn để đặt khám
  Map<String, String>? _selectedProfile;

  // Hàm mở màn hình tạo hồ sơ và nhận lại dữ liệu
  void _openCreateProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        _profiles.add(result); // Thêm vào danh sách
        _selectedProfile = result; // Tự động chọn hồ sơ vừa tạo
      });
    }
  }

  // Hàm chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.blue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Hàm xử lý đặt khám
  void _confirmBooking() {
    // 1. Kiểm tra đã chọn hồ sơ chưa
    if (_selectedProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Vui lòng tạo hoặc chọn hồ sơ người bệnh!")),
      );
      return;
    }

    // 2. Kiểm tra giờ khám
    if (_selectedTimeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn giờ khám!")),
      );
      return;
    }

    // 3. Hiển thị xác nhận
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận đặt khám"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              _buildInfoRow("Bệnh nhân:", _selectedProfile!['fullName'] ?? ""),
              _buildInfoRow("Bác sĩ:", doctors[_selectedDoctorIndex]),
              _buildInfoRow("Ngày:",
                  "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
              _buildInfoRow("Giờ:", timeSlots[_selectedTimeIndex]),
              _buildInfoRow(
                  "Triệu chứng:",
                  _noteController.text.isEmpty
                      ? "Không có"
                      : _noteController.text),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đặt khám thành công!")),
              );
            },
            child: const Text("Đồng ý"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
                text: "$label ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đặt lịch khám bệnh"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PHẦN 1: THÔNG TIN NGƯỜI BỆNH (QUAN TRỌNG) ---
            const Text("Hồ sơ người bệnh",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            if (_selectedProfile == null)
              // Trường hợp chưa có hồ sơ -> Hiện nút tạo
              InkWell(
                onTap: _openCreateProfile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.blue, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.add_circle_outline,
                          color: Colors.blue, size: 30),
                      SizedBox(height: 8),
                      Text("Chưa có hồ sơ. Nhấn để tạo mới",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )
            else
              // Trường hợp ĐÃ có hồ sơ -> Hiện thông tin
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1), blurRadius: 5)
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedProfile!['fullName']!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "SĐT: ${_selectedProfile!['phone']}",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.change_circle_outlined,
                          color: Colors.blue),
                      onPressed: () {
                        // Logic chọn lại hồ sơ khác hoặc tạo mới
                        _openCreateProfile();
                      },
                    )
                  ],
                ),
              ),

            const SizedBox(height: 25),

            // --- PHẦN 2: CHỌN BÁC SĨ ---
            const Text("Chọn Bác sĩ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: doctors.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final isSelected = _selectedDoctorIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDoctorIndex = index),
                    child: Container(
                      width: 110,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                            color:
                                isSelected ? Colors.blue : Colors.grey.shade300,
                            width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.medical_services,
                              size: 28, color: Colors.blue),
                          const SizedBox(height: 8),
                          Text(
                            doctors[index],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // --- PHẦN 3: CHỌN NGÀY ---
            const Text("Ngày khám",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Ngày: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                        style: const TextStyle(fontSize: 16)),
                    const Icon(Icons.calendar_month, color: Colors.blue),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // --- PHẦN 4: CHỌN GIỜ ---
            const Text("Giờ khám",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(timeSlots.length, (index) {
                final isSelected = _selectedTimeIndex == index;
                return ChoiceChip(
                  label: Text(timeSlots[index]),
                  selected: isSelected,
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black),
                  onSelected: (selected) => setState(
                      () => _selectedTimeIndex = selected ? index : -1),
                );
              }),
            ),

            const SizedBox(height: 25),

            // --- PHẦN 5: TRIỆU CHỨNG ---
            const Text("Triệu chứng / Ghi chú",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Nhập lý do khám...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _confirmBooking,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("XÁC NHẬN ĐẶT KHÁM",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ),
    );
  }
}

// --- MÀN HÌNH PHỤ: FORM TẠO HỒ SƠ ---
// (Bạn có thể tách ra file riêng hoặc để chung ở đây đều được)
class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Trả dữ liệu về màn hình trước
      Navigator.pop(context, {
        'fullName': _nameController.text,
        'phone': _phoneController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm hồ sơ mới")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Họ và tên bệnh nhân",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (val) => val!.isEmpty ? "Vui lòng nhập tên" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Số điện thoại liên hệ",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (val) => val!.isEmpty ? "Vui lòng nhập SĐT" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  child: const Text("LƯU HỒ SƠ"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
