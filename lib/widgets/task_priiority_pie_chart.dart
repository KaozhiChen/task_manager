import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskPriorityPieChart extends StatefulWidget {
  const TaskPriorityPieChart({super.key});

  @override
  _TaskPriorityPieChartState createState() => _TaskPriorityPieChartState();
}

class _TaskPriorityPieChartState extends State<TaskPriorityPieChart> {
  int highPriorityCount = 0;
  int middlePriorityCount = 0;
  int lowPriorityCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchPriorityData();
  }

  Future<void> _fetchPriorityData() async {
    final snapshot = await FirebaseFirestore.instance.collection('tasks').get();

    int high = 0;
    int middle = 0;
    int low = 0;

    for (var doc in snapshot.docs) {
      final priority = doc['priority'] as String;
      if (priority == 'High') {
        high++;
      } else if (priority == 'Middle') {
        middle++;
      } else if (priority == 'Low') {
        low++;
      }
    }

    setState(() {
      highPriorityCount = high;
      middlePriorityCount = middle;
      lowPriorityCount = low;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = highPriorityCount + middlePriorityCount + lowPriorityCount;
    if (total == 0) {
      return const Center(child: Text("No data to display"));
    }

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: highPriorityCount.toDouble(),
                  color: Colors.red,
                  title:
                      '${((highPriorityCount / total) * 100).toStringAsFixed(1)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                PieChartSectionData(
                  value: middlePriorityCount.toDouble(),
                  color: Colors.yellow,
                  title:
                      '${((middlePriorityCount / total) * 100).toStringAsFixed(1)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                PieChartSectionData(
                  value: lowPriorityCount.toDouble(),
                  color: Colors.green,
                  title:
                      '${((lowPriorityCount / total) * 100).toStringAsFixed(1)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),

        // illustration
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.square, color: Colors.red, size: 14),
              Text(' High'),
              SizedBox(width: 16),
              Icon(Icons.square, color: Colors.yellow, size: 14),
              Text('Middle'),
              SizedBox(width: 16),
              Icon(Icons.square, color: Colors.green, size: 14),
              Text('Low'),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
