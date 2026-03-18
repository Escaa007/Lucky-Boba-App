// FILE: lib/pages/profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../state/profile_notifier.dart';
import '../main.dart'; // ← for LoginPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color _purple   = Color(0xFF7C14D4);
  static const Color _orange   = Color(0xFFFF8C00);
  static const Color _bg       = Color(0xFFFAFAFA);
  static const Color _surface  = Color(0xFFF2EEF8);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textMid  = Color(0xFF6B6B8A);

  String  _userName         = 'Loading...';
  String  _userRole         = 'customer';
  String  _userEmail        = '';
  String? _profileImagePath;
  bool    _isUploading      = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ Build the per-user profile image key
    final int?    userId    = prefs.getInt('user_id');
    final String? userIdStr = prefs.getString('user_id_str');
    final String  userKey   = userId?.toString() ?? userIdStr ?? '';
    final String  imageKey  =
    userKey.isNotEmpty ? 'profileImagePath_$userKey' : 'profileImagePath';

    setState(() {
      _userName         = prefs.getString('userName') ?? 'Guest User';
      _userRole         = prefs.getString('userRole') ?? 'customer';
      _userEmail        = prefs.getString('userEmail') ?? '';
      _profileImagePath = prefs.getString(imageKey);
    });

    // Keep notifier in sync
    profileImageNotifier.value = _profileImagePath;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source:       source,
        maxWidth:     512,
        maxHeight:    512,
        imageQuality: 85,
      );
      if (picked == null) return;

      setState(() => _isUploading = true);

      final prefs = await SharedPreferences.getInstance();

      // ✅ Save image under a per-user key so it survives logout
      final int?    userId    = prefs.getInt('user_id');
      final String? userIdStr = prefs.getString('user_id_str');
      final String  userKey   = userId?.toString() ?? userIdStr ?? '';
      final String  imageKey  =
      userKey.isNotEmpty ? 'profileImagePath_$userKey' : 'profileImagePath';

      await prefs.setString(imageKey, picked.path);
      profileImageNotifier.value = picked.path;

      setState(() {
        _profileImagePath = picked.path;
        _isUploading      = false;
      });
    } catch (e) {
      setState(() => _isUploading = false);
      debugPrint('❌ Image pick error: $e');
    }
  }

  // ── Logout: clear session → go to LoginPage ──────────────────────────────
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ Preserve keys that should survive logout
    final bool    onboardingDone = prefs.getBool('onboarding_done') ?? true;

    // Preserve ALL per-user profile images (profileImagePath_<userId>)
    final Map<String, String> savedImages = {};
    final Set<String> allKeys = prefs.getKeys();
    for (final key in allKeys) {
      if (key.startsWith('profileImagePath_')) {
        final val = prefs.getString(key);
        if (val != null) savedImages[key] = val;
      }
    }

    // Preserve per-user terms acceptance flags
    final Map<String, bool> savedTerms = {};
    for (final key in allKeys) {
      if (key.startsWith('has_accepted_terms_')) {
        final val = prefs.getBool(key);
        if (val != null) savedTerms[key] = val;
      }
    }

    // Clear everything
    await prefs.clear();

    // ✅ Restore preserved values
    await prefs.setBool('onboarding_done', onboardingDone);
    for (final entry in savedImages.entries) {
      await prefs.setString(entry.key, entry.value);
    }
    for (final entry in savedTerms.entries) {
      await prefs.setBool(entry.key, entry.value);
    }

    // Clear avatar notifier
    profileImageNotifier.value = null;

    if (!mounted) return;

    // Replace entire navigation stack with LoginPage
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder:        (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
          (route) => false,
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width:  40,
                  height: 4,
                  decoration: BoxDecoration(
                    color:        const Color(0xFFEAEAF0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Update Profile Photo',
                style: GoogleFonts.poppins(
                  fontSize:   16,
                  fontWeight: FontWeight.w700,
                  color:      _textDark,
                ),
              ),
              const SizedBox(height: 16),
              _sourceOption(
                icon:  Icons.camera_alt_rounded,
                label: 'Take a Photo',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),
              _sourceOption(
                icon:  Icons.photo_library_rounded,
                label: 'Choose from Gallery',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_profileImagePath != null) ...[
                const SizedBox(height: 10),
                _sourceOption(
                  icon:  Icons.delete_outline_rounded,
                  label: 'Remove Photo',
                  color: Colors.red,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();

                    // ✅ Remove using per-user key
                    final int?    userId    = prefs.getInt('user_id');
                    final String? userIdStr = prefs.getString('user_id_str');
                    final String  userKey   =
                        userId?.toString() ?? userIdStr ?? '';
                    final String  imageKey  = userKey.isNotEmpty
                        ? 'profileImagePath_$userKey'
                        : 'profileImagePath';

                    await prefs.remove(imageKey);
                    profileImageNotifier.value = null;
                    setState(() => _profileImagePath = null);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sourceOption({
    required IconData     icon,
    required String       label,
    required VoidCallback onTap,
    Color?                color,
  }) {
    final c = color ?? _textDark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color != null
              ? Colors.red.withOpacity(0.06)
              : _surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: c, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize:   14,
                fontWeight: FontWeight.w600,
                color:      c,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Show real email if available, fallback to generated one
    final String displayEmail = _userEmail.isNotEmpty
        ? _userEmail
        : '${_userName.toLowerCase().replaceAll(' ', '')}@luckyboba.com';

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width:  40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: _surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size:  18,
                        color: _purple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'My Profile',
                      style: GoogleFonts.poppins(
                        fontSize:   18,
                        fontWeight: FontWeight.w700,
                        color:      _textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable body ───────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
                child: Column(
                  children: [
                    // ── Profile hero card ─────────────────────────────
                    Container(
                      width:   double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_purple, _purple.withOpacity(0.80)],
                          begin:  Alignment.topLeft,
                          end:    Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // ── Avatar ────────────────────────────────
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width:  96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 2.5,
                                  ),
                                ),
                                child: ClipOval(
                                  child: _isUploading
                                      ? const Center(
                                    child: CircularProgressIndicator(
                                      color:       Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : _profileImagePath != null &&
                                      File(_profileImagePath!)
                                          .existsSync()
                                      ? Image.file(
                                    File(_profileImagePath!),
                                    fit:    BoxFit.cover,
                                    width:  96,
                                    height: 96,
                                  )
                                      : Icon(
                                    PhosphorIconsRegular.user,
                                    color: Colors.white,
                                    size:  44,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _showImageSourceSheet,
                                child: Container(
                                  width:  30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: _orange,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size:  14,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Text(
                            _userName,
                            style: GoogleFonts.poppins(
                              fontSize:   20,
                              fontWeight: FontWeight.w800,
                              color:      Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            displayEmail,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color:    Colors.white.withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical:   5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _userRole[0].toUpperCase() +
                                  _userRole.substring(1),
                              style: GoogleFonts.poppins(
                                fontSize:   12,
                                fontWeight: FontWeight.w600,
                                color:      Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Account section ───────────────────────────────
                    _sectionLabel('Account'),
                    const SizedBox(height: 10),
                    _menuCard([
                      _MenuTileData(
                        icon:     PhosphorIconsRegular.mapPin,
                        title:    'Address Book',
                        subtitle: 'Manage your saved addresses',
                      ),
                      _MenuTileData(
                        icon:     PhosphorIconsRegular.receipt,
                        title:    'Order History',
                        subtitle: 'View your past orders',
                      ),
                      _MenuTileData(
                        icon:     PhosphorIconsRegular.bell,
                        title:    'Notifications',
                        subtitle: 'Manage alerts & updates',
                      ),
                      _MenuTileData(
                        icon:     PhosphorIconsRegular.translate,
                        title:    'Language',
                        subtitle: 'English',
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // ── Support section ───────────────────────────────
                    _sectionLabel('Support'),
                    const SizedBox(height: 10),
                    _menuCard([
                      _MenuTileData(
                        icon:  PhosphorIconsRegular.phoneCall,
                        title: 'Contact Us',
                      ),
                      _MenuTileData(
                        icon:  PhosphorIconsRegular.question,
                        title: 'Get Help',
                      ),
                      _MenuTileData(
                        icon:  PhosphorIconsRegular.shieldCheck,
                        title: 'Privacy Policy',
                      ),
                      _MenuTileData(
                        icon:  PhosphorIconsRegular.fileText,
                        title: 'Terms & Conditions',
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // ── Logout button ─────────────────────────────────
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            title: Text(
                              'Log Out',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color:      _textDark,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to log out?',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color:    _textMid,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(
                                    color:      _textMid,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _logout();
                                },
                                child: Text(
                                  'Log Out',
                                  style: GoogleFonts.poppins(
                                    color:      Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width:   double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                              size:  20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Log Out',
                              style: GoogleFonts.poppins(
                                fontSize:   14,
                                fontWeight: FontWeight.w700,
                                color:      Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize:      13,
          fontWeight:    FontWeight.w700,
          color:         _textMid,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _menuCard(List<_MenuTileData> tiles) {
    return Container(
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAF0), width: 1),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset:     const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: tiles.asMap().entries.map((entry) {
          final i      = entry.key;
          final tile   = entry.value;
          final isLast = i == tiles.length - 1;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical:   4,
                ),
                leading: Container(
                  width:  38,
                  height: 38,
                  decoration: BoxDecoration(
                    color:        _surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tile.icon, color: _purple, size: 20),
                ),
                title: Text(
                  tile.title,
                  style: GoogleFonts.poppins(
                    fontSize:   14,
                    fontWeight: FontWeight.w600,
                    color:      _textDark,
                  ),
                ),
                subtitle: tile.subtitle != null
                    ? Text(
                  tile.subtitle!,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color:    _textMid,
                  ),
                )
                    : null,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFFCCCCDD),
                  size:  14,
                ),
                onTap: () {},
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(left: 72, right: 18),
                  child: Divider(height: 1, color: Colors.grey[100]),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuTileData {
  final IconData icon;
  final String   title;
  final String?  subtitle;
  const _MenuTileData({
    required this.icon,
    required this.title,
    this.subtitle,
  });
}