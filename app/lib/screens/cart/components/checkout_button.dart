part of '../cart_screen.dart';

class _CheckoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;

  const _CheckoutButton({required this.onPressed, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
    );

    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: enabled ? gradient : null,
        color: enabled ? null : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: const Color(0xFF9D4EDD).withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
        border: enabled
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1),
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Passer à la caisse',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
