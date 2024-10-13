import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text('เพิ่มเติม', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.yellow[100],
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child:
                      Image.asset('assets/IMG_756.png'), // ใส่โลโก้ของคุณตรงนี้
                ),
                const SizedBox(height: 10),
                const Text(
                  'บัญชีชั่วคราว',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildGridItem(Icons.flag, 'เป้าหมาย'),
                _buildGridItem(Icons.notifications, 'ตั้งเตือนรับ-จ่าย'),
                _buildGridItem(Icons.help, 'คำถามที่พบบ่อย'),
                _buildGridItem(Icons.info, 'เกี่ยวกับเรา'),
                _buildGridItem(Icons.settings, 'ตั้งค่าการใช้งาน'),
                _buildGridItem(Icons.login, 'เข้าสู่ระบบ'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Colors.yellow[700]),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
