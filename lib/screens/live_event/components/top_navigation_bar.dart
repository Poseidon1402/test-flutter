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
          const Logo(),
          const Spacer(),
          // Cart Button
          const CartButton(),
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
