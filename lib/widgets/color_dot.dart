import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';

class ColorDot extends StatelessWidget {
  const ColorDot({
    super.key,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final NoteColor color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: color.name,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.bg,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.ink : AppColors.line,
              width: selected ? 2 : 1,
            ),
          ),
          child: selected
              ? const Icon(Icons.check_rounded, size: 18, color: AppColors.ink)
              : null,
        ),
      ),
    );
  }
}
