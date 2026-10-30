import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onPin,
    this.maxPreviewLines = 6,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final int maxPreviewLines;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    final category = categoryOf(note.category);

    return Material(
      color: note.color.bg,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        note.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.subtitle,
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onPin,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        note.pinned
                            ? Icons.push_pin_rounded
                            : Icons.push_pin_outlined,
                        size: 18,
                        color: note.pinned ? AppColors.ink : AppColors.inkSoft,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _Preview(note: note, maxLines: maxPreviewLines),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Row(
                  children: [
                    Icon(category.icon, size: 14, color: category.color),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption,
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: note.priority.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(formatSingkat(note.date), style: AppText.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.note, required this.maxLines});

  final Note note;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    if (note.checklist.isEmpty) {
      return Text(
        note.content,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 13,
          height: 1.45,
          color: AppColors.ink.withValues(alpha: 0.75),
        ),
      );
    }

    final shown = note.checklist.take(3).toList();
    final hidden = note.checklist.length - shown.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in shown)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  item.done
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  size: 16,
                  color: item.done ? AppColors.primary : AppColors.inkSoft,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: item.done ? AppColors.inkSoft : AppColors.ink,
                      decoration:
                          item.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (hidden > 0) Text('+$hidden lainnya', style: AppText.caption),
      ],
    );
  }
}
