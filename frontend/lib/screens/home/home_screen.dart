import 'package:flutter/material.dart';

import '../camera/scan_screen.dart';
import 'home_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // 5 pages must match 5 tabs
  final List<Widget> _pages = const [   
    _Placeholder(title: 'Wrapp'), // Home UI
    _Placeholder(title: 'Calendar'), // TODO: replace later
    ScanScreen(), // Scan (camera)
    _Placeholder(title: 'Search'), // TODO: replace later
    HomeDashboard(), // TODO: replace later
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home)),
          NavigationDestination(
              icon: Icon(Icons.calendar_month)),
          NavigationDestination(icon: Icon(Icons.camera_alt)),
          NavigationDestination(icon: Icon(Icons.search)),
          NavigationDestination(icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}
