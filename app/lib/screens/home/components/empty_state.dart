part of '../home_screen.dart';

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/empty.png', width: 240, height: 240),
        const SizedBox(height: 16),
        const Text(
          'Aucun évènement trouvé',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Ajustez votre recherche ou vos filtres',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
