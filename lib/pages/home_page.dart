import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/pages/add_task.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<DateTime> onDateSeleted;

  const HomePage({super.key, required this.onDateSeleted});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _sortOption = 'Priority';
  String _filterOption = 'All';

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

  // get priority numbers
  int _getPriorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 1;
      case 'Middle':
        return 2;
      case 'Low':
        return 3;
      default:
        return 4;
    }
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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

              // sorting and filtering
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Sort By:'),
                        const SizedBox(
                          width: 6,
                        ),
                        Container(
                          height: 32,
                          padding: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _sortOption,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.grey),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _sortOption = newValue!;
                                });
                              },
                              items: <String>[
                                'Priority',
                                'Start Time',
                                'Status'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Filter:'),
                        const SizedBox(
                          width: 6,
                        ),
                        Container(
                          height: 32,
                          padding: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _filterOption,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.grey),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _filterOption = newValue!;
                                });
                              },
                              items: <String>[
                                'All',
                                'High Priority',
                                'Middle Priority',
                                'Low Priority',
                                'Completed Tasks',
                                'Incompleted Tasks',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
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
                          bool matchesDate =
                              taskDate.year == _selectedDate.year &&
                                  taskDate.month == _selectedDate.month &&
                                  taskDate.day == _selectedDate.day;

                          // filtering tasks
                          bool matchesFilter = true;
                          switch (_filterOption) {
                            case 'High Priority':
                              matchesFilter = task['priority'] == 'High';
                              break;
                            case 'Middle Priority':
                              matchesFilter = task['priority'] == 'Middle';
                              break;
                            case 'Low Priority':
                              matchesFilter = task['priority'] == 'Low';
                              break;
                            case 'Completed Tasks':
                              matchesFilter = task['status'] == true;
                              break;
                            case 'Incompleted Tasks':
                              matchesFilter = task['status'] == false;
                              break;
                            default:
                              matchesFilter = true;
                          }
                          return matchesDate && matchesFilter;
                        }).toList();

                        // sort list according to different features
                        tasks.sort((a, b) {
                          switch (_sortOption) {
                            case 'Priority':
                              return _getPriorityValue(a['priority'])
                                  .compareTo(_getPriorityValue(b['priority']));
                            case 'Start Time':
                              DateTime startTimeA =
                                  DateFormat("h:mm a").parse(a['startTime']);
                              DateTime startTimeB =
                                  DateFormat("h:mm a").parse(b['startTime']);
                              return startTimeA.compareTo(startTimeB);
                            case 'Status':
                              bool aStatus = a['status'] as bool;
                              bool bStatus = b['status'] as bool;
                              return aStatus == bStatus
                                  ? 0
                                  : (aStatus ? 1 : -1);
                            default:
                              return 0;
                          }
                        });

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
      ),
    );
  }
}
