import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/cart/cart_bloc.dart';
part 'components/decorative_icon.dart';
part 'components/cart_item_tile.dart';
part 'components/subtotal_section.dart';
part 'components/checkout_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              top: size.height * 0.35,
              right: size.width * 0.08,
              child: _DecorativeIcon(
                icon: Icons.card_giftcard_outlined,
                rotation: 0.3,
                opacity: 0.04,
                size: 160,
              ),
            ),
            Positioned(
              bottom: size.height * 0.15,
              left: size.width * 0.1,
              child: _DecorativeIcon(
                icon: Icons.shopping_cart_outlined,
                rotation: 0.15,
                opacity: 0.03,
                size: 140,
              ),
            ),
            Positioned(
              bottom: size.height * 0.4,
              right: size.width * 0.15,
              child: _DecorativeIcon(
                icon: Icons.card_giftcard_outlined,
                rotation: -0.25,
                opacity: 0.035,
                size: 130,
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          return ClipRRect(
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Logo and Title
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF9D4EDD),
                                                Color(0xFF7B2CBF),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.shopping_bag,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'LIVESHOP',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),

                                    // Title
                                    const Text(
                                      'Your Cart',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    // Cart Items or Empty State
                                    if (state.isLoading)
                                      const Padding(
                                        padding: EdgeInsets.all(40),
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF9D4EDD),
                                        ),
                                      )
                                    else if (state.items.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 40,
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.shopping_cart_outlined,
                                              size: 80,
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Your cart is empty',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 32),
                                            ElevatedButton(
                                              onPressed: () => context.go('/'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF9D4EDD,
                                                ),
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                      vertical: 16,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: const Text(
                                                'Continue Shopping',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Column(
                                        children: [
                                          // Cart Items List
                                          ...state.items.map((item) {
                                            return _CartItemTile(
                                              thumbnailUrl:
                                                  item.product.thumbnail,
                                              name: item.product.name,
                                              unitPrice:
                                                  item.product.currentPrice,
                                              quantity: item.quantity,
                                              onRemove: () {
                                                context.read<CartBloc>().add(
                                                  CartItemRemoved(item.id),
                                                );
                                              },
                                            );
                                          }).toList(),

                                          const SizedBox(height: 24),

                                          // Subtotal
                                          _SubtotalSection(
                                            subtotal: state.subtotal,
                                          ),

                                          const SizedBox(height: 24),

                                          // Checkout Button
                                          _CheckoutButton(
                                            onPressed: () =>
                                                context.pushNamed('checkout'),
                                            enabled: state.items.isNotEmpty,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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

// Decorative icon moved to components/decorative_icon.dart
