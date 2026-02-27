import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color headerColor = Color(0xFF3B2063);
    const Color creamBg = Color(0xFFE8DEF8);

    return Scaffold(
      backgroundColor: creamBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION 1: PROMO ALERT ---
              Text(
                "New Product Alert!",
                style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: headerColor,
                    letterSpacing: 0.5
                ),
              ),
              const SizedBox(height: 15),

              _buildPromoCard(
                imagePath: 'assets/images/promo1.png',
                fallbackColor: Colors.redAccent,
                title: "HOLIDAY OVERLOAD",
                subTitle: "Limited Time Offer",
              ),

              const SizedBox(height: 30),

              // --- SECTION 2: HORIZONTAL CATEGORIES (Text Removed & Cards Enlarged) ---

              // Horizontal Scrolling List
              SizedBox(
                height: 220, // <-- INCREASED from 160 to make images larger
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildCategoryCard(
                      title: "Lucky Classic",
                      imagePath: 'assets/images/lucky_classic.png',
                      fallbackColor: Colors.orangeAccent,
                    ),
                    const SizedBox(width: 15),
                    _buildCategoryCard(
                      title: "Frappes",
                      imagePath: 'assets/images/frappe.png',
                      fallbackColor: Colors.pinkAccent,
                    ),
                    const SizedBox(width: 15),
                    _buildCategoryCard(
                      title: "Iced Coffees",
                      imagePath: 'assets/images/iced_coffee.png',
                      fallbackColor: Colors.brown[400]!,
                    ),
                    const SizedBox(width: 15),

                    // --- NEWLY ADDED CATEGORIES ---
                    _buildCategoryCard(
                      title: "Fruit Juices",
                      imagePath: 'assets/images/fruit_juices.png',
                      fallbackColor: Colors.green[400]!,
                    ),
                    const SizedBox(width: 15),
                    _buildCategoryCard(
                      title: "Cheese Series",
                      imagePath: 'assets/images/cheese_series.png',
                      fallbackColor: Colors.amber[600]!,
                    ),
                    const SizedBox(width: 15),
                    _buildCategoryCard(
                      title: "Hot Drinks",
                      imagePath: 'assets/images/hot_drinks.png',
                      fallbackColor: Colors.red[300]!,
                    ),
                    const SizedBox(width: 15),
                    _buildCategoryCard(
                      title: "Pudding",
                      imagePath: 'assets/images/pudding.png',
                      fallbackColor: Colors.orange[200]!,
                    ),
                    const SizedBox(width: 15),
                    _buildCategoryCard(
                      title: "Lucky Classic Jr.",
                      imagePath: 'assets/images/classicjr.png',
                      fallbackColor: Colors.orange[300]!,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- SECTION 3: NEW STORE ---
              Text(
                "New Store to Open",
                style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: headerColor,
                    letterSpacing: 0.5
                ),
              ),
              const SizedBox(height: 15),

              _buildPromoCard(
                imagePath: 'assets/images/promo2.png',
                fallbackColor: const Color(0xFF673AB7),
                title: "GRAND OPENING",
                subTitle: "Pamana Medical Center",
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET 1: LARGE PROMO CARD ---
  Widget _buildPromoCard({
    required String imagePath,
    required Color fallbackColor,
    required String title,
    required String subTitle,
  }) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B2063).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: fallbackColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image_rounded, color: Colors.white54, size: 60),
                          const SizedBox(height: 10),
                          Text(title, style: GoogleFonts.fredoka(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.fredoka(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: GoogleFonts.poppins(
                      color: Colors.amber,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
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

  // --- WIDGET 2: SMALL HORIZONTAL CATEGORY CARD ---
  Widget _buildCategoryCard({
    required String title,
    required String imagePath,
    required Color fallbackColor,
  }) {
    return Container(
      width: 160, // <-- INCREASED from 140 to make the card wider/larger
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B2063).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: fallbackColor,
                  child: const Center(
                    child: Icon(Icons.local_drink_rounded, color: Colors.white, size: 40),
                  ),
                ),
              ),
            ),
            // Dark Gradient so the white text is always readable
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),
            // Title Text
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}