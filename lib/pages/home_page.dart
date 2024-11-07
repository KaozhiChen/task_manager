import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
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
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
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
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('tasks')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Filter tasks by selected date
                    var tasks = snapshot.data!.docs.where((task) {
                      DateTime taskDate = (task['date'] as Timestamp).toDate();
                      return taskDate.year == _selectedDate.year &&
                          taskDate.month == _selectedDate.month &&
                          taskDate.day == _selectedDate.day;
                    }).toList();

                    if (tasks.isEmpty) {
                      return const Center(
                        child: Text('No tasks for today.'),
                      );
                    }
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        var task = tasks[index];
                        return Card(
                          child: ListTile(
                            title: Text(task['name']),
                            subtitle: Text(
                                "Priority: ${task['priority']}, Time: ${task['startTime']} - ${task['endTime']}"),
                            trailing: Checkbox(
                                value: task['status'],
                                onChanged: (bool? value) {
                                  FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(task.id)
                                      .update({'status': value});
                                }),
                          ),
                        );
                      },
                    );
                  }))
        ],
      ),
    );
  }
}
