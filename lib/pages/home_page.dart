import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_manager/task_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      body: Column(
        children: [
          // table calendar
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week'
            },
          ),
          const SizedBox(
            height: 16,
          ),

          // task list
          Expanded(child:
              Consumer<TaskManager>(builder: (context, taskManager, child) {
            // get tasks according to seleted date
            var tasks = taskManager.tasks.where((task) {
              var taskDate = task['date'];
              DateTime date;
              if (taskDate is Timestamp) {
                date = taskDate.toDate();
              } else if (taskDate is DateTime) {
                date = taskDate;
              } else {
                return false;
              }
              return date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;
            }).toList();

            if (tasks.isEmpty) {
              return const Center(child: Text("No tasks for selected date."));
            }

            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  var task = tasks[index];
                  return Card(
                    key: ValueKey(task['id']),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      title: Text(task['name']),
                      subtitle: Text(
                          "Priority: ${task['priority']}, Time: ${task['startTime']} - ${task['endTime']}"),
                      trailing: Checkbox(
                        value: task['status'],
                        onChanged: (bool? value) {
                          Provider.of<TaskManager>(context, listen: false)
                              .updateTaskStatus(task['id'], value!);
                        },
                      ),
                    ),
                  );
                });
          }))
        ],
      ),
    );
  }
}
