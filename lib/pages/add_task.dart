import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/theme/colors.dart';

import '../task_manager.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _taskNameController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _priority = 'High';

  Future<void> _addTask() async {
    String taskName = _taskNameController.text.trim();
    if (taskName.isNotEmpty && _startTime != null && _endTime != null) {
      Provider.of<TaskManager>(context, listen: false).addTask(
        taskName: taskName,
        startTime: _startTime!,
        endTime: _endTime!,
        priority: _priority,
        context: context,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Task",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: _taskNameController,
            decoration: InputDecoration(
              labelText: "Task Name",
              hintText: "Enter task name here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: primary),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 16,
          ),

          // start time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Start Time:"),
              TextButton(
                onPressed: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _startTime = picked;
                    });
                  }
                },
                child: Text(
                  _startTime != null
                      ? _startTime!.format(context)
                      : "Select Time",
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[200],
          ),

          // End Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("End Time:"),
              TextButton(
                onPressed: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _endTime = picked;
                    });
                  }
                },
                child: Text(
                  _endTime != null ? _endTime!.format(context) : "Select Time",
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[200],
          ),

          //priority
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Priority:"),
              DropdownButton<String>(
                value: _priority,
                items: <String>['High', 'Middle', 'Low'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // add button
          ElevatedButton(
            onPressed: _addTask,
            child: const Text("Add Task"),
          ),
        ],
      ),
    );
  }
}
