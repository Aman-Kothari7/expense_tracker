import 'dart:async';

import 'package:expense_tracker/src/components/expense_tile.dart';
import 'package:expense_tracker/src/data/expense_data.dart';
import 'package:expense_tracker/src/models/expense_item.dart';
import 'package:expense_tracker/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

List<String> expenseCategories = <String>[
  'Grocery',
  'Transportation',
  'Bills',
];

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  //function to show dialog box to add new expenses

  final newExpenseName = TextEditingController();
  final newExpenseAmount = TextEditingController();
  final newCategoryName = TextEditingController();

  void addExpense() {
    String dropdownValue = expenseCategories.first;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Add exp'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newExpenseName,
                decoration: InputDecoration(
                  hintText: "Expense Name",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
              TextField(
                controller: newExpenseAmount,
                decoration: InputDecoration(
                  hintText: "Expense Amount",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                ],
              ),
            ],
          ),
          actions: [
            //Error in showing selected category
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                newCategoryName.text = value!;
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value;
                });
              },
              items: expenseCategories
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            MaterialButton(
              onPressed: save,
              child: Text('Save'),
            ),
            MaterialButton(
              onPressed: cancel,
              child: Text('Cancel'),
            ),
          ],
        );
      }),
    );
  }

  void save() {
    expenseItem newExpense = expenseItem(
      name: newExpenseName.text,
      amount: newExpenseAmount.text,
      category: newCategoryName.text,
      dateTime: DateTime.now(),
    );
    Provider.of<expenseData>(context, listen: false).addExpense(newExpense);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseName.clear();
    newExpenseAmount.clear();
    newCategoryName.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<expenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: addExpense,
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: [
              //weekly summary bar graph

              //List of expenses
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) => ExpenseTile(
                      name: value.getAllExpenseList()[index].name,
                      amount: value.getAllExpenseList()[index].amount,
                      //need to work on getting a default value if user doesnt select from drop down
                      category: value.getAllExpenseList()[index].category,
                      dateTime: value.getAllExpenseList()[index].dateTime)),
            ],
          )),
    );
  }
}
