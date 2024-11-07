import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/pages/add_task.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<DateTime> onDateSeleted;

  const HomePage({super.key, required this.onDateSeleted});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void _showEditTaskBottomSheet({String? taskId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: AddTask(
            selectedDate: _selectedDate,
            taskId: taskId,
          ),
        );
      },
    );
  }

  // delete function
  void _deleteTask(String taskId) {
    FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
  }

  // get priority colors
  Color _getPriortyColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Middle':
        return Colors.yellow;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      body: SafeArea(
        child: Column(
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
                // pass to MainScreen
                widget.onDateSeleted(_selectedDate);
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
                        DateTime taskDate =
                            (task['date'] as Timestamp).toDate();
                        return taskDate.year == _selectedDate.year &&
                            taskDate.month == _selectedDate.month &&
                            taskDate.day == _selectedDate.day;
                      }).toList();

                      if (tasks.isEmpty) {
                        return const Center(
                          child: Text('No tasks for today.'),
                        );
                      }
                      return SafeArea(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 40),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            var task = tasks[index];
                            return Column(
                              children: [
                                Card(
                                  child: ListTile(
                                    leading: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 50,
                                          color: _getPriortyColor(
                                              task['priority']),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Checkbox(
                                            value: task['status'],
                                            onChanged: (bool? value) {
                                              FirebaseFirestore.instance
                                                  .collection('tasks')
                                                  .doc(task.id)
                                                  .update({'status': value});
                                            }),
                                      ],
                                    ),
                                    title: Text(task['name']),
                                    subtitle: Text(
                                        "${task['startTime']} - ${task['endTime']}"),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                          ),
                                          onPressed: () {
                                            _showEditTaskBottomSheet(
                                                taskId: task.id);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                          ),
                                          onPressed: () {
                                            _deleteTask(task.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
