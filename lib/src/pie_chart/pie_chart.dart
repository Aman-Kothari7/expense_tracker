import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String category;
  final double amount;
  final String percentageLabel;

  ChartData(this.category, this.amount, double percentage)
      : percentageLabel = '${(percentage * 100).toStringAsFixed(2)}%';
}

class PieChart extends StatelessWidget {
  final List<ChartData> dataMap;
  final List<Color> colorPalette;

  const PieChart({Key? key, required this.dataMap, required this.colorPalette})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PieSeries<ChartData, String>> series = [
      PieSeries<ChartData, String>(
        dataSource: dataMap,
        xValueMapper: (ChartData data, _) => data.category,
        yValueMapper: (ChartData data, _) => data.amount,
        pointColorMapper: (ChartData data, _) =>
            colorPalette[dataMap.indexOf(data)],
        dataLabelMapper: (ChartData data, _) => data.percentageLabel,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
          useSeriesColor: true,
          textStyle: const TextStyle(fontSize: 12),
        ),
      ),
    ];

    return SfCircularChart(
      series: series,
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
}
