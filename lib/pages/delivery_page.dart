import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  // Updated GrabFood URL with search parameters for Lucky Boba
  final String grabFoodUrl =
      'https://food.grab.com/ph/en/restaurants?lng=en&search=lucky%20boba&support-deeplink=true&searchParameter=lucky%20boba';

  // Updated foodpanda URL with search parameters for Lucky Boba
  final String foodPandaUrl =
      'https://www.foodpanda.ph/?utm_source=google&utm_medium=cpc&utm_campaign=22206545164&gad_source=1&gad_campaignid=22206545164&gbraid=0AAAAADiVv6NQw-RdoMzRA6MbRjHT6jVjZ&gclid=CjwKCAiA2PrMBhA4EiwAwpHyC5HSYAeCB1zyJGenbJUnNWrdRgy5E-7gEeNVq8I15mX6KYOTGYGdhhoCeyQQAvD_BwE&query=luckyboba';

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    // mode: LaunchMode.externalApplication is key for triggering the actual app
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color deepPurple = const Color(0xFF3B2063);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: deepPurple, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          "Delivery Partners",
          style: GoogleFonts.fredoka(color: deepPurple, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Order via our partners",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),

            // --- GRABFOOD CARD ---
            _buildPartnerCard(
              context,
              imagePath: 'assets/images/grabfood_logo.png',
              brandColor: const Color(0xFF00B14F),
              onTap: () => _launchUrl(grabFoodUrl),
              title: "GrabFood",
              subtitle: "Fast delivery to your doorstep",
            ),

            const SizedBox(height: 20),

            // --- FOODPANDA CARD ---
            _buildPartnerCard(
              context,
              imagePath: 'assets/images/foodpanda_logo.png',
              brandColor: const Color(0xFFD70F64),
              onTap: () => _launchUrl(foodPandaUrl),
              title: "foodpanda",
              subtitle: "Craving Boba? We've got you covered",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerCard(
      BuildContext context, {
        required String imagePath,
        required Color brandColor,
        required VoidCallback onTap,
        required String title,
        required String subtitle,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: brandColor.withOpacity(0.1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: brandColor.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 100,
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.delivery_dining, color: brandColor, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios_rounded, color: brandColor, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}