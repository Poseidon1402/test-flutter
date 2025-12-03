import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/cart_bloc.dart';

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
            colors: [
              Color(0xFF0F1729),
              Color(0xFF1A1D2E),
              Color(0xFF2D1B4E),
            ],
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                                            ),
                                            borderRadius: BorderRadius.circular(10),
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
                                        padding: const EdgeInsets.symmetric(vertical: 40),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.shopping_cart_outlined,
                                              size: 80,
                                              color: Colors.white.withOpacity(0.3),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Your cart is empty',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white.withOpacity(0.7),
                                              ),
                                            ),
                                            const SizedBox(height: 32),
                                            ElevatedButton(
                                              onPressed: () => context.go('/'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF9D4EDD),
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 32,
                                                  vertical: 16,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
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
                                            return Container(
                                              margin: const EdgeInsets.only(bottom: 16),
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.white.withOpacity(0.2),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  // Product Image
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Container(
                                                      width: 60,
                                                      height: 60,
                                                      color: Colors.white.withOpacity(0.1),
                                                      child: Image.network(
                                                        item.product.thumbnail,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Icon(
                                                            Icons.image_not_supported,
                                                            color: Colors.white.withOpacity(0.3),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  
                                                  // Product Details
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item.product.name,
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          '${item.quantity} x €${item.product.currentPrice.toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white.withOpacity(0.7),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  
                                                  // Delete Button
                                                  IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<CartBloc>()
                                                          .add(CartItemRemoved(item.id));
                                                    },
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.white.withOpacity(0.7),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          
                                          const SizedBox(height: 24),
                                          
                                          // Subtotal
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 20,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.05),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Subtotal',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  '€${state.subtotal.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 24),
                                          
                                          // Checkout Button
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
                                                  color: const Color(0xFF9D4EDD).withOpacity(0.4),
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () => context.pushNamed('checkout'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: const Text(
                                                'Checkout',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
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

class _DecorativeIcon extends StatelessWidget {
  final IconData icon;
  final double rotation;
  final double opacity;
  final double size;

  const _DecorativeIcon({
    required this.icon,
    required this.rotation,
    required this.opacity,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(
        icon,
        size: size,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
