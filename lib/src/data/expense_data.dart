import 'package:expense_tracker/src/date_time_calc/date_time_helper.dart';
import 'package:expense_tracker/src/models/expense_item.dart';
import 'package:flutter/material.dart';

// enum itemCategory {}

// class transaction_details {
//   final itemCategory I
// }

class expenseData extends ChangeNotifier {
  // list of all expenses
  List<expenseItem> overallExpenseList = [];

  //get expense list
  List<expenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // add expense
  void addExpense(expenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
  }

  // delete expense
  void deleteExpense(expenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
  }

  //get weekday from dateTime object
  String getDAYNAME(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  //get the date tfor the start of the week (sunday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDAYNAME(today.subtract(Duration(days: i))) == 'Sunday') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  //convert overall list of expenses into a daily expense summary

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      //date
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}
