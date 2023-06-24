import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChartData {
  final String category;
  final double amount;
  final double percentage;

  PieChartData(this.category, this.amount, this.percentage);
}

class PieChart extends StatelessWidget {
  final List<PieChartData> dataMap;

  const PieChart({super.key, required this.dataMap});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PieChartData, String>> series = [
      charts.Series(
        id: 'Category Expenses',
        data: dataMap,
        domainFn: (PieChartData sales, _) => sales.category,
        measureFn: (PieChartData sales, _) => sales.amount,
        labelAccessorFn: (PieChartData data, _) =>
            '${data.category}: ${data.amount.toStringAsFixed(2)} (${(data.percentage * 100).toStringAsFixed(2)}%)',
      ),
    ];

    return charts.PieChart(
      series,
      behaviors: [
        charts.DatumLegend<String>(
          position: charts.BehaviorPosition.top,
          horizontalFirst: true,
          desiredMaxRows: 2,
          entryTextStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
