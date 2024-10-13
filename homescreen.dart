import 'package:flutter/material.dart';
import 'package:flutter_application_2/home/Savings.dart';
import 'income_expense_form.dart'; // สำหรับหน้าจอเพิ่มรายรับ/รายจ่าย

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Record',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  double income = 0;
  double expense = 0;

  // รายการบันทึก
  final List<Record> records = [];

  // ฟังก์ชันเพื่อเพิ่มรายรับ
  void addIncome(double amount, String label, String category) {
    setState(() {
      income += amount;
      records.add(Record(
          amount: amount,
          label: '$label - หมวดหมู่: $category', // Add category to the label
          type: 'income',
          date: DateTime.now().toString())); // ใช้เวลาปัจจุบันในการบันทึก
    });
  }

  // ฟังก์ชันเพื่อเพิ่มรายจ่าย
  void addExpense(double amount, String label, String category) {
    setState(() {
      expense += amount;
      records.add(Record(
          amount: -amount,
          label: '$label - หมวดหมู่: $category', // Add category to the label
          type: 'expense',
          date: DateTime.now().toString())); // ใช้เวลาปัจจุบันในการบันทึก
    });
  }

  // คำนวณยอดเงินคงเหลือ
  double get balance => income - expense;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // ในฟังก์ชัน _onItemTapped
    if (index == 2) {
      // Index สำหรับปุ่ม Savings
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SavingsScreen(
              income: income, expense: expense), // ส่งข้อมูลรายรับและรายจ่าย
        ),
      );
    }

    if (index == 1) {
      // Index สำหรับปุ่ม History
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryScreen(
              records: List.unmodifiable(
                  records)), // ส่งข้อมูล records ไปยังหน้าจอ History
        ),
      );
    } else if (index == 3) {
      // Index สำหรับปุ่ม Settings
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EDE2),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // แสดงยอดเงินคงเหลือ
                  Text(
                    'ยอดเงินคงเหลือ: ฿${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.local_atm, 'เลดเจอร์', () {}),
                  _buildIconButton(Icons.calendar_today, 'เกิดซ้ำ', () {}),
                  _buildIconButton(Icons.fastfood, 'หมวดหมู่', () {}),
                  _buildIconButton(Icons.star, 'บุ๊คมาร์ก', () {}),
                ],
              ),
            ),
            // หน้าจอการบันทึก
            Expanded(child: RecordScreen(records: records)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: Colors.white),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings, color: Colors.white),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 232, 222, 154),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: IncomeExpenseForm(
                  onAddIncome: addIncome,
                  onAddExpense: addExpense,
                ),
              );
            },
          );
        },
        backgroundColor: const Color(0xFFBFBFBF),
        elevation: 0,
        child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/icon_addDATA.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed) {
    return Expanded(
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 40, color: Colors.blue),
            onPressed: onPressed,
          ),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class Record {
  final double amount;
  final String label;
  final String type; // 'income' or 'expense'
  final String date;

  Record(
      {required this.amount,
      required this.label,
      required this.type,
      required this.date});
}

class RecordScreen extends StatelessWidget {
  final List<Record> records;

  const RecordScreen({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            leading: Icon(
              record.type == 'income' ? Icons.add : Icons.remove,
              color: record.type == 'income' ? Colors.green : Colors.red,
            ),
            title: Text(
              record.label,
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: RichText(
              text: TextSpan(
                text: record.amount > 0
                    ? '+${record.amount.toStringAsFixed(2)} บาท'
                    : '${record.amount.toStringAsFixed(2)} บาท',
                style: TextStyle(
                  color: record.amount > 0 ? Colors.green : Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
            trailing: Text(
              record.date,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            color: const Color(0xFFFDFDFD),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: Image.asset('assets/happy_money_logo.png'),
                ),
                const SizedBox(height: 10),
                const Text('บัญชีชั่วคราว',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                _buildGridItem(Icons.assignment, 'รายงาน'),
                _buildGridItem(Icons.notifications, 'การแจ้งเตือน'),
                _buildGridItem(Icons.share, 'แชร์'),
                _buildGridItem(Icons.help, 'ช่วยเหลือ'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// History Screen
class HistoryScreen extends StatelessWidget {
  final List<Record> records;

  const HistoryScreen({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการทำรายการ'),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              leading: Icon(
                record.type == 'income' ? Icons.add : Icons.remove,
                color: record.type == 'income' ? Colors.green : Colors.red,
              ),
              title: Text(
                record.label,
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: RichText(
                text: TextSpan(
                  text: record.amount > 0
                      ? '+${record.amount.toStringAsFixed(2)} บาท'
                      : '${record.amount.toStringAsFixed(2)} บาท',
                  style: TextStyle(
                    color: record.amount > 0 ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
              trailing: Text(
                record.date,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
