import 'package:flutter/material.dart';
import 'widgets/custom_navbar.dart';
import 'pages/home_page.dart';
import 'pages/order_page.dart';
import 'pages/cards_page.dart';
import 'pages/stores_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  bool _isLoading = false; // <--- ADDED: State to track if loading
  final Color creamVioletBg = const Color(0xFFE8DEF8);
  final Color deepPurple = const Color(0xFF3B2063);

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const OrderPage(),
    const CardsPage(),
    const StoresPage(),
  ];

  // --- ADDED: Fake Loading Delay ---
  void _onItemTapped(int index) async {
    if (_selectedIndex == index) return; // Do nothing if tapping the same page

    setState(() {
      _isLoading = true; // Start the loading animation
      _selectedIndex = index;
    });

    // Wait for 400 milliseconds (simulates loading data from the internet)
    await Future.delayed(const Duration(milliseconds: 400));

    // Stop the loading animation and show the page
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamVioletBg,
      body: SafeArea(
        // --- ADDED: Animated Switcher & Loading Spinner ---
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300), // Fade-in speed
          child: _isLoading
              ? Center(
            // The Loading Spinner
            key: const ValueKey('loading'),
            child: CircularProgressIndicator(
              color: deepPurple,
              strokeWidth: 4.0,
            ),
          )
              : SizedBox(
            // The Actual Page
            key: ValueKey(_selectedIndex),
            child: _pages[_selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }
}