import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_page.dart'; // <--- THIS IS THE MAGIC LINK TO YOUR CART

class ItemCustomizationPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const ItemCustomizationPage({super.key, required this.item});

  @override
  State<ItemCustomizationPage> createState() => _ItemCustomizationPageState();
}

class _ItemCustomizationPageState extends State<ItemCustomizationPage> {
  final Color deepPurple = const Color(0xFF3B2063);
  final Color lightPurple = const Color(0xFFE8DEF8);
  final Color backgroundCream = const Color(0xFFFDFDFD);

  // Customization State
  String _selectedSize = 'Regular';
  int _quantity = 1;
  final List<String> _selectedToppings = [];

  // Pricing Rules
  final double _largeSizeAddOn = 15.00;
  final Map<String, double> _toppingsMenu = {
    'Tapioca Pearl': 15.00,
    'Nata de Coco': 15.00,
    'Cream Cheese': 20.00,
    'Crushed Oreo': 15.00,
  };

  // Calculate the total price dynamically
  double get totalPrice {
    double basePrice = widget.item['price'];

    if (_selectedSize == 'Large') {
      basePrice += _largeSizeAddOn;
    }

    for (String topping in _selectedToppings) {
      basePrice += _toppingsMenu[topping]!;
    }

    return basePrice * _quantity;
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
                  Row(
                    children: [
                      // Clickable Cart Icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartPage()),
                          );
                        },
                        child: const Icon(Icons.shopping_basket_outlined, size: 28),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.account_circle, size: 28),
                    ],
                  )
                ],
              ),
            ),

            // --- SCROLLABLE CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hero Image
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: lightPurple.withOpacity(0.5),
                      ),
                      child: Image.asset(
                        widget.item['image'],
                        fit: BoxFit.contain,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2. Title & Base Price
                          Text(
                            widget.item['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Base Price: ₱${widget.item['price'].toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: deepPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const Divider(height: 40, thickness: 1),

                          // 3. Size & Quantity Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Size Section (Left)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Size", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text("Required", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[700])),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _buildSizeOption('Regular', 0),
                                    _buildSizeOption('Large', _largeSizeAddOn),
                                  ],
                                ),
                              ),

                              // Quantity Section (Right)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Quantity", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        _buildQtyButton(Icons.remove, () {
                                          if (_quantity > 1) setState(() => _quantity--);
                                        }),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Text(
                                            _quantity.toString(),
                                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        _buildQtyButton(Icons.add, () {
                                          setState(() => _quantity++);
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // 4. Toppings Section
                          Text("Toppings", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Optional", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500])),
                          const SizedBox(height: 10),
                          ..._toppingsMenu.entries.map((entry) => _buildToppingCheckbox(entry.key, entry.value)),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- BOTTOM ADD TO CART BAR ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Row(
                children: [
                  // Total Price Display
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Total Price", style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 13)),
                      Text(
                        "₱${totalPrice.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: deepPurple),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  // --- ADD TO CART BUTTON LOGIC ---
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 1. Create a map of the finalized drink
                        Map<String, dynamic> customizedDrink = {
                          'name': widget.item['name'],
                          'image': widget.item['image'],
                          'size': _selectedSize,
                          'toppings': List<String>.from(_selectedToppings),
                          'quantity': _quantity,
                          'unitPrice': totalPrice / _quantity,
                          'totalPrice': totalPrice,
                        };

                        // 2. Add it to the global cart list inside cart_page.dart!
                        myCart.add(customizedDrink);

                        // 3. Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${_quantity}x ${widget.item['name']} added to cart!"),
                            backgroundColor: deepPurple,
                            duration: const Duration(seconds: 2),
                          ),
                        );

                        // 4. Go back to menu
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        "Add to Cart",
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

  // --- HELPER WIDGETS ---
  Widget _buildSizeOption(String sizeName, double extraPrice) {
    return InkWell(
      onTap: () => setState(() => _selectedSize = sizeName),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              _selectedSize == sizeName ? Icons.radio_button_checked : Icons.radio_button_off,
              color: _selectedSize == sizeName ? deepPurple : Colors.grey,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              sizeName,
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: _selectedSize == sizeName ? FontWeight.w600 : FontWeight.normal),
            ),
            if (extraPrice > 0)
              Text(" (+₱${extraPrice.toStringAsFixed(0)})", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildToppingCheckbox(String toppingName, double price) {
    bool isSelected = _selectedToppings.contains(toppingName);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedToppings.remove(toppingName);
          } else {
            _selectedToppings.add(toppingName);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? deepPurple : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              toppingName,
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
            ),
            const Spacer(),
            Text("+₱${price.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: deepPurple),
      ),
    );
  }
}