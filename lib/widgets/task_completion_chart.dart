import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/colors.dart';

class TaskCompletionChart extends StatefulWidget {
  const TaskCompletionChart({super.key});

  @override
  _TaskCompletionChartState createState() => _TaskCompletionChartState();
}

class _TaskCompletionChartState extends State<TaskCompletionChart> {
  Map<DateTime, Map<String, int>> weeklyData = {};

  @override
  void initState() {
    super.initState();
    _initializeWeeklyData();
  }

  void _initializeWeeklyData() {
    final today = DateTime.now();
    for (var i = 0; i < 7; i++) {
      final date = DateTime(today.year, today.month, today.day - i);
      weeklyData[date] = {'completed': 0, 'incompleted': 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                  DateTime.now().subtract(const Duration(days: 6))))
          .where('date',
              isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        _initializeWeeklyData();

        for (var doc in snapshot.data!.docs) {
          final taskDate = (doc['date'] as Timestamp).toDate();
          final isCompleted = doc['status'] as bool;
          final dateKey = DateTime(taskDate.year, taskDate.month, taskDate.day);

          if (weeklyData.containsKey(dateKey)) {
            if (isCompleted) {
              weeklyData[dateKey]!['completed'] =
                  (weeklyData[dateKey]!['completed']! + 1);
            } else {
              weeklyData[dateKey]!['incompleted'] =
                  (weeklyData[dateKey]!['incompleted']! + 1);
            }
          }
        }

        // sort data by date
        final sortedData = weeklyData.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        return Column(
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: sortedData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final completed = entry.value.value['completed'] ?? 0;
                    final incompleted = entry.value.value['incompleted'] ?? 0;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: completed.toDouble(),
                          color: primary,
                          width: 15,
                        ),
                        BarChartRodData(
                          toY: incompleted.toDouble(),
                          color: fourthColor,
                          width: 15,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < sortedData.length) {
                            final date = sortedData[value.toInt()].key;
                            return Text(DateFormat('MM/dd').format(date));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.square, color: primary, size: 14),
                  Text(' Completed'),
                  SizedBox(width: 16),
                  Icon(Icons.square, color: fourthColor, size: 14),
                  Text(' Incompleted'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
