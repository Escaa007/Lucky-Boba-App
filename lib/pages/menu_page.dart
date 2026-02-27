import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'item_customization_page.dart';
import 'cart_page.dart';
import 'order_page.dart'; // <--- Ensure this import exists for the back button fallback

class MenuPage extends StatefulWidget {
  final String? selectedStore;
  const MenuPage({super.key, this.selectedStore});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Color deepPurple = const Color(0xFF3B2063);
  final Color lightPurple = const Color(0xFFE8DEF8);
  final Color backgroundCream = const Color(0xFFFDFDFD);

  int _selectedCategoryIndex = 0;

  final List<String> categories = [
    'Cheesecake', 'Coffee Frappe', 'Cream Cheese', 'Flavored Pearl', 'Foods',
    'Frappes', 'Fruit Soda', 'Fruit Tea', 'Hot Drinks', 'Iced Coffee',
    'Lucky Classic', 'Nova', 'Okinawa Brown Sugar', 'Rocksalt & Cheese', 'Yakult'
  ];

  final Map<String, List<Map<String, dynamic>>> menuData = {
    'Cheesecake': [
      {'name': 'Blueberry Cheesecake', 'price': 110.00, 'image': 'assets/menu/cheese-cake/Blueberry.jpg'},
      {'name': 'Choco Hazelnut Cheesecake', 'price': 120.00, 'image': 'assets/menu/cheese-cake/Choco Hazelnut.png'},
      {'name': 'Cookies & Cream Cheesecake', 'price': 115.00, 'image': 'assets/menu/cheese-cake/Cookies & Cream.jpg'},
      {'name': 'Mango Cheesecake', 'price': 110.00, 'image': 'assets/menu/cheese-cake/Mango.jpg'},
      {'name': 'Okinawa Cheesecake', 'price': 120.00, 'image': 'assets/menu/cheese-cake/Okinawa.jpg'},
      {'name': 'Salted Caramel Cheesecake', 'price': 115.00, 'image': 'assets/menu/cheese-cake/Salted Caramel.jpg'},
      {'name': 'Strawberry Cheesecake', 'price': 110.00, 'image': 'assets/menu/cheese-cake/Strawberry.png'},
      {'name': 'Taro Cheesecake', 'price': 110.00, 'image': 'assets/menu/cheese-cake/Taro.png'},
      {'name': 'Vanilla Cheesecake', 'price': 100.00, 'image': 'assets/menu/cheese-cake/Vanilla.jpg'},
    ],
    'Coffee Frappe': [
      {'name': 'Caramel Macchiato', 'price': 125.00, 'image': 'assets/menu/coffee-frappe/Caramel Macchiato.jpg'},
      {'name': 'Java Chip Coffee Frappe', 'price': 130.00, 'image': 'assets/menu/coffee-frappe/Java Chip Coffee Frappe.jpg'},
      {'name': 'Mocha Coffee Frappe', 'price': 125.00, 'image': 'assets/menu/coffee-frappe/Mocha Coffee Frappe.jpg'},
      {'name': 'Toffee Caramel Coffee Frappe', 'price': 130.00, 'image': 'assets/menu/coffee-frappe/Toffee Caramel Coffee Frappe.jpg'},
    ],
    'Cream Cheese': [
      {'name': 'Belgian Chocolate Cream Cheese', 'price': 120.00, 'image': 'assets/menu/cream-cheese/Belgian Chocolate.png'},
      {'name': 'Hersheys Chocolate Cream Cheese', 'price': 120.00, 'image': 'assets/menu/cream-cheese/Hersheys Chocolate.png'},
      {'name': 'Matcha Cream Cheese', 'price': 115.00, 'image': 'assets/menu/cream-cheese/Matcha.png'},
      {'name': 'Red Velvet Cream Cheese', 'price': 120.00, 'image': 'assets/menu/cream-cheese/Red Velvet.png'},
      {'name': 'Salted Caramel Cream Cheese', 'price': 115.00, 'image': 'assets/menu/cream-cheese/Salted Caramel.jpg'},
      {'name': 'Taro Cream Cheese', 'price': 110.00, 'image': 'assets/menu/cream-cheese/Taro.png'},
      {'name': 'Vanilla Cream Cheese', 'price': 110.00, 'image': 'assets/menu/cream-cheese/Vanilla.jpg'},
    ],
    'Flavored Pearl': [
      {'name': 'Avocado Milk Tea', 'price': 110.00, 'image': 'assets/menu/flavored-pearl/Avocado Milk Tea.png'},
      {'name': 'Blueberry Milk Tea', 'price': 110.00, 'image': 'assets/menu/flavored-pearl/Blueberry Milk Tea.jpg'},
      {'name': 'Caramel Macchiato Milk Tea', 'price': 120.00, 'image': 'assets/menu/flavored-pearl/Caramel Macchiato Milk Tea.png'},
      {'name': 'Chocolate', 'price': 110.00, 'image': 'assets/menu/flavored-pearl/chocolate.png'},
      {'name': 'Cookies & Cream Milk Tea', 'price': 115.00, 'image': 'assets/menu/flavored-pearl/Cookies & Cream Milk Tea.jpg'},
      {'name': 'Java Chip Milk Tea', 'price': 120.00, 'image': 'assets/menu/flavored-pearl/Java Chip Milk Tea.png'},
      {'name': 'Mango Milk Tea', 'price': 110.00, 'image': 'assets/menu/flavored-pearl/Mango Milk Tea.jpg'},
      {'name': 'Matcha Milk Tea', 'price': 115.00, 'image': 'assets/menu/flavored-pearl/Matcha Milk Tea.png'},
      {'name': 'Mocha Milk Tea', 'price': 120.00, 'image': 'assets/menu/flavored-pearl/Mocha Milk Tea.png'},
      {'name': 'Okinawa Milk Tea', 'price': 115.00, 'image': 'assets/menu/flavored-pearl/Okinawa Milk Tea.png'},
      {'name': 'Red Velvet Milk Tea', 'price': 120.00, 'image': 'assets/menu/flavored-pearl/Red Velvet Milk Tea.jpg'},
      {'name': 'Salted Caramel Milk Tea', 'price': 115.00, 'image': 'assets/menu/flavored-pearl/Salted Caramel Milk Tea.png'},
      {'name': 'Strawberry', 'price': 110.00, 'image': 'assets/menu/flavored-pearl/Strawberry.jpg'},
      {'name': 'Taro', 'price': 110.00, 'image': 'assets/menu/flavored-pearl/taro.png'},
      {'name': 'Wintermelon Milk Tea', 'price': 110.00, 'image': 'assets/menu/flavored-pearl/Wintermelon Milk Tea.png'},
    ],
    'Foods': [
      {'name': 'Combo 1', 'price': 99.00, 'image': 'assets/menu/foods/1.png'},
      {'name': 'Combo 2', 'price': 99.00, 'image': 'assets/menu/foods/2.png'},
      {'name': 'Combo 3', 'price': 99.00, 'image': 'assets/menu/foods/3.png'},
      {'name': 'Combo 4', 'price': 99.00, 'image': 'assets/menu/foods/4.png'},
      {'name': 'Combo 5', 'price': 99.00, 'image': 'assets/menu/foods/5.png'},
      {'name': 'Combo 6', 'price': 99.00, 'image': 'assets/menu/foods/6.png'},
      {'name': 'Chicken Twister Wrap', 'price': 85.00, 'image': 'assets/menu/foods/Chicken Twister Wrap.png'},
      {'name': 'French Fries', 'price': 50.00, 'image': 'assets/menu/foods/fries.png'},
      {'name': 'Loaded Fries', 'price': 75.00, 'image': 'assets/menu/foods/fries 2.png'},
      {'name': 'Longganisa Plate', 'price': 120.00, 'image': 'assets/menu/foods/longga plate.png'},
      {'name': 'Chicken Poppers', 'price': 80.00, 'image': 'assets/menu/foods/poppers.png'},
      {'name': 'Spaghetti', 'price': 90.00, 'image': 'assets/menu/foods/spagh.png'},
      {'name': 'Twister', 'price': 80.00, 'image': 'assets/menu/foods/twister.png'},
    ],
    'Frappes': [
      {'name': 'Belgian Chocolate Frappe', 'price': 120.00, 'image': 'assets/menu/frappes/Belgian Chocolate.png'},
      {'name': 'Cookies & Cream Frappe', 'price': 120.00, 'image': 'assets/menu/frappes/Cookies & Cream.jpg'},
      {'name': 'Dark Chocolate Frappe', 'price': 120.00, 'image': 'assets/menu/frappes/Dark Chocolate.png'},
      {'name': 'Hersheys Chocolate Frappe', 'price': 120.00, 'image': 'assets/menu/frappes/Hersheys Chocolate.png'},
      {'name': 'Salted Caramel Frappe', 'price': 120.00, 'image': 'assets/menu/frappes/Salted Caramel.jpg'},
      {'name': 'Taro Frappe', 'price': 120.00, 'image': 'assets/menu/frappes/Taro.jpg'},
    ],
    'Fruit Soda': [
      {'name': 'Berries', 'price': 100.00, 'image': 'assets/menu/fruit-soda/berries.jpg'},
      {'name': 'Blueberry', 'price': 100.00, 'image': 'assets/menu/fruit-soda/blueberry.jpg'},
      {'name': 'Green Apple', 'price': 100.00, 'image': 'assets/menu/fruit-soda/green apple.jpg'},
      {'name': 'Lemon', 'price': 100.00, 'image': 'assets/menu/fruit-soda/lemon.jpg'},
      {'name': 'Lychee', 'price': 100.00, 'image': 'assets/menu/fruit-soda/lychee.jpg'},
      {'name': 'Passion', 'price': 100.00, 'image': 'assets/menu/fruit-soda/passion.jpg'},
      {'name': 'Strawberry', 'price': 100.00, 'image': 'assets/menu/fruit-soda/strawberry.jpg'},
    ],
    'Fruit Tea': [
      {'name': 'Honey Lemon Green Tea', 'price': 105.00, 'image': 'assets/menu/fruit-tea/HONEY LEMON GREEN TEA.jpg'},
      {'name': 'Lemon Chia Green Tea', 'price': 110.00, 'image': 'assets/menu/fruit-tea/LEMON CHIA GREEN TEA.jpg'},
      {'name': 'Lemon Cucumber Green Tea', 'price': 110.00, 'image': 'assets/menu/fruit-tea/LEMON CUCUMBER GREEN TEA.jpg'},
      {'name': 'Passion Fruit Green Tea', 'price': 105.00, 'image': 'assets/menu/fruit-tea/PASSION FRUIT GREEN TEA.jpg'},
      {'name': 'Wintermelon Green Tea', 'price': 105.00, 'image': 'assets/menu/fruit-tea/WINTERMELON GREEN TEA.jpg'},
    ],
    'Hot Drinks': [
      {'name': 'Hot Drink 01', 'price': 90.00, 'image': 'assets/menu/hot-drinks/01.png'},
      {'name': 'Hot Drink 02', 'price': 90.00, 'image': 'assets/menu/hot-drinks/02.png'},
      {'name': 'Hot Drink 03', 'price': 90.00, 'image': 'assets/menu/hot-drinks/03.png'},
      {'name': 'Hot Drink 09', 'price': 90.00, 'image': 'assets/menu/hot-drinks/9.png'},
      {'name': 'Hot Drink 10', 'price': 90.00, 'image': 'assets/menu/hot-drinks/10.png'},
      {'name': 'Hot Drink 11', 'price': 90.00, 'image': 'assets/menu/hot-drinks/11.png'},
      {'name': 'Hot Drink 12', 'price': 90.00, 'image': 'assets/menu/hot-drinks/12.png'},
      {'name': 'Hot Drink 13', 'price': 90.00, 'image': 'assets/menu/hot-drinks/13.png'},
      {'name': 'Hot Cup', 'price': 90.00, 'image': 'assets/menu/hot-drinks/Copy of hot cup.jpg'},
    ],
    'Iced Coffee': [
      {'name': 'Caramel Macchiato', 'price': 115.00, 'image': 'assets/menu/iced-coffee/Caramel Macchiato.png'},
      {'name': 'Iced Coffee', 'price': 100.00, 'image': 'assets/menu/iced-coffee/Iced Coffee.png'},
      {'name': 'Java Chip', 'price': 115.00, 'image': 'assets/menu/iced-coffee/Java Chip.png'},
      {'name': 'Mocha', 'price': 115.00, 'image': 'assets/menu/iced-coffee/Mocha.png'},
      {'name': 'Vanilla', 'price': 110.00, 'image': 'assets/menu/iced-coffee/Vanilla.png'},
    ],
    'Iced Latte': [
      {'name': 'Vanilla Coffee Latte', 'price': 110.00, 'image': 'assets/menu/iced-latte/Copy of vanilla coffee latte.png'},
      {'name': 'Iced Chocolate Latte', 'price': 115.00, 'image': 'assets/menu/iced-latte/Iced Chocolate Latte.png'},
      {'name': 'Iced Mocha Milk Tea Latte', 'price': 115.00, 'image': 'assets/menu/iced-latte/Iced Mocha Milk Tea Latte.png'},
    ],
    'Lucky Classic': [
      {'name': 'Classic Cheesecake', 'price': 95.00, 'image': 'assets/menu/lucky-classic/Classic Cheesecake.jpg'},
      {'name': 'Classic Cream Cheese Violet', 'price': 95.00, 'image': 'assets/menu/lucky-classic/Classic Cream Cheese Violet.jpg'},
      {'name': 'Classic Buddy', 'price': 95.00, 'image': 'assets/menu/lucky-classic/Copy of classic buddy.png'},
      {'name': 'Classic Duo', 'price': 95.00, 'image': 'assets/menu/lucky-classic/Copy of classic duo.png'},
      {'name': 'Classic Pearl Milk Tea', 'price': 95.00, 'image': 'assets/menu/lucky-classic/Copy of classic pearl milk tea.png'},
      {'name': 'Vanilla RSC', 'price': 95.00, 'image': 'assets/menu/lucky-classic/VANILLA RSC.png'},
    ],
    'Nova': [
      {'name': 'Berries Nova', 'price': 115.00, 'image': 'assets/menu/nova/Berries.jpg'},
      {'name': 'Green Apple Nova', 'price': 115.00, 'image': 'assets/menu/nova/Green Apple.jpg'},
      {'name': 'Lychee Lemon Nova', 'price': 115.00, 'image': 'assets/menu/nova/Lychee Lemon.jpg'},
      {'name': 'Mango Lemon Nova', 'price': 115.00, 'image': 'assets/menu/nova/Mango Lemon.jpg'},
      {'name': 'Strawberry Nova', 'price': 115.00, 'image': 'assets/menu/nova/Strawberry.jpg'},
    ],
    'Okinawa Brown Sugar': [
      {'name': 'Okinawa Brown Sugar 1', 'price': 110.00, 'image': 'assets/menu/okinawa-brown-sugar/Copy of bs1.jpg'},
      {'name': 'Okinawa Brown Sugar 2', 'price': 110.00, 'image': 'assets/menu/okinawa-brown-sugar/Copy of bs2.jpg'},
      {'name': 'Okinawa Brown Sugar 3', 'price': 110.00, 'image': 'assets/menu/okinawa-brown-sugar/Copy of bs3.jpg'},
    ],
    'Rocksalt & Cheese': [
      {'name': 'Avocado RSC', 'price': 110.00, 'image': 'assets/menu/rocksalt&cheese/avocado rsc.jpg'},
      {'name': 'Dark Choco RSC', 'price': 110.00, 'image': 'assets/menu/rocksalt&cheese/Dark Choco RSC.jpg'},
      {'name': 'Signature RSC', 'price': 120.00, 'image': 'assets/menu/rocksalt&cheese/Gemini_Generated_Image_cd0y5ycd0y5ycd0y.png'},
      {'name': 'Mango RSC', 'price': 110.00, 'image': 'assets/menu/rocksalt&cheese/MANGO RSC.png'},
      {'name': 'Wintermelon RSC', 'price': 110.00, 'image': 'assets/menu/rocksalt&cheese/Wintermelon.png'},
    ],
    'Yakult': [
      {'name': 'Blueberry Yakult', 'price': 100.00, 'image': 'assets/menu/yakult/Blueberry Yakult-v.jpg'},
      {'name': 'Green Apple Yakult', 'price': 100.00, 'image': 'assets/menu/yakult/Copy of green apple yakult.png'},
      {'name': 'Lychee Yakult', 'price': 100.00, 'image': 'assets/menu/yakult/LYCHEE YAKULT.jpg'},
      {'name': 'Strawberry Yakult', 'price': 100.00, 'image': 'assets/menu/yakult/Strawberry.png'},
    ],
  };

  List<Map<String, dynamic>> get currentItems {
    return menuData[categories[_selectedCategoryIndex]] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundCream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- WELCOME TEXT WITH STORE NAME ---
                  if (widget.selectedStore != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        "Welcome To ${widget.selectedStore} Branch",
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: deepPurple,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                            onPressed: () {
                              // SAFETY CHECK: Prevents blackout screens
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const OrderPage()),
                                );
                              }
                            },
                          ),
                          Text(
                            "Lucky Boba Menu",
                            style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartPage(),
                                ),
                              ).then((_) {
                                setState(() {});
                              });
                            },
                            child: const Icon(Icons.shopping_basket_outlined, size: 28),
                          ),
                          const SizedBox(width: 15),
                          const Icon(Icons.account_circle, size: 28),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Sub-header logic
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Drink Selection",
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Pick your favorite and customize it just how you like.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Horizontal Category List
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  bool isSelected = index == _selectedCategoryIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategoryIndex = index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Text(
                            categories[index],
                            style: GoogleFonts.poppins(
                              color: isSelected ? deepPurple : Colors.grey[500],
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 3,
                              width: 22,
                              decoration: BoxDecoration(
                                  color: deepPurple,
                                  borderRadius: BorderRadius.circular(2)
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main Product Grid
            Expanded(
              child: currentItems.isEmpty
                  ? const Center(child: Text("Items coming soon!"))
                  : GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.72,
                ),
                itemCount: currentItems.length,
                itemBuilder: (context, index) => _buildItemCard(currentItems[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemCustomizationPage(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4)
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  item['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: lightPurple,
                    child: Icon(Icons.local_drink, color: deepPurple),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₱${item['price'].toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: deepPurple,
                            fontSize: 15
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: deepPurple,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}