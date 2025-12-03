part of '../cart_screen.dart';

class _CheckoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;

  const _CheckoutButton({required this.onPressed, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.06),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white.withOpacity(0.18), width: 1),
          ),
        ),
        onPressed: enabled ? onPressed : null,
        child: const Text(
          'Proceed to Checkout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
