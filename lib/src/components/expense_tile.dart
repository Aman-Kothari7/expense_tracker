import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final String category;
  final DateTime dateTime;

  const ExpenseTile(
      {super.key,
      required this.name,
      required this.amount,
      required this.category,
      required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //category to be shown as icon
      leading: Text(category),
      title: Text(name),
      subtitle: Text('${dateTime.day}/${dateTime.month}/${dateTime.year}'),
      trailing: Text('₹$amount'),
    );
  }
}
