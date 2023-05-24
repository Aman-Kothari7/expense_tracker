import 'package:expense_tracker/src/data/expense_data.dart';
import 'package:expense_tracker/src/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialize hive
  await Hive.initFlutter();

  //open hive box
  await Hive.openBox("expense_database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => expenseData(),
        builder: (context, child) => const MaterialApp(
              home: homepage(),
            ));
  }
}
