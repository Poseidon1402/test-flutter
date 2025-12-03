part of '../checkout_screen.dart';

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
    widget.expiryController.addListener(_onExpiryChanged);
    widget.cvvController.addListener(_onCvvChanged);
  }

  @override
  void dispose() {
    widget.expiryController.removeListener(_onExpiryChanged);
    widget.cvvController.removeListener(_onCvvChanged);
    super.dispose();
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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16), // 16 digits
            CardNumberFormatter(),
          ],
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
    List<TextInputFormatter>? inputFormatters,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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
