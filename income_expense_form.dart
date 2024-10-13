import 'package:flutter/material.dart';

class IncomeExpenseForm extends StatefulWidget {
  final Function(double, String, String) onAddIncome;
  final Function(double, String, String) onAddExpense;

  const IncomeExpenseForm({
    Key? key,
    required this.onAddIncome,
    required this.onAddExpense,
  }) : super(key: key);

  @override
  _IncomeExpenseFormState createState() => _IncomeExpenseFormState();
}

class _IncomeExpenseFormState extends State<IncomeExpenseForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  String _selectedCategory = 'เงินสด'; // Default category
  bool isIncome = true; // Default to income form

  // Categories for income
  final List<String> _incomeCategories = [
    'เงินสด',
    'เงินออม',
    'ดอกเบี้ย',
    'โบนัส',
    'หุ้น',
    'เงินเดือน',
    'อื่นๆ'
  ];

  // Categories for expense
  final List<String> _expenseCategories = [
    'อาหาร',
    'เครื่องดื่ม',
    'ผลไม้',
    'ของหวาน',
    'ก๋วยเตี๋ยว',
    'ผักใบเขียว',
    'รองเท้า',
    'เสื้อผ้า',
    'รถยนต์',
    'ฟัน',
    'การแพทย์',
    'เกม',
    'กีฬา',
    'อื่นๆ'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row with two buttons for selecting income or expense
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isIncome ? Color.fromARGB(255, 76, 245, 38) : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isIncome = true;
                  _selectedCategory =
                      _incomeCategories[0]; // Set default income category
                });
              },
              child: const Text('Income'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: !isIncome ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isIncome = false;
                  _selectedCategory =
                      _expenseCategories[0]; // Set default expense category
                });
              },
              child: const Text('Expense'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        TextField(
          controller: _amountController,
          decoration: InputDecoration(labelText: 'Amount'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _labelController,
          decoration: InputDecoration(labelText: 'Label'),
        ),
        DropdownButton<String>(
          value: _selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
          items: (isIncome ? _incomeCategories : _expenseCategories)
              .map<DropdownMenuItem<String>>((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () {
            double amount = double.parse(_amountController.text);
            String label = _labelController.text;
            if (isIncome) {
              widget.onAddIncome(amount, label, _selectedCategory);
            } else {
              widget.onAddExpense(amount, label, _selectedCategory);
            }
            // Clear input fields
            _amountController.clear();
            _labelController.clear();
          },
          child: Text(isIncome ? 'Add Income' : 'Add Expense'),
        ),
      ],
    );
  }
}
