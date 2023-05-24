import 'package:hive/hive.dart';

import '../models/expense_item.dart';

class Hivedatabase {
  //reference our box
  final _myBox = Hive.box("expense_database");
  //write data
  void saveData(List<expenseItem> allExpense) {
    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
        expense.category,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  //read data
  List<expenseItem> readData() {
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<expenseItem> allExpenses = [];
    for (int i = 0; i < savedExpenses.length; i++) {
      //collecting individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];
      String category = savedExpenses[i][3];

      expenseItem expense = expenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
        category: category,
      );

      allExpenses.add(expense);
    }

    return allExpenses;
  }
}
