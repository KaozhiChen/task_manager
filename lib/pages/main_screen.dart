import 'package:flutter/material.dart';
import 'package:task_manager/theme/colors.dart';
import 'add_task.dart';
import 'home_page.dart';
import 'statistics_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now();

  List<Widget> get _pages => [
        HomePage(
          onDateSeleted: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
        const StatisticsPage(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddTaskBottomSheet() {
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskBottomSheet,
        shape: const CircleBorder(),
        backgroundColor: thirdColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        height: 72,
        notchMargin: 6.0,
        color: primary,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    Icons.home,
                    size: 28,
                    color:
                        _selectedIndex == 0 ? Colors.white : Colors.grey[400],
                  ),
                  onPressed: () => _onItemTapped(0),
                ),
              ),
            ),
            Expanded(child: Container()),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    Icons.bar_chart,
                    size: 28,
                    color:
                        _selectedIndex == 1 ? Colors.white : Colors.grey[400],
                  ),
                  onPressed: () => _onItemTapped(1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
