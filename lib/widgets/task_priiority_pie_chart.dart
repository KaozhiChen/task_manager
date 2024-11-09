import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskPriorityPieChart extends StatelessWidget {
  const TaskPriorityPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = _getPriorityData();

    return PieChart(
      PieChartData(
        sections: data,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  List<PieChartSectionData> _getPriorityData() {
    // 从 Firebase 获取任务优先级数据并统计
    // 示例数据
    final high = 10;
    final middle = 20;
    final low = 30;
    final total = high + middle + low;

    return [
      PieChartSectionData(
        color: Colors.red,
        value: high.toDouble(),
        title: 'High (${(high / total * 100).toStringAsFixed(1)}%)',
      ),
      PieChartSectionData(
        color: Colors.yellow,
        value: middle.toDouble(),
        title: 'Middle (${(middle / total * 100).toStringAsFixed(1)}%)',
      ),
      PieChartSectionData(
        color: Colors.green,
        value: low.toDouble(),
        title: 'Low (${(low / total * 100).toStringAsFixed(1)}%)',
      ),
    ];
  }
}
