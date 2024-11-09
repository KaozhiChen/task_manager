import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/theme/colors.dart';

class AddTask extends StatefulWidget {
  final DateTime selectedDate;
  final String? taskId;
  const AddTask({super.key, required this.selectedDate, this.taskId});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _taskNameController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _priority = 'High';

  Future<void> _saveTask() async {
    String taskName = _taskNameController.text.trim();
    if (taskName.isNotEmpty && _startTime != null && _endTime != null) {
      DateTime taskDate = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
      );

      String formattedStartTime = _startTime!.format(context);
      String formattedEndTime = _endTime!.format(context);
      String priority = _priority;

      if (widget.taskId == null) {
        // add model
        await FirebaseFirestore.instance.collection('tasks').add({
          'name': taskName,
          'status': false,
          'date': Timestamp.fromDate(taskDate),
          'startTime': formattedStartTime,
          'endTime': formattedEndTime,
          'priority': priority,
        });
      } else {
        // update model
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .update({
          'name': taskName,
          'startTime': formattedStartTime,
          'endTime': formattedEndTime,
          'priority': priority,
        });
      }

      _taskNameController.clear();
      _startTime = null;
      _endTime = null;

      Navigator.of(context).pop();
    } else {
      _showIncompleteFieldsDialog();
    }
  }

  // dialog
  void _showIncompleteFieldsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Incomplete Fields"),
          content: const Text("Please complete all fields before saving."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.taskId == null ? "Add Task" : "Edit Task",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            onPressed: _saveTask,
            child: Text(widget.taskId == null ? "Add Task" : "Save Changes"),
          ),
        ],
      ),
    );
  }
}
