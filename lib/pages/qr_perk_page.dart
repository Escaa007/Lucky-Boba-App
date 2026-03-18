// FILE: lib/pages/qr_perk_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';

class QrPerkPage extends StatefulWidget {
  final String perkName;
  const QrPerkPage({super.key, required this.perkName});

  @override
  State<QrPerkPage> createState() => _QrPerkPageState();
}

class _QrPerkPageState extends State<QrPerkPage> {
  // ── Brand tokens ────────────────────────────────────────────────────────
  static const Color _purple   = Color(0xFF7C14D4);
  static const Color _bg       = Color(0xFFFAFAFA);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textMid  = Color(0xFF6B6B8A);

  bool _isRevealed = false;
  int _remainingSeconds = 600;
  Timer? _timer;
  int? _userId;
  String _qrData = 'hidden';
  String _textCode = '------';

  @override
  void initState() {
    super.initState();
    _loadQrState();
  }

  Future<void> _loadQrState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _userId = prefs.getInt('user_id'));

    final String today = DateTime.now().toIso8601String().substring(0, 10);
    final String? savedDate =
    prefs.getString('qr_date_${widget.perkName}');

    if (savedDate == today) {
      final String? savedTimeStr =
      prefs.getString('qr_time_${widget.perkName}');
      if (savedTimeStr != null) {
        final DateTime revealTime = DateTime.parse(savedTimeStr);
        final int elapsed =
            DateTime.now().difference(revealTime).inSeconds;
        setState(() {
          _isRevealed = true;
          _qrData =
              prefs.getString('qr_data_${widget.perkName}') ?? 'hidden';
          _textCode =
              prefs.getString('qr_text_${widget.perkName}') ?? '------';
          _remainingSeconds = 600 - elapsed;
        });
        _remainingSeconds > 0
            ? _startTimer()
            : setState(() => _remainingSeconds = 0);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _revealQrCode() async {
    final random = Random();
    final int randomNum = 100000 + random.nextInt(900000);
    final DateTime now = DateTime.now();
    final String today = now.toIso8601String().substring(0, 10);
    final String newTextCode = 'LB-$randomNum';
    final String newQrData =
        'luckyboba|${widget.perkName}|user_$_userId|$newTextCode|${now.millisecondsSinceEpoch}';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('qr_date_${widget.perkName}', today);
    await prefs.setString(
        'qr_time_${widget.perkName}', now.toIso8601String());
    await prefs.setString('qr_data_${widget.perkName}', newQrData);
    await prefs.setString('qr_text_${widget.perkName}', newTextCode);

    setState(() {
      _isRevealed = true;
      _remainingSeconds = 600;
      _textCode = newTextCode;
      _qrData = newQrData;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String get _formattedTime {
    final int m = _remainingSeconds ~/ 60;
    final int s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpired = _isRevealed && _remainingSeconds == 0;
    final bool isUrgent = _isRevealed && !isExpired && _remainingSeconds < 60;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: Text(
          widget.perkName,
          style: GoogleFonts.poppins(
            color: _textDark,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A2E), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEAEAF0)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // ── Warning banner ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.07),
                  border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.4),
                      width: 1.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(PhosphorIconsFill.warningCircle,
                        color: Colors.redAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Do not reveal until you are at the counter!',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            isExpired
                                ? 'You have already used your code for today. Come back tomorrow!'
                                : 'This code expires 10 minutes after reveal. Can only be used once per day.',
                            style: GoogleFonts.poppins(
                              color: Colors.redAccent.withValues(alpha: 0.8),
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── QR code box ───────────────────────────────────────────
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 270,
                        height: 270,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: const Color(0xFFEAEAF0), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: _purple.withValues(alpha: 0.10),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // QR
                            Opacity(
                              opacity: isExpired ? 0.15 : 1.0,
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: (!_isRevealed || isExpired)
                                      ? 10.0
                                      : 0.0,
                                  sigmaY: (!_isRevealed || isExpired)
                                      ? 10.0
                                      : 0.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: QrImageView(
                                    data: _qrData,
                                    version: QrVersions.auto,
                                    size: 200,
                                    eyeStyle: QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      color: _purple,
                                    ),
                                    dataModuleStyle: QrDataModuleStyle(
                                      dataModuleShape:
                                      QrDataModuleShape.square,
                                      color: _purple,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Reveal button
                            if (!_isRevealed)
                              ElevatedButton.icon(
                                onPressed: _revealQrCode,
                                icon: const Icon(PhosphorIconsRegular.eye,
                                    size: 18),
                                label: Text('Reveal QR Code',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _purple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                              ),

                            // Expired overlay
                            if (isExpired)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                      PhosphorIconsRegular.clockAfternoon,
                                      color: Colors.redAccent,
                                      size: 36),
                                  const SizedBox(height: 8),
                                  Text('EXPIRED',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.redAccent,
                                      )),
                                  Text('Come back tomorrow',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.redAccent)),
                                ],
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Timer + cashier code ─────────────────────────
                      if (_isRevealed && !isExpired) ...[
                        Text('Valid for',
                            style: GoogleFonts.poppins(
                                color: _textMid, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(
                          _formattedTime,
                          style: GoogleFonts.poppins(
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                            color: isUrgent ? Colors.redAccent : _purple,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFFEAEAF0), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'CASHIER CODE',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _textMid,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _textCode,
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: _purple,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}