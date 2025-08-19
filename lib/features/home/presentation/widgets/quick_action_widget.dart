import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  final String title;
  final List<QuickAction> actions;

  const QuickActionsWidget({
    super.key,
    this.title = "Quick Actions",
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          /// Responsive Grid
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;

              // Dynamically set columns
              int crossAxisCount = 2;
              if (width > 900) {
                crossAxisCount = 4; // Desktop
              } else if (width > 600) {
                crossAxisCount = 3; // Tablet
              }

              // Adjust child aspect ratio based on width
              double aspectRatio = (width / crossAxisCount) / 120;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: actions.length,
                itemBuilder: (_, index) {
                  final action = actions[index];
                  return _ActionCard(action: action);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// --- Card UI ---
class _ActionCard extends StatelessWidget {
  final QuickAction action;
  const _ActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: action.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: action.color,
              radius: 20,
              child: Icon(action.icon, color: Colors.white, size: 20),
            ),
            const Spacer(),
            Text(
              action.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              action.subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  QuickAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
