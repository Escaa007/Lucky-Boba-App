import 'package:flutter/material.dart';
import 'dart:async';
import '../dashboard.dart';

class LandingPromoPage extends StatefulWidget {
  const LandingPromoPage({super.key});

  @override
  State<LandingPromoPage> createState() => _LandingPromoPageState();
}

class _LandingPromoPageState extends State<LandingPromoPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _timer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // --- SUBTLE ZOOM OUT ---
    // Starting at 1.08 (8% larger) and ending at 1.0 (perfect fit)
    _scaleAnimation = Tween<double>(begin: 1.08, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine, // Extra smooth motion
      ),
    );

    // Gentle fade in
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();

    _timer = Timer(const Duration(seconds: 5), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    if (_isNavigating) return;
    setState(() {
      _isNavigating = true;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // --- FULL SCREEN SUBTLE ZOOM-OUT ---
          SizedBox.expand(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/images/prompt_image.png',
                fit: BoxFit.cover, // Keeps it full screen throughout
              ),
            ),
          ),

          // --- SKIP BUTTON ---
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _navigateToNextScreen,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.4),
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(), // Nice rounded pill shape
                  ),
                  child: const Text("Skip"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}