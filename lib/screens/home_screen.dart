import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/live_events_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../models/live_event.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  void _showFilterBottomSheet(BuildContext context, LiveEventStatus? currentFilter) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Filter by Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _FilterOption(
                label: 'All',
                isSelected: currentFilter == null,
                onTap: () {
                  context.read<LiveEventsBloc>().add(
                    const LiveEventsFilterStatusChanged(null),
                  );
                  Navigator.pop(bottomSheetContext);
                },
              ),
              _FilterOption(
                label: 'Live',
                isSelected: currentFilter == LiveEventStatus.live,
                onTap: () {
                  context.read<LiveEventsBloc>().add(
                    const LiveEventsFilterStatusChanged(LiveEventStatus.live),
                  );
                  Navigator.pop(bottomSheetContext);
                },
              ),
              _FilterOption(
                label: 'Scheduled',
                isSelected: currentFilter == LiveEventStatus.scheduled,
                onTap: () {
                  context.read<LiveEventsBloc>().add(
                    const LiveEventsFilterStatusChanged(LiveEventStatus.scheduled),
                  );
                  Navigator.pop(bottomSheetContext);
                },
              ),
              _FilterOption(
                label: 'Ended',
                isSelected: currentFilter == LiveEventStatus.ended,
                onTap: () {
                  context.read<LiveEventsBloc>().add(
                    const LiveEventsFilterStatusChanged(LiveEventStatus.ended),
                  );
                  Navigator.pop(bottomSheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Shopping',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoggedIn = state.status == AuthStatus.authenticated;
              return IconButton(
                tooltip: isLoggedIn ? 'Profile' : 'Login',
                icon: Icon(isLoggedIn ? Icons.person : Icons.person_outline),
                onPressed: () {
                  if (isLoggedIn) {
                    context.go('/profile');
                  } else {
                    context.go('/login');
                  }
                },
              );
            },
          ),
          IconButton(
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
          ),
          IconButton(
            tooltip: 'Cart',
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              context.go('/cart');
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: BlocBuilder<LiveEventsBloc, LiveEventsState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            hintText: 'Search live events or products',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) {
                            context
                                .read<LiveEventsBloc>()
                                .add(LiveEventsSearchChanged(value));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Material(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            _showFilterBottomSheet(context, state.filterStatus);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.tune,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<LiveEventsBloc, LiveEventsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  if (state.events.isEmpty) {
                    return const Center(child: Text('No live events')); 
                  }

                  final query = state.searchQuery.toLowerCase();
                  final statusFilter = state.filterStatus;
                  final events = state.events.where((e) {
                    final matchesQuery = query.isEmpty ||
                        e.title.toLowerCase().contains(query) ||
                        e.sellerName.toLowerCase().contains(query);
                    final matchesStatus =
                        statusFilter == null || e.status == statusFilter;
                    return matchesQuery && matchesStatus;
                  }).toList();

                  if (events.isEmpty) {
                    return const Center(child: Text('No live events'));
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int crossAxisCount = 1;
                      double childAspectRatio = 0.75;
                      double spacing = 12;

                      if (width >= 1024) {
                        // Desktop: 3 columns
                        crossAxisCount = 3;
                        childAspectRatio = 0.80;
                        spacing = 16;
                      } else if (width >= 600) {
                        // Tablet: 2 columns
                        crossAxisCount = 2;
                        childAspectRatio = 0.78;
                        spacing = 14;
                      } else {
                        // Mobile: 1 column
                        crossAxisCount = 1;
                        childAspectRatio = 0.85;
                        spacing = 12;
                      }

                      return GridView.builder(
                        padding: EdgeInsets.all(spacing),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return _LiveEventCard(event: event);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveEventCard extends StatelessWidget {
  final LiveEvent event;

  const _LiveEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          context.go('/live/${event.id}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      event.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: event.status.name == 'live'
                            ? Colors.redAccent.withOpacity(0.9)
                            : colorScheme.surface.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            event.status.name == 'live'
                                ? Icons.circle
                                : Icons.schedule,
                            size: 10,
                            color: event.status.name == 'live'
                                ? Colors.white
                                : colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.status.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: event.status.name == 'live'
                                  ? Colors.white
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.remove_red_eye,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${event.viewerCount}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.sellerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (event.featuredProduct != null)
                        Text(
                          '${event.featuredProduct!.currentPrice.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                        ),
                      const Spacer(),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          context.go('/live/${event.id}');
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: const Text('Watch'),
                      ),
                    ],
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

class _FilterOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}
