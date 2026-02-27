import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  // --- CARD DATA ---
  final List<Map<String, String>> cardList = const [
    {
      'title': 'Daily Card',
      'image': 'assets/images/normal_card.png',
      'price': 'P300',
    },
    {
      'title': 'Valentines Card',
      'image': 'assets/images/valentines_card.png',
      'price': 'P300',
    },
    {
      'title': 'Students Card',
      'image': 'assets/images/student_card.png',
      'price': 'P300',
    },
    {
      'title': 'Summer Card',
      'image': 'assets/images/summer_card.png',
      'price': 'P300',
    },
    {
      'title': 'Birthday Card',
      'image': 'assets/images/birthday_card.png',
      'price': 'P300',
    },
  ];

  // --- BIRTHDAY DIALOG ---
  void _showBirthdayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.cake_rounded, color: Color(0xFF3B2063)),
            const SizedBox(width: 10),
            Text(
              "Birthday Card",
              style: GoogleFonts.fredoka(color: const Color(0xFF3B2063), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "Please present a valid ID with your birth date to the cashier when claiming this card.",
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: Text("CANCEL", style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Birthday Card selected!", style: GoogleFonts.poppins()),
                  backgroundColor: const Color(0xFF3B2063),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD54F), // Gold
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("I UNDERSTAND", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current month (1 = Jan, 2 = Feb, 3 = Mar, etc.)
    final int currentMonth = DateTime.now().month;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- HEADER ---
            Text(
              "Choose Your Card",
              style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3B2063), // Deep Purple
              ),
            ),
            const SizedBox(height: 20),

            // --- GENERATE CARD LIST ---
            ...cardList.map((card) {
              String title = card['title']!;
              bool isAvailable = true;

              // CONDITION 1: Valentines Card (Only February)
              if (title == 'Valentines Card') {
                isAvailable = (currentMonth == 2);
              }
              // CONDITION 2: Summer Card (Only March, April, May)
              else if (title == 'Summer Card') {
                isAvailable = (currentMonth >= 3 && currentMonth <= 5);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FlipCardItem(
                  title: title,
                  imagePath: card['image']!,
                  price: card['price']!,
                  fallbackColor: const Color(0xFFD4C8F0),
                  isAvailable: isAvailable, // Passes the condition to the card
                  onBuyPressed: () {
                    // CONDITION 3: Birthday Card Dialog
                    if (title == 'Birthday Card') {
                      _showBirthdayDialog(context);
                    } else {
                      // Normal buy action for other cards
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$title selected!", style: GoogleFonts.poppins()),
                          backgroundColor: const Color(0xFF3B2063),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
              );
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// --- FLIPPING CARD WIDGET ---
class FlipCardItem extends StatefulWidget {
  final String title;
  final String imagePath;
  final String price;
  final Color fallbackColor;
  final bool isAvailable;
  final VoidCallback onBuyPressed;

  const FlipCardItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.price,
    required this.fallbackColor,
    required this.isAvailable,
    required this.onBuyPressed,
  });

  @override
  State<FlipCardItem> createState() => _FlipCardItemState();
}

class _FlipCardItemState extends State<FlipCardItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (!mounted) return;
    setState(() {
      _isFlipped = !_isFlipped;
    });
    if (_isFlipped) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        // If unavailable, make the background slightly grayed out
        color: widget.isAvailable ? Colors.white : Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            // 1. THE FLIPPING BACKGROUND IMAGE (With Opacity Condition)
            Positioned.fill(
              child: Opacity(
                opacity: widget.isAvailable ? 1.0 : 0.4, // Dims the image if unavailable
                child: GestureDetector(
                  onTap: _toggleFlip,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final angle = _animation.value * math.pi;
                      final isBack = angle > math.pi / 2;

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        alignment: Alignment.center,
                        child: isBack
                            ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: _buildImage('assets/images/back_card.png'),
                        )
                            : _buildImage(widget.imagePath),
                      );
                    },
                  ),
                ),
              ),
            ),

            // 2. UNAVAILABLE STAMP (Only shows if card is not available)
            if (!widget.isAvailable)
              Positioned.fill(
                child: Center(
                  child: Transform.rotate(
                    angle: -0.2, // Tilts the text slightly for a "stamp" effect
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.redAccent, width: 2),
                      ),
                      child: Text(
                        "UNAVAILABLE",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // 3. CARD TITLE
            Positioned(
              top: 15,
              left: 15,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),

            // 4. BUY & PRICE BUTTONS
            Positioned(
              bottom: 15,
              right: 15,
              child: Row(
                children: [
                  Material(
                    // Changes button color to gray if unavailable
                    color: widget.isAvailable ? const Color(0xFFFFD54F) : Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      // Disables the tap completely if unavailable
                      onTap: widget.isAvailable ? widget.onBuyPressed : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "BUY",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            // Dims the text if unavailable
                            color: widget.isAvailable ? Colors.black : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.isAvailable ? const Color(0xFFFFD54F) : Colors.grey[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.price,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: widget.isAvailable ? Colors.black : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: widget.fallbackColor,
          child: const Center(
            child: Icon(Icons.credit_card_rounded, color: Colors.white, size: 50),
          ),
        );
      },
    );
  }
}