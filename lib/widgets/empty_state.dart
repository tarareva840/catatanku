import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.inkSoft),
            const SizedBox(height: 12),
            Text(title, style: AppText.subtitle),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center, style: AppText.body),
          ],
        ),
      ),
    );
  }
}
