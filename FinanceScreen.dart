import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Finance App',
      home: FinanceScreen(),
    );
  }
}

class FinanceScreen extends StatefulWidget {
  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  double income = 0;
  double expense = 0;
  List<Record> records = []; // List to hold the financial records

  // Function to calculate the balance
  double get balance => income - expense;

  // Function to format the date
  String get currentDate => DateFormat('dd/MM/yyyy').format(DateTime.now());

  // Function to add income
  void addIncome(double amount, String label) {
    setState(() {
      income += amount;
      records.add(Record(label: label, amount: amount, type: 'income'));
    });
  }

  // Function to add expense
  void addExpense(double amount, String label) {
    setState(() {
      expense += amount;
      records.add(Record(label: label, amount: -amount, type: 'expense'));
    });
  }

  // Function to show input dialog for income or expense
  void showInputDialog(bool isIncome) {
    TextEditingController amountController = TextEditingController();
    TextEditingController labelController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isIncome ? 'เพิ่มรายรับ' : 'เพิ่มรายจ่าย'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelController,
                decoration: InputDecoration(
                  labelText: 'กรอกชื่อรายการ',
                ),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'กรอกจำนวนเงิน',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text('เพิ่ม'),
              onPressed: () {
                double amount = double.tryParse(amountController.text) ?? 0;
                String label = labelController.text;
                if (amount > 0 && label.isNotEmpty) {
                  if (isIncome) {
                    addIncome(amount, label);
                  } else {
                    addExpense(amount, label);
                  }
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การเงิน'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'วันที่: $currentDate',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  'ยอดคงเหลือ: ${balance.toStringAsFixed(2)} บาท',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'รายรับ: ${income.toStringAsFixed(2)} บาท',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'รายจ่าย: ${expense.toStringAsFixed(2)} บาท',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return ListTile(
                  leading:
                      Icon(record.type == 'income' ? Icons.add : Icons.remove),
                  title: Text(record.label),
                  subtitle: Text(record.amount > 0
                      ? '+${record.amount.toStringAsFixed(2)} บาท'
                      : '${record.amount.toStringAsFixed(2)} บาท'),
                  trailing: Text(record.date),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('เพิ่มรายรับ'),
                    onTap: () {
                      Navigator.pop(context);
                      showInputDialog(true);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.remove),
                    title: Text('เพิ่มรายจ่าย'),
                    onTap: () {
                      Navigator.pop(context);
                      showInputDialog(false);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Record {
  final String label;
  final double amount;
  final String type;
  final String date;

  Record({required this.label, required this.amount, required this.type})
      : date = DateFormat('HH:mm').format(DateTime.now());
}
