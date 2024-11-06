import 'package:flutter/material.dart';

class TaskManager extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  // seleted date
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
