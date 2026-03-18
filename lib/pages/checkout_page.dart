// FILE: lib/pages/checkout_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // ── Brand tokens ─────────────────────────────────────────────────────────
  static const Color _purple   = Color(0xFF7C14D4);
  static const Color _orange   = Color(0xFFFF8C00);
  static const Color _bg       = Color(0xFFFAFAFA);
  static const Color _surface  = Color(0xFFF2EEF8);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textMid  = Color(0xFF6B6B8A);

  String _selectedPayment = 'GCash';
  String _orderType       = 'Take Out';

  // Payment options with icons
  final List<Map<String, dynamic>> _paymentOptions = [
    {'label': 'GCash',              'icon': Icons.account_balance_wallet_rounded},
    {'label': 'Cash',               'icon': Icons.payments_rounded},
    {'label': 'Credit / Debit Card','icon': Icons.credit_card_rounded},
  ];

  double get cartTotal => myCart.fold(0.0, (sum, item) {
    final p = item['totalPrice'];
    if (p is double) return sum + p;
    if (p is int) return sum + p.toDouble();
    return sum + (double.tryParse(p?.toString() ?? '0') ?? 0.0);
  });

  void _placeOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'Order Placed!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your order has been received.',
                style: GoogleFonts.poppins(fontSize: 13, color: _textMid),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Order summary pill
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _summaryRow('Order Type', _orderType),
                    const SizedBox(height: 6),
                    _summaryRow('Payment', _selectedPayment),
                    const SizedBox(height: 6),
                    _summaryRow('Total',
                        '₱${cartTotal.toStringAsFixed(2)}',
                        valueColor: _orange),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    myCart.clear();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Back to Menu',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
            GoogleFonts.poppins(fontSize: 12, color: _textMid)),
        Text(value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: valueColor ?? _textDark,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── APP BAR ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: _surface, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: _purple),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Review & Payment',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                            )),
                        Text('Confirm your order details',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: _textMid,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── SCROLLABLE CONTENT ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── ORDER ITEMS ──────────────────────────────────
                    _sectionLabel('Order Summary',
                        subtitle: '${myCart.length} item${myCart.length != 1 ? 's' : ''}'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: const Color(0xFFEAEAF0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myCart.length,
                        separatorBuilder: (_, __) => const Divider(
                            height: 1, color: Color(0xFFEAEAF0)),
                        itemBuilder: (_, index) {
                          final item = myCart[index];
                          final String? image =
                          item['image']?.toString();
                          final double price = () {
                            final p = item['totalPrice'];
                            if (p is double) return p;
                            if (p is int) return p.toDouble();
                            return double.tryParse(
                                p?.toString() ?? '0') ??
                                0.0;
                          }();

                          return Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  child: image != null &&
                                      image.isNotEmpty
                                      ? Image.network(
                                    image,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) =>
                                        _imgPlaceholder(),
                                  )
                                      : _imgPlaceholder(),
                                ),
                                const SizedBox(width: 12),
                                // Name + size
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item['quantity']}× ${item['name']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: _textDark,
                                        ),
                                        maxLines: 2,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                      if ((item['size'] ?? '')
                                          .toString()
                                          .isNotEmpty &&
                                          item['size'] != 'Regular')
                                        Text(
                                          item['size'].toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: _purple,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₱${price.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _orange,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── ORDER TYPE ───────────────────────────────────
                    _sectionLabel('Order Type'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: _orderTypeCard(
                                'Dine In',
                                Icons.storefront_rounded)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _orderTypeCard(
                                'Take Out',
                                Icons.shopping_bag_rounded)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── PAYMENT ──────────────────────────────────────
                    _sectionLabel('Payment Method'),
                    const SizedBox(height: 10),
                    ..._paymentOptions.map((opt) =>
                        _paymentCard(opt['label'], opt['icon'])),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // ── BOTTOM PLACE ORDER BAR ────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: _textMid)),
                      Text(
                        '₱${cartTotal.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: _purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                      myCart.isEmpty ? null : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        disabledBackgroundColor:
                        _purple.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Place Order',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
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

  // ── Helper widgets ────────────────────────────────────────────────────────

  Widget _sectionLabel(String label, {String? subtitle}) {
    return Row(
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _textDark)),
        if (subtitle != null) ...[
          const SizedBox(width: 8),
          Text(subtitle,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: _textMid)),
        ],
      ],
    );
  }

  Widget _orderTypeCard(String title, IconData icon) {
    final bool selected = _orderType == title;
    return GestureDetector(
      onTap: () => setState(() => _orderType = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? _purple : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _purple : const Color(0xFFEAEAF0),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: _purple.withOpacity(0.20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
              : [],
        ),
        child: Column(
          children: [
            Icon(icon,
                color: selected ? Colors.white : _textMid,
                size: 26),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : _textMid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentCard(String label, IconData icon) {
    final bool selected = _selectedPayment == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = label),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _purple.withOpacity(0.07) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _purple : const Color(0xFFEAEAF0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected
                    ? _purple.withOpacity(0.12)
                    : _surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  size: 20,
                  color: selected ? _purple : _textMid),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.normal,
                  color: selected ? _purple : _textDark,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? _purple : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _imgPlaceholder() {
    return Container(
      width: 56,
      height: 56,
      color: _surface,
      child: const Center(
        child: Icon(Icons.local_cafe_rounded,
            color: _purple, size: 24),
      ),
    );
  }
}