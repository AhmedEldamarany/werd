import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeekReport extends StatelessWidget {
  final LineChartData myData = LineChartData(
    maxX: 7,
    maxY: 10,
    minX: 1,
    minY: 0,
  );

  @override
  Widget build(BuildContext context) {
    return LineChart(myData);
  }
}
