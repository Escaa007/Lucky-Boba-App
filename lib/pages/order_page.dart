import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'delivery_page.dart';
import 'stores_page.dart'; // Make sure the filename is renamed to stores_page.dart

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color deepPurple = const Color(0xFF3B2063);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- 1. LOGO ---
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.local_drink, size: 100, color: deepPurple),
              ),
              const SizedBox(height: 40),

              Text(
                "How would you like to get your Boba?",
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: deepPurple,
                ),
              ),
              const SizedBox(height: 40),

              // --- 2. DELIVERY BUTTON ---
              _buildBigButton(
                context,
                title: "Delivery",
                icon: Icons.delivery_dining_rounded,
                color: const Color(0xFF00B14F), // Grab Green
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryPage())),
              ),
              const SizedBox(height: 20),

              // --- 3. PICKUP BUTTON ---
              _buildBigButton(
                context,
                title: "Pickup",
                icon: Icons.storefront_rounded,
                color: const Color(0xFFFF7A00), // Pickup Orange
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StoresPage())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigButton(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 30, color: Colors.white),
        label: Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
        ),
      ),
    );
  }
}