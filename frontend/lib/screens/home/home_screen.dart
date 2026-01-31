import 'package:flutter/material.dart';

// Import your existing screens
import '../camera/scan_screen.dart';
//import '../events/events_screen.dart';
//import '../nearby/nearby_screen.dart';
//import '../history/wrapped_screen.dart';
//import '../chatbot/chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Pages for bottom navigation (5 tabs)
  final List<Widget> _pages = const [
   // WrappedScreen(),   // Home / History / Stats
   // EventsScreen(),    // Calendar / Events
    ScanScreen(),      // Camera
   // NearbyScreen(),    // Search / Nearby
    //ChatbotScreen(),   // Profile (placeholder for now)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,

        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },

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
