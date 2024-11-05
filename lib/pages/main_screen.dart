import 'package:flutter/material.dart';
import 'home_page.dart';
import 'statistics_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StatisticsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.purple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.list,
                  color: _selectedIndex == 0 ? Colors.white : Colors.grey[400]),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.history,
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey[400]),
              onPressed: () => _onItemTapped(1),
            ),
          ],
        ),
      ),
    );
  }
}
