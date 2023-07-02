import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expense_tracker/src/components/expense_summary.dart';
import 'package:expense_tracker/src/components/expense_tile.dart';
import 'package:expense_tracker/src/data/expense_data.dart';
import 'package:expense_tracker/src/models/expense_item.dart';
import 'package:expense_tracker/src/pie_chart/pie_chart.dart';
import 'package:expense_tracker/src/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


List<String> expenseCategories = <String>[
  'Housing',
  'Transportation',
  'Food',
  'Entertainment',
  'Investements',
];

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  //function to show dialog box to add new expenses

  DateTime selectedDate = DateTime.now();
  List<expenseItem> filteredExpenses = [];

  final newExpenseName = TextEditingController();
  final newExpenseAmount = TextEditingController();
  final newCategoryName = TextEditingController();

  DateTime selectedMonthYear = DateTime.now();

  @override
  void initState() {
    super.initState();

    Provider.of<expenseData>(context, listen: false).prepareData();
  }

  void addExpense() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

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

  void deleteExpense(expenseItem expense) {
    Provider.of<expenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    //need to work on getting a default value if user doesnt select from drop down - FIXED
    
    if (newCategoryName.text == '') {
      newCategoryName.text = 'Grocery';
    }
    //only saving if text fields are not empty
    if (newExpenseName.text.isNotEmpty &&
        newExpenseAmount.text.isNotEmpty &&
        newCategoryName.text.isNotEmpty) {
       expenseItem newExpense = expenseItem(
          name: newExpenseName.text,
          amount: newExpenseAmount.text,
          category: newCategoryName.text,
          dateTime: selectedDate, // Pass the selected date to the expense
        );
      Provider.of<expenseData>(context, listen: false).addExpense(newExpense);
    }

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
    return Consumer<expenseData>(builder: (context, value, child) {
      //Filter expenses based on the selected date
      filteredExpenses = value
          .getAllExpenseList()
          .where((expense) =>
              expense.dateTime.year == selectedDate.year &&
              expense.dateTime.month == selectedDate.month &&
              expense.dateTime.day == selectedDate.day)
          .toList();

          // List<expenseItem> filteredExpenses = value
          // .getAllExpenseList()
          // .where((expense) =>
          //     expense.dateTime.year == selectedMonthYear.year &&
          //     expense.dateTime.month == selectedMonthYear.month)
          // .toList();

      return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: addExpense,
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: [
              CarouselSlider(
                items: [
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),

                      ///border: Border.all()
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child:
                        //weekly summary bar graph
                        ExpenseSummary(startOfWeek: value.startOfWeekDate()),
                  ),
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),

                      ///border: Border.all()
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Builder(
                          builder: (BuildContext context) {
                            // Calculate and display the pie chart for selectedMonthYear
                            Map<String, Map<String, double>>
                                monthlyCategorySum =
                                value.calculateMonthlyCategorySum();
                            String monthYear =
                                "${selectedMonthYear.month}/${selectedMonthYear.year}";

                            if (monthlyCategorySum.containsKey(monthYear)) {
                              Map<String, double> categoryData =
                                  monthlyCategorySum[monthYear]!.map(
                                (category, amount) =>
                                    MapEntry(category, amount.toDouble()),
                              );
                              double totalAmount =
                                  categoryData.values.reduce((a, b) => a + b);

                              List<ChartData> pieChartData =
                                  categoryData.entries.map((entry) {
                                double percentage = entry.value / totalAmount;

                                return ChartData(
                                    entry.key, entry.value, percentage);
                              }).toList();


                              // Calculate and display the pie chart for selectedMonthYear
                          // String monthYear =
                          //     "${selectedMonthYear.month}/${selectedMonthYear.year}";

                          // if (filteredExpenses.isNotEmpty) {
                          //   Map<String, double> categoryData =
                          //       value.calculateCategorySum(filteredExpenses);
                          //   double totalAmount =
                          //       categoryData.values.reduce((a, b) => a + b);

                          //   List<ChartData> pieChartData =
                          //       categoryData.entries.map((entry) {
                          //     double percentage = entry.value / totalAmount;

                          //     return ChartData(
                          //         entry.key, entry.value, percentage);
                          //   }).toList();

                              return SizedBox(
                                width: 300,
                                height: 300,
                                child: PieChart(
                                  dataMap: pieChartData,
                                  colorPalette: [
                                    Colors.blue,
                                    Colors.blueGrey,
                                    Colors.lightBlue,
                                    Colors.lightBlueAccent,
                                    Colors.black,
                                    Colors.yellow,
                                    Colors.orange,
                                    Colors.purple,
                                    // Add more colors for each category
                                  ],
                                ),
                              );
                            } else {
                              return const Text(
                                'No expenses found for the selected month and year.',
                                style: TextStyle(fontSize: 16),
                              );
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            DropdownButton<int>(
                              value: selectedMonthYear.month,
                              onChanged: (int? month) {
                                setState(() {
                                  selectedMonthYear = DateTime(
                                    selectedMonthYear.year,
                                    month!,
                                    selectedMonthYear.day,
                                  );
                                });
                              },
                              
                              items: List.generate(12, (index) {
                                return DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text(
                                    DateFormat('MMMM').format(DateTime(
                                      selectedMonthYear.year,
                                      index + 1,
                                      1,
                                    )),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<int>(
                              value: selectedMonthYear.year,
                              onChanged: (int? year) {
                                setState(() {
                                  selectedMonthYear = DateTime(
                                    year!,
                                    selectedMonthYear.month,
                                    selectedMonthYear.day,
                                  );
                                });
                              },
                              items: List.generate(5, (index) {
                                return DropdownMenuItem<int>(
                                  value: DateTime.now().year - index,
                                  child: Text(
                                      (DateTime.now().year - index).toString()),
                                );
                              }),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: 400.0,
                  //enlargeCenterPage: true,
                  //autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  //autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           DateFormat('MMMM').format(selectedDate),
              //           style: TextStyle(fontSize: 16),
              //         ),
              //         Text(
              //           DateFormat('d').format(selectedDate),
              //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                              icon: Icon(Icons.arrow_left),
                              onPressed: () {
                              setState(() {
                                selectedDate = selectedDate.subtract(Duration(days: 1));
                              });
                            },
                          ),
                  Column(
                    children: [
                      Text(
                        DateFormat('MMMM').format(selectedDate),
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        DateFormat('d').format(selectedDate),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => selectDate(context),
                ),
                 
                IconButton(
                              icon: Icon(Icons.arrow_right),
      color: (selectedDate.year == DateTime.now().year &&
              selectedDate.month == DateTime.now().month &&
              selectedDate.day == DateTime.now().day)
          ? Colors.grey.shade300
          : Colors.black,
      onPressed: (selectedDate.year == DateTime.now().year &&
              selectedDate.month == DateTime.now().month &&
              selectedDate.day == DateTime.now().day)
          ? null
          : () {
              setState(() {
                selectedDate = selectedDate.add(Duration(days: 1));
              });
            },
                            ),
              
                ]
              ),
              
              //List of expenses
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredExpenses.length,
                itemBuilder: (context, index) => ExpenseTile(
                  name: filteredExpenses[index].name,
                  amount: filteredExpenses[index].amount,
                  category: filteredExpenses[index].category,
                  dateTime: filteredExpenses[index].dateTime,
                  deleteTapped: (p0) => deleteExpense(filteredExpenses[index]),
                ),
              ),
            ],
          ));
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
