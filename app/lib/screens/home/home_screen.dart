import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/live_events/live_events_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../shared_components/cart_button.dart';
import '../../shared_components/logo.dart';
import '../../models/live_event.dart';

part 'components/filter_chip_dropdown.dart';
part 'components/decorative_icon.dart';
part 'components/section_header.dart';
part 'components/event_grid.dart';
part 'components/live_event_card.dart';
part 'components/image_preview.dart';
part 'components/empty_state.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _dateFilter = 'Tous'; // Tous, Aujourd'hui, Demain, Cette semaine
  String _statusFilter = 'Tous'; // Tous, En direct, Programmé, Terminé
  String _categoryFilter = 'Tous'; // Tous, Mode, Beauté, Électronique

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
              top: size.height * 0.3,
              right: size.width * 0.05,
              child: _DecorativeIcon(
                icon: Icons.shopping_bag_outlined,
                rotation: 0.3,
                opacity: 0.04,
                size: 180,
              ),
            ),
            Positioned(
              bottom: size.height * 0.2,
              left: size.width * 0.1,
              child: _DecorativeIcon(
                icon: Icons.card_giftcard_outlined,
                rotation: 0.15,
                opacity: 0.03,
                size: 160,
              ),
            ),
            Positioned(
              bottom: size.height * 0.4,
              right: size.width * 0.15,
              child: _DecorativeIcon(
                icon: Icons.card_giftcard_outlined,
                rotation: -0.25,
                opacity: 0.035,
                size: 140,
              ),
            ),

            // Main scrollable content
            SafeArea(
              child: Column(
                children: [
                  // Top Navigation Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        // LiveShop Logo
                        const Logo(),
                        const Spacer(),

                        // Cart Button
                        const CartButton(),
                        const SizedBox(width: 8),

                        // Login Button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isLoggedIn =
                                state.status == AuthStatus.authenticated;

                            if (isLoggedIn) {
                              return TextButton(
                                onPressed: () => context.go('/profile'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Profil',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }

                            return TextButton(
                              onPressed: () => context.go('/login'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Connexion',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Hero Section
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 40,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Découvrez des évènements\nde live shopping',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.2,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Trouvez et rejoignez des diffusions en direct pour des produits exclusifs, des offres et du divertissement.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.7),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Search Bar
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 600,
                                  ),
                                  child:
                                      BlocBuilder<
                                        LiveEventsBloc,
                                        LiveEventsState
                                      >(
                                        builder: (context, state) {
                                          return TextField(
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Recherchez des évènements en direct ou des produits...',
                                              hintStyle: TextStyle(
                                                color: Colors.white.withValues(alpha: 
                                                  0.4,
                                                ),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: Colors.white.withValues(alpha: 
                                                  0.5,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: const Color(
                                                0xFF2A2D3E,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 16,
                                                  ),
                                            ),
                                            onChanged: (value) {
                                              context
                                                  .read<LiveEventsBloc>()
                                                  .add(
                                                    LiveEventsSearchChanged(
                                                      value,
                                                    ),
                                                  );
                                            },
                                          );
                                        },
                                      ),
                                ),

                                const SizedBox(height: 20),
                                // Filters Row
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 900,
                                  ),
                                  child: Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      _FilterChipDropdown(
                                        label: 'Date',
                                        value: _dateFilter,
                                        options: const [
                                          'Tous',
                                          'Aujourd\'hui',
                                          'Demain',
                                          'Cette semaine',
                                        ],
                                        onChanged: (v) => setState(
                                          () => _dateFilter = v ?? 'Tous',
                                        ),
                                      ),
                                      _FilterChipDropdown(
                                        label: 'Statut',
                                        value: _statusFilter,
                                        options: const [
                                          'Tous',
                                          'En direct',
                                          'Programmé',
                                          'Terminé',
                                        ],
                                        onChanged: (v) => setState(
                                          () => _statusFilter = v ?? 'Tous',
                                        ),
                                      ),
                                      _FilterChipDropdown(
                                        label: 'Catégorie',
                                        value: _categoryFilter,
                                        options: const [
                                          'Tous',
                                          'Mode',
                                          'Beauté',
                                          'Électronique',
                                        ],
                                        onChanged: (v) => setState(
                                          () => _categoryFilter = v ?? 'Tous',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Events Section
                          BlocBuilder<LiveEventsBloc, LiveEventsState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF9D4EDD),
                                    ),
                                  ),
                                );
                              }
                              if (state.error != null) {
                                return Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Center(
                                    child: Text(
                                      'Erreur : ${state.error}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final query = state.searchQuery.toLowerCase();
                              final allEvents = state.events
                                  .where((e) => _matchesSearch(e, query))
                                  .where(
                                    (e) => _matchesStatus(e, _statusFilter),
                                  )
                                  .where((e) => _matchesDate(e, _dateFilter))
                                  .where(
                                    (e) => _matchesCategory(e, _categoryFilter),
                                  )
                                  .toList();

                              final liveEvents = allEvents
                                  .where(
                                    (e) => e.status == LiveEventStatus.live,
                                  )
                                  .toList();
                              final scheduledEvents = allEvents
                                  .where(
                                    (e) =>
                                        e.status == LiveEventStatus.scheduled,
                                  )
                                  .toList();
                              final endedEvents = allEvents
                                  .where(
                                    (e) => e.status == LiveEventStatus.ended,
                                  )
                                  .toList();
                              if (allEvents.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 60,
                                  ),
                                  child: Center(child: _EmptyResults()),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  32,
                                  0,
                                  32,
                                  40,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (liveEvents.isNotEmpty) ...[
                                      _SectionHeader(
                                        icon: Icons.circle,
                                        iconColor: const Color(0xFFFF3B30),
                                        title: 'Événements en direct',
                                      ),
                                      const SizedBox(height: 16),
                                      _EventGrid(
                                        events: liveEvents,
                                        status: LiveEventStatus.live,
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                    if (scheduledEvents.isNotEmpty) ...[
                                      _SectionHeader(
                                        icon: Icons.calendar_today,
                                        iconColor: const Color(0xFF9D4EDD),
                                        title: 'Événements à venir',
                                      ),
                                      const SizedBox(height: 16),
                                      _EventGrid(
                                        events: scheduledEvents,
                                        status: LiveEventStatus.scheduled,
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                    if (endedEvents.isNotEmpty) ...[
                                      _SectionHeader(
                                        icon: Icons.access_time,
                                        iconColor: const Color(0xFF9D4EDD),
                                        title: 'Rediffusions',
                                      ),
                                      const SizedBox(height: 16),
                                      _EventGrid(
                                        events: endedEvents,
                                        status: LiveEventStatus.ended,
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool _matchesSearch(LiveEvent e, String query) {
  if (query.isEmpty) return true;
  return e.title.toLowerCase().contains(query) ||
      e.sellerName.toLowerCase().contains(query);
}

bool _matchesStatus(LiveEvent e, String status) {
  // Accept both English and French filter values
  if (status == 'All' || status == 'Tous') return true;
  switch (status) {
    case 'live':
    case 'En direct':
      return e.status == LiveEventStatus.live;
    case 'scheduled':
    case 'Programmé':
    case 'À venir':
      return e.status == LiveEventStatus.scheduled;
    case 'ended':
    case 'Terminé':
      return e.status == LiveEventStatus.ended;
  }
  return e.status.name == status;
}

bool _matchesDate(LiveEvent e, String filter) {
  if (filter == 'All' || filter == 'Tous') return true;
  final now = DateTime.now();
  final start = e.startTime;
  final isSameDay =
      start.year == now.year &&
      start.month == now.month &&
      start.day == now.day;
  if (filter == 'Today' || filter == "Aujourd'hui") return isSameDay;
  final tomorrow = now.add(const Duration(days: 1));
  final isTomorrow =
      start.year == tomorrow.year &&
      start.month == tomorrow.month &&
      start.day == tomorrow.day;
  if (filter == 'Tomorrow' || filter == 'Demain') return isTomorrow;
  final weekFromNow = now.add(const Duration(days: 7));
  if (filter == 'This Week' || filter == 'Cette semaine') {
    return start.isAfter(now) && start.isBefore(weekFromNow);
  }
  return true;
}

bool _matchesCategory(LiveEvent e, String filter) {
  if (filter == 'All' || filter == 'Tous') return true;
  final title = e.title.toLowerCase();
  switch (filter) {
    case 'Fashion':
    case 'Mode':
      return title.contains('robe') ||
          title.contains('fashion') ||
          title.contains('style') ||
          title.contains('mode');
    case 'Beauty':
    case 'Beauté':
      return title.contains('beauty') ||
          title.contains('makeup') ||
          title.contains('soin') ||
          title.contains('maquillage');
    case 'Electronics':
    case 'Électronique':
      return title.contains('tech') ||
          title.contains('phone') ||
          title.contains('electronics') ||
          title.contains('téléphone') ||
          title.contains('electronique');
  }
  return true;
}

// Component classes moved to part files under components/.
