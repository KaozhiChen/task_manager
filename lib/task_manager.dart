import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskManager extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> get tasks => _tasks;

  TaskManager() {
    _fetchTasksFromFirebase();
  }

  // get tasks from Firebase
  void _fetchTasksFromFirebase() {
    _firestore.collection('tasks').snapshots().listen((snapshot) {
      _tasks = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'status': doc['status'],
          'date': doc['date'],
          'startTime': doc['startTime'],
          'endTime': doc['endTime'],
          'priority': doc['priority'],
        };
      }).toList();
      notifyListeners();
    });
  }

  // add tasks to local and firebase
  Future<void> addTask({
    required String taskName,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String priority,
    required BuildContext context,
  }) async {
    String formattedStartTime = startTime.format(context);
    String formattedEndTime = endTime.format(context);

    // firebase
    DocumentReference docRef = await _firestore.collection('tasks').add({
      'name': taskName,
      'status': false,
      'date': DateTime.now(),
      'startTime': formattedStartTime,
      'endTime': formattedEndTime,
      'priority': priority,
    });

    // local
    _tasks.add({
      'id': docRef.id,
      'name': taskName,
      'status': false,
      'date': DateTime.now(),
      'startTime': formattedStartTime,
      'endTime': formattedEndTime,
      'priority': priority,
    });
    notifyListeners();
  }

  // seleted date
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
