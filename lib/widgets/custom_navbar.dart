import 'package:flutter/material.dart';

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
    final Color deepPurple = const Color(0xFF3B2063);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: deepPurple.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(index: 0, icon: Icons.storefront_rounded, deepPurple: deepPurple),
              _buildNavItem(index: 1, icon: Icons.local_drink_rounded, deepPurple: deepPurple),
              _buildNavItem(index: 2, icon: Icons.credit_card_rounded, deepPurple: deepPurple),
              _buildNavItem(index: 3, icon: Icons.map_rounded, deepPurple: deepPurple),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required Color deepPurple,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTabChange(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: isSelected ? deepPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? null
              : Border.all(color: deepPurple.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : deepPurple.withValues(alpha: 0.6),
          size: 26,
        ),
      ),
    );
  }
}