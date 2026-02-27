import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final Color darkVioletNav = const Color(0xFF3B2063);
    final Color lightLavenderPill = const Color(0xFFD0BCFF);

    return Container(
      decoration: BoxDecoration(
        color: darkVioletNav,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return GoogleFonts.fredoka(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  );
                }
                return GoogleFonts.fredoka(color: Colors.white70, fontSize: 11);
              },
            ),
            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(size: 32, color: Color(0xFF3B2063));
                }
                return const IconThemeData(size: 28, color: Colors.white70);
              },
            ),
          ),
          child: NavigationBar(
            height: 80,
            backgroundColor: darkVioletNav,
            indicatorColor: lightLavenderPill,
            selectedIndex: selectedIndex,
            onDestinationSelected: onTabChange,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_drink_outlined),
                selectedIcon: Icon(Icons.local_drink_rounded),
                label: 'Order',
              ),
              // --- CHANGED TO CARDS ---
              NavigationDestination(
                icon: Icon(Icons.credit_card_outlined),
                selectedIcon: Icon(Icons.credit_card_rounded),
                label: 'Cards',
              ),
              NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map_rounded),
                label: 'Stores',
              ),
            ],
          ),
        ),
      ),
    );
  }
}