part of '../home_screen.dart';

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
          children: events.map((event) {
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
