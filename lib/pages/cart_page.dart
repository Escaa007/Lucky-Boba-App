import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checkout_page.dart'; // <--- THIS LINKS TO YOUR CHECKOUT PAGE

// --- GLOBAL CART VARIABLE (For Prototyping) ---
// This list will hold all the items added to the cart across the app.
List<Map<String, dynamic>> myCart = [];

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Color deepPurple = const Color(0xFF3B2063);
  final Color lightPurple = const Color(0xFFE8DEF8);
  final Color backgroundCream = const Color(0xFFFDFDFD);

  // Calculates the total price of everything in the cart
  double get cartTotal {
    double total = 0;
    for (var item in myCart) {
      total += item['totalPrice'];
    }
    return total;
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      int currentQty = myCart[index]['quantity'];
      if (currentQty + delta > 0) {
        myCart[index]['quantity'] += delta;
        // Update the total price for this specific item row
        myCart[index]['totalPrice'] = myCart[index]['unitPrice'] * myCart[index]['quantity'];
      } else {
        // Remove item if quantity hits 0
        myCart.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundCream,
      body: SafeArea(
        child: Column(
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
                  Text(
                    "My Cart",
                    style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 48), // Spacer to center the title
                ],
              ),
            ),

            // --- CART ITEMS LIST ---
            Expanded(
              child: myCart.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 15),
                    Text(
                      "Your cart is empty",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Browse Menu", style: GoogleFonts.poppins(color: Colors.white)),
                    )
                  ],
                ),
              )
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: myCart.length,
                itemBuilder: (context, index) {
                  final item = myCart[index];
                  return _buildCartItemCard(item, index);
                },
              ),
            ),

            // --- CHECKOUT BOTTOM BAR ---
            if (myCart.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                  ],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Subtotal Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subtotal", style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[600])),
                        Text("₱${cartTotal.toStringAsFixed(2)}", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Total Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          "₱${cartTotal.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: deepPurple),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- FIXED CHECKOUT BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // This is the code that opens your checkout page!
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckoutPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(
                          "Checkout",
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
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

  // --- CART ITEM WIDGET ---
  Widget _buildCartItemCard(Map<String, dynamic> item, int index) {
    // Convert the toppings list into a single comma-separated string
    String toppingsString = (item['toppings'] as List).isEmpty
        ? "No toppings"
        : (item['toppings'] as List).join(", ");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          // Item Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              item['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Size: ${item['size']}",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  toppingsString,
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "₱${item['totalPrice'].toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: deepPurple, fontSize: 15),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                onPressed: () => setState(() => myCart.removeAt(index)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _updateQuantity(index, -1),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: lightPurple, borderRadius: BorderRadius.circular(6)),
                      child: Icon(Icons.remove, size: 16, color: deepPurple),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(item['quantity'].toString(), style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _updateQuantity(index, 1),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: deepPurple, borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.add, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}