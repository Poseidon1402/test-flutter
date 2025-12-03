import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/cart_bloc.dart';

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

class _ShippingDetailsSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController zipController;

  const _ShippingDetailsSection({
    required this.nameController,
    required this.addressController,
    required this.cityController,
    required this.zipController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        _buildLabel('Full name'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: nameController,
          hint: 'Enter your full name',
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 20),

        _buildLabel('Address'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: addressController,
          hint: 'Enter your address',
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('City'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: cityController,
                    hint: 'Enter your city',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('ZIP code'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: zipController,
                    hint: 'Enter ZIP code',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(fontSize: 16, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 16,
        ),
        filled: true,
        fillColor: const Color(0xFF2A2D3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF9D4EDD), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF87171), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF87171), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }
}

class _CardForm extends StatefulWidget {
  final TextEditingController cardNameController;
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final ValueChanged<bool> onNumberValid;
  final ValueChanged<bool> onExpiryValid;
  final ValueChanged<bool> onCvvValid;

  const _CardForm({
    required this.cardNameController,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.onNumberValid,
    required this.onExpiryValid,
    required this.onCvvValid,
  });

  @override
  State<_CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<_CardForm> {
  String? _brand;

  @override
  void initState() {
    super.initState();
    widget.cardNumberController.addListener(_onNumberChanged);
    widget.expiryController.addListener(_onExpiryChanged);
    widget.cvvController.addListener(_onCvvChanged);
  }

  @override
  void dispose() {
    widget.cardNumberController.removeListener(_onNumberChanged);
    widget.expiryController.removeListener(_onExpiryChanged);
    widget.cvvController.removeListener(_onCvvChanged);
    super.dispose();
  }

  void _onNumberChanged() {
    final raw = widget.cardNumberController.text.replaceAll(RegExp(r'\s+'), '');
    final valid = _luhnValid(raw) && raw.length >= 13 && raw.length <= 19;
    widget.onNumberValid(valid);
    setState(() {
      _brand = _detectBrand(raw);
      // format spacing: 4-4-4-4
      final formatted = raw.replaceAll(RegExp(r'[^0-9]'), '');
      final chunks = <String>[];
      for (var i = 0; i < formatted.length; i += 4) {
        chunks.add(
          formatted.substring(
            i,
            i + 4 > formatted.length ? formatted.length : i + 4,
          ),
        );
      }
      final caret = widget.cardNumberController.selection;
      widget.cardNumberController.value = TextEditingValue(
        text: chunks.join(' '),
        selection: caret,
      );
    });
  }

  void _onExpiryChanged() {
    final text = widget.expiryController.text.replaceAll(
      RegExp(r'[^0-9/]'),
      '',
    );
    // Auto-insert slash after MM
    var cleaned = text;
    if (cleaned.length == 2 && !cleaned.contains('/')) {
      cleaned = '$cleaned/';
    }
    if (cleaned != widget.expiryController.text) {
      final caret = widget.expiryController.selection;
      widget.expiryController.value = TextEditingValue(
        text: cleaned,
        selection: caret,
      );
    }
    final valid = _expiryValid(cleaned);
    widget.onExpiryValid(valid);
  }

  void _onCvvChanged() {
    final raw = widget.cvvController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final maxLen = (_brand == 'AMEX') ? 4 : 3;
    final truncated = raw.length > maxLen ? raw.substring(0, maxLen) : raw;
    if (truncated != widget.cvvController.text) {
      final caret = widget.cvvController.selection;
      widget.cvvController.value = TextEditingValue(
        text: truncated,
        selection: caret,
      );
    }
    widget.onCvvValid(truncated.length == maxLen);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Name on card'),
        const SizedBox(height: 8),
        _field(
          controller: widget.cardNameController,
          hint: 'Full name',
          keyboardType: TextInputType.name,
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 16),

        _label('Card number'),
        const SizedBox(height: 8),
        _field(
          controller: widget.cardNumberController,
          hint: '1234 5678 9012 3456',
          keyboardType: TextInputType.number,
          validator: (v) {
            final raw = (v ?? '').replaceAll(RegExp(r'\s+'), '');
            if (raw.isEmpty) return 'Required';
            if (!_luhnValid(raw) || raw.length < 13 || raw.length > 19)
              return 'Invalid card number';
            return null;
          },
          suffix: _brand != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF6C5CE7).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _brand!,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Expiry (MM/YY)'),
                  const SizedBox(height: 8),
                  _field(
                    controller: widget.expiryController,
                    hint: 'MM/YY',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        _expiryValid(v ?? '') ? null : 'Invalid expiry',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('CVV'),
                  const SizedBox(height: 8),
                  _field(
                    controller: widget.cvvController,
                    hint: '123',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final raw = (v ?? '').replaceAll(RegExp(r'[^0-9]'), '');
                      final maxLen = (_brand == 'AMEX') ? 4 : 3;
                      return raw.length == maxLen ? null : 'Invalid CVV';
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Styled label
  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }

  // Styled text field with glassmorphic visuals and real-time feedback
  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 16,
        ),
        filled: true,
        fillColor: const Color(0xFF2A2D3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFFF87171), width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFFF87171), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: suffix,
      ),
    );
  }

  // Luhn algorithm
  bool _luhnValid(String number) {
    if (number.isEmpty || number.contains(RegExp(r'[^0-9]'))) return false;
    var sum = 0;
    var alt = false;
    for (var i = number.length - 1; i >= 0; i--) {
      var n = int.parse(number[i]);
      if (alt) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alt = !alt;
    }
    return sum % 10 == 0;
  }

  String? _detectBrand(String number) {
    if (number.startsWith('4')) return 'VISA';
    if (number.startsWith(RegExp(r'5[1-5]'))) return 'Mastercard';
    if (number.startsWith(RegExp(r'3[47]'))) return 'AMEX';
    if (number.startsWith('6')) return 'Discover';
    return null;
  }

  bool _expiryValid(String text) {
    final match = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').firstMatch(text);
    if (match == null) return false;
    final month = int.parse(match.group(1)!);
    final year = int.parse(match.group(2)!);
    final now = DateTime.now();
    final fourDigitYear = 2000 + year;
    final lastDay = DateTime(fourDigitYear, month + 1, 0);
    return lastDay.isAfter(DateTime(now.year, now.month, now.day));
  }
}

class _OrderSummarySection extends StatelessWidget {
  final CartState cartState;

  const _OrderSummarySection({required this.cartState});

  @override
  Widget build(BuildContext context) {
    const shippingCost = 5.00;
    final total = cartState.subtotal + shippingCost;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order summary',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Product items
          ...cartState.items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  // Product image
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

                  // Product details
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
                          maxLines: 2,
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

                  // Price
                  Text(
                    '€${(item.product.currentPrice * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              Text(
                '€${cartState.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Shipping
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              Text(
                '€${shippingCost.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '€${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 48),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Order confirmed',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your order has been placed successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
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
      child: Icon(icon, size: size, color: Colors.white.withOpacity(opacity)),
    );
  }
}
