part of '../profile_screen.dart';

class _ProfileHeader extends StatelessWidget {
  final dynamic user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF9D4EDD), width: 4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9D4EDD).withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              'https://picsum.photos/200/200',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF2A2D3E),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF9D4EDD),
                    size: 60,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.email,
          style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}
