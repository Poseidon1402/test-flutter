import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/cart_bloc.dart';

part 'components/decorative_icon.dart';
part 'components/shipping_details_section.dart';
part 'components/order_summary_section.dart';
part 'components/card_form.dart';
part 'components/confirmation_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  // Card payment controllers
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController(); // MM/YY
  final _cvvController = TextEditingController();
  bool _cardNumberValid = false;
  bool _expiryValid = false;
  bool _cvvValid = false;

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartBloc>().state;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F1729), Color(0xFF1A1D2E), Color(0xFF2D1B4E)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: size.height * 0.1,
              left: size.width * 0.05,
              child: _DecorativeIcon(
                icon: Icons.shopping_bag_outlined,
                rotation: -0.2,
                opacity: 0.03,
                size: 150,
              ),
            ),
            Positioned(
              top: size.height * 0.5,
              right: size.width * 0.08,
              child: _DecorativeIcon(
                icon: Icons.card_giftcard_outlined,
                rotation: 0.3,
                opacity: 0.04,
                size: 160,
              ),
            ),
            Positioned(
              bottom: size.height * 0.2,
              left: size.width * 0.1,
              child: _DecorativeIcon(
                icon: Icons.payment_outlined,
                rotation: 0.15,
                opacity: 0.03,
                size: 140,
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                spacing: 16.0,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Back button and title
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Checkout',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),

                                  // Two column layout for larger screens
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final isWide = constraints.maxWidth > 700;

                                      if (isWide) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Left column - Shipping details
                                            Expanded(
                                              child: _ShippingDetailsSection(
                                                nameController: _nameController,
                                                addressController:
                                                    _addressController,
                                                cityController: _cityController,
                                                zipController: _zipController,
                                              ),
                                            ),
                                            const SizedBox(width: 40),

                                            // Right column - Order summary
                                            Expanded(
                                              child: _OrderSummarySection(
                                                cartState: cartState,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            _ShippingDetailsSection(
                                              nameController: _nameController,
                                              addressController:
                                                  _addressController,
                                              cityController: _cityController,
                                              zipController: _zipController,
                                            ),
                                            const SizedBox(height: 40),
                                            _OrderSummarySection(
                                              cartState: cartState,
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 40),

                                  // Card Payment Form
                                  const Text(
                                    'Payment details',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _CardForm(
                                    cardNameController: _cardNameController,
                                    cardNumberController: _cardNumberController,
                                    expiryController: _expiryController,
                                    cvvController: _cvvController,
                                    onNumberValid: (v) =>
                                        setState(() => _cardNumberValid = v),
                                    onExpiryValid: (v) =>
                                        setState(() => _expiryValid = v),
                                    onCvvValid: (v) =>
                                        setState(() => _cvvValid = v),
                                  ),

                                  // Confirm button
                                  Container(
                                    width: double.infinity,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF9D4EDD),
                                          Color(0xFF7B2CBF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF9D4EDD,
                                          ).withOpacity(0.4),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (!_formKey.currentState!.validate())
                                          return;
                                        if (!(_cardNumberValid &&
                                            _expiryValid &&
                                            _cvvValid)) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please enter valid card details',
                                              ),
                                              backgroundColor: Color(
                                                0xFF9D4EDD,
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        context.read<CartBloc>().add(
                                          const CartCleared(),
                                        );
                                        showDialog<void>(
                                          context: context,
                                          builder: (context) =>
                                              _ConfirmationDialog(),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Confirm order (€${cartState.subtotal.toStringAsFixed(2)})',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted to part: components/shipping_details_section.dart

// Extracted to part: components/card_form.dart

// Extracted to part: components/order_summary_section.dart

// Extracted to part: components/confirmation_dialog.dart

// Extracted to part: components/decorative_icon.dart
