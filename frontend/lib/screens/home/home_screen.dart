import 'package:flutter/material.dart';

import '../camera/scan_screen.dart';
import '../events/events_screen.dart';
import '../nearby/nearby_screen.dart';
import '../history/wrapped_screen.dart';
import '../chatbot/chatbot_screen.dart';
// If you have a real profile screen later, replace one of these with it.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  // 5 tabs in order
  final List<Widget> _pages = const [
    WrappedScreen(),     // Home tab (you can replace with a dashboard later)
    EventsScreen(),      // Calendar tab (your "events" screen)
    ScanScreen(),        // Camera tab (THIS is what you need)
    NearbyScreen(),      // Search/Lookup tab (you can rename later)
    ChatbotScreen(),     // Profile tab placeholder (replace with real profile later)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
