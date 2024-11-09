import 'package:flutter/material.dart';
import '../widgets/task_completion_chart.dart';
import '../widgets/task_priiority_pie_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // chart 1
              const Text(
                "Tasks Completion in the past week",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                height: 300,
                child: TaskCompletionChart(),
              ),
              const SizedBox(height: 16),
              Divider(
                color: Colors.grey[200],
              ),
              const SizedBox(height: 16),
              // chart 2
              const Text(
                "Task Priority Distribution(All)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                height: 300,
                child: TaskPriorityPieChart(),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
