part of '../live_event_screen.dart';

class _TopNavigationBar extends StatelessWidget {
  final dynamic currentUser;
  final bool isLoggedIn;

  const _TopNavigationBar({
    required this.currentUser,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'LIVESHOP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, color: Colors.white),
          ),
          const SizedBox(width: 8),
          if (isLoggedIn)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://picsum.photos/seed/${currentUser?.id ?? "user"}/200',
              ),
            )
          else
            IconButton(
              onPressed: () => context.pushNamed('login'),
              icon: const Icon(Icons.person_outline, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
