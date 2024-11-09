import 'package:flutter/material.dart';
import '../widgets/task_completion_chart.dart';
import '../widgets/task_priiority_pie_chart.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // chart 1
              Text(
                "Task Completion and Status",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: TaskCompletionChart(),
              ),
              Divider(),

              // chart 2
              Text(
                "Task Priority Distribution",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: TaskPriorityPieChart(),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
