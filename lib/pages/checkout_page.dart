import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_page.dart'; // To access myCart data

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final Color deepPurple = const Color(0xFF3B2063);
  final Color backgroundCream = const Color(0xFFFDFDFD);

  // State for Payment Method and Order Type
  String _selectedPayment = 'GCash';
  String _orderType = 'Take Out'; // Default selected option

  double get cartTotal {
    double total = 0;
    for (var item in myCart) {
      total += item['totalPrice'];
    }
    return total;
  }

  void _placeOrder() {
    // Show a success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Text(
          "Order Placed Successfully!\n\nOrder Type: $_orderType\nPayment: $_selectedPayment",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Clear the cart
                setState(() {
                  myCart.clear();
                });
                // Pop all the way back to the Menu Page
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Back to Menu", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundCream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOP HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      // Cart Icon with Badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_basket_outlined, size: 28),
                          if (myCart.isNotEmpty)
                            Positioned(
                              right: -5,
                              top: -5,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  myCart.length.toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.history, size: 28),
                      const SizedBox(width: 15),
                      const Icon(Icons.account_circle, size: 28),
                    ],
                  )
                ],
              ),
            ),

            // --- PAGE TITLE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Review and Payment",
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Let's review your order.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- SCROLLABLE CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. ORDER SUMMARY LIST
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myCart.length,
                      itemBuilder: (context, index) {
                        final item = myCart[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(item['image'], width: 60, height: 60, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item['quantity']}x ${item['name']}",
                                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "₱${item['totalPrice'].toStringAsFixed(2)}",
                                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                                onPressed: () {
                                  Navigator.pop(context); // Go back to cart to edit
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(height: 30),

                    // 2. ORDER TYPE SELECTION (Dine In / Take Out)
                    Text("Order Type", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildOrderTypeButton('Dine In', Icons.storefront_outlined),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildOrderTypeButton('Take Out', Icons.shopping_bag_outlined),
                        ),
                      ],
                    ),
                    const Divider(height: 30),

                    // 3. PAYMENT OPTIONS
                    Text("Choose your payment option", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _buildPaymentOption('GCash'),
                    _buildPaymentOption('Cash'),
                    _buildPaymentOption('Credit or debit card'),

                    const SizedBox(height: 30), // Padding before button
                  ],
                ),
              ),
            ),

            // --- BOTTOM PLACE ORDER BUTTON ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: myCart.isEmpty ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    "Place Order (₱${cartTotal.toStringAsFixed(2)})",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  // Order Type Toggle Buttons
  Widget _buildOrderTypeButton(String title, IconData icon) {
    bool isSelected = _orderType == title;
    return InkWell(
      onTap: () {
        setState(() {
          _orderType = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? deepPurple : Colors.white,
          border: Border.all(color: isSelected ? deepPurple : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey[700]),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Radio buttons for payment
  Widget _buildPaymentOption(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPayment = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              _selectedPayment == title ? Icons.radio_button_checked : Icons.radio_button_off,
              color: _selectedPayment == title ? deepPurple : Colors.grey,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: _selectedPayment == title ? FontWeight.w500 : FontWeight.normal
              ),
            ),
          ],
        ),
      ),
    );
  }
}