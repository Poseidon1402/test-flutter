import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/live_events_bloc.dart';
import '../../blocs/auth_bloc.dart';
import '../../models/live_event.dart';

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
  String _dateFilter = 'All'; // All, Today, Tomorrow, This Week
  String _statusFilter = 'All'; // All, live, scheduled, ended
  String _categoryFilter = 'All'; // All, Fashion, Beauty, Electronics

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
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF9D4EDD),
                                    Color(0xFF7B2CBF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'LiveShop',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Cart Button
                        IconButton(
                          onPressed: () => context.go('/cart'),
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          tooltip: 'Cart',
                        ),
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
                                  'Profile',
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
                                'Login',
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
                                  'Discover Live Shopping\nEvents',
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
                                  'Find and join live streams for exclusive products, deals, and entertainment.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.7),
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
                                                  'Search for live events or products...',
                                              hintStyle: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.4,
                                                ),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: Colors.white.withOpacity(
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
                                          'All',
                                          'Today',
                                          'Tomorrow',
                                          'This Week',
                                        ],
                                        onChanged: (v) => setState(
                                          () => _dateFilter = v ?? 'All',
                                        ),
                                      ),
                                      _FilterChipDropdown(
                                        label: 'Status',
                                        value: _statusFilter,
                                        options: const [
                                          'All',
                                          'live',
                                          'scheduled',
                                          'ended',
                                        ],
                                        onChanged: (v) => setState(
                                          () => _statusFilter = v ?? 'All',
                                        ),
                                      ),
                                      _FilterChipDropdown(
                                        label: 'Category',
                                        value: _categoryFilter,
                                        options: const [
                                          'All',
                                          'Fashion',
                                          'Beauty',
                                          'Electronics',
                                        ],
                                        onChanged: (v) => setState(
                                          () => _categoryFilter = v ?? 'All',
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
                                      'Error: ${state.error}',
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
                                        title: 'Evènement en direct',
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
                                        title: 'Evènement à venir',
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
                                        title: 'Replays',
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

class _FilterChipDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _FilterChipDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(width: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: const Color(0xFF2A2D3E),
              style: const TextStyle(color: Colors.white),
              items: options
                  .map(
                    (o) => DropdownMenuItem<String>(value: o, child: Text(o)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
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
  if (status == 'All') return true;
  return e.status.name == status;
}

bool _matchesDate(LiveEvent e, String filter) {
  if (filter == 'All') return true;
  final now = DateTime.now();
  final start = e.startTime;
  final isSameDay =
      start.year == now.year &&
      start.month == now.month &&
      start.day == now.day;
  if (filter == 'Today') return isSameDay;
  final tomorrow = now.add(const Duration(days: 1));
  final isTomorrow =
      start.year == tomorrow.year &&
      start.month == tomorrow.month &&
      start.day == tomorrow.day;
  if (filter == 'Tomorrow') return isTomorrow;
  final weekFromNow = now.add(const Duration(days: 7));
  if (filter == 'This Week')
    return start.isAfter(now) && start.isBefore(weekFromNow);
  return true;
}

bool _matchesCategory(LiveEvent e, String filter) {
  if (filter == 'All') return true;
  final title = e.title.toLowerCase();
  switch (filter) {
    case 'Fashion':
      return title.contains('robe') ||
          title.contains('fashion') ||
          title.contains('style');
    case 'Beauty':
      return title.contains('beauty') ||
          title.contains('makeup') ||
          title.contains('soin');
    case 'Electronics':
      return title.contains('tech') ||
          title.contains('phone') ||
          title.contains('electronics');
  }
  return true;
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

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _EventGrid extends StatelessWidget {
  final List<LiveEvent> events;
  final LiveEventStatus status;

  const _EventGrid({required this.events, required this.status});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount = 1;

        if (width >= 1200) {
          crossAxisCount = 3;
        } else if (width >= 800) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: events.take(crossAxisCount).map((event) {
            return SizedBox(
              width: (width - (24 * (crossAxisCount - 1))) / crossAxisCount,
              child: _LiveEventCard(event: event, status: status),
            );
          }).toList(),
        );
      },
    );
  }
}

class _LiveEventCard extends StatelessWidget {
  final LiveEvent event;
  final LiveEventStatus status;

  const _LiveEventCard({required this.event, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Image with overlays (LIVE + viewers)
          _ImagePreview(
            status: status,
            thumbnailUrl: event.thumbnailUrl,
            viewerCount: event.viewerCount,
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hosted by ${event.sellerName.startsWith('@') ? event.sellerName : '@${event.sellerName}'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                if (status != LiveEventStatus.live)
                  Text(
                    _relativeTimeText(event, DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Hide price on live cards; show only for scheduled/ended
                    if (status != LiveEventStatus.live &&
                        event.featuredProduct != null)
                      Text(
                        '\$${event.featuredProduct!.currentPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9D4EDD),
                          fontFamily: 'Poppins',
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    _buildActionButton(context, status),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, LiveEventStatus status) {
    switch (status) {
      case LiveEventStatus.live:
        return ElevatedButton.icon(
          onPressed: () => context.go('/live/${event.id}'),
          icon: const Icon(Icons.play_arrow, size: 18),
          label: const Text('Watch'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9D4EDD),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: StadiumBorder(),
            elevation: 0,
          ),
        );
      case LiveEventStatus.scheduled:
        return ElevatedButton.icon(
          onPressed: () {
            // TODO: Implement notify me
          },
          icon: const Icon(Icons.notifications_outlined, size: 18),
          label: const Text('Notify Me'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A3D4E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: StadiumBorder(),
            elevation: 0,
          ),
        );
      case LiveEventStatus.ended:
        return ElevatedButton.icon(
          onPressed: () => context.go('/live/${event.id}'),
          icon: const Icon(Icons.replay, size: 18),
          label: const Text('Watch Replay'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A3D4E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: StadiumBorder(),
            elevation: 0,
          ),
        );
    }
  }

  String _relativeTimeText(LiveEvent event, DateTime now) {
    if (status == LiveEventStatus.scheduled) {
      final diff = event.startTime.difference(now);
      final hours = diff.inHours;
      final days = diff.inDays;
      if (diff.inMinutes <= 0) return 'Starts soon';
      if (hours < 24) {
        return 'Starts in ${hours}h';
      } else if (days == 1) {
        final hourLabel = '${event.startTime.hour}';
        return 'Starts Tomorrow ${hourLabel}AM';
      } else {
        return 'Starts ${days} days later';
      }
    } else if (status == LiveEventStatus.ended) {
      final end = event.endTime ?? event.startTime;
      final diff = now.difference(end);
      final days = diff.inDays;
      if (diff.inHours < 24) {
        return 'Ended ${diff.inHours} hours ago';
      }
      return 'Ended ${days} day${days > 1 ? 's' : ''} ago';
    }
    return '';
  }
}

class _ImagePreview extends StatelessWidget {
  final LiveEventStatus status;
  final String thumbnailUrl;
  final int viewerCount;

  const _ImagePreview({
    required this.status,
    required this.thumbnailUrl,
    required this.viewerCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF3A3D4E),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white30,
                    size: 48,
                  ),
                );
              },
            ),
          ),
        ),
        if (status == LiveEventStatus.live)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.remove_red_eye,
                  color: Colors.white70,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  viewerCount.toString(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
