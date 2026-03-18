// FILE: lib/dashboard.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'state/profile_notifier.dart';
import 'widgets/custom_navbar.dart';
import 'pages/home_page.dart';
import 'pages/order_page.dart';
import 'pages/cards_page.dart';
import 'pages/stores_page.dart';
import 'pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int    _selectedIndex = 0;
  String _userName      = '';

  static const Color _bg       = Color(0xFFFAFAFA);
  static const Color _purple   = Color(0xFF7C14D4);
  static const Color _surface  = Color(0xFFF2EEF8);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textMid  = Color(0xFF6B6B8A);

  List<Widget> get _pages => const [
    HomePage(),
    OrderPage(),
    CardsPage(),
    StoresPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:          Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ Use per-user key for profile image (matches profile_page.dart fix)
    final int?    userId    = prefs.getInt('user_id');
    final String? userIdStr = prefs.getString('user_id_str');
    final String  userKey   = userId?.toString() ?? userIdStr ?? '';
    final String  imageKey  = userKey.isNotEmpty
        ? 'profileImagePath_$userKey'
        : 'profileImagePath';

    setState(() {
      _userName = prefs.getString('userName') ?? 'Guest';
    });

    // Seed the notifier so avatar shows correctly on first load
    profileImageNotifier.value = prefs.getString(imageKey);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  String _getTodayLabel() {
    const days = [
      'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final now = DateTime.now();
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final bool showHeader = _selectedIndex != 3;

    return Scaffold(
      extendBody:      true,
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [

            // ── HEADER ───────────────────────────────────────────────────
            if (showHeader)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Greeting ──────────────────────────────────────────
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTodayLabel(),
                            style: GoogleFonts.poppins(
                              fontSize:   12,
                              color:      _textMid,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$_userName! 👋',
                            style: GoogleFonts.poppins(
                              fontSize:   22,
                              fontWeight: FontWeight.w700,
                              color:      _textDark,
                              height:     1.15,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),

                    // ── Avatar (reactive) ─────────────────────────────────
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfilePage()),
                      ).then((_) => _loadUserData()), // ✅ Refresh after returning from profile
                      child: ValueListenableBuilder<String?>(
                        valueListenable: profileImageNotifier,
                        builder: (context, imagePath, _) {
                          final hasImage = imagePath != null &&
                              File(imagePath).existsSync();
                          return Container(
                            height: 42,
                            width:  42,
                            decoration: BoxDecoration(
                              color:  _surface,
                              shape:  BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:      _purple.withValues(alpha: 0.10),
                                  blurRadius: 8,
                                  offset:     const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: hasImage
                                  ? Image.file(
                                File(imagePath),
                                fit:    BoxFit.cover,
                                width:  42,
                                height: 42,
                              )
                                  : const Icon(
                                PhosphorIconsRegular.user,
                                color: _purple,
                                size:  22,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            // ── PAGE CONTENT ─────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: SizedBox(
                  key: ValueKey(_selectedIndex),
                  child: _pages[_selectedIndex],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange:   _onItemTapped,
      ),
    );
  }
}