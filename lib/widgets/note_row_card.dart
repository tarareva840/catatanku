import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';

enum _RowAction { pin, archive, delete }

class NoteRowCard extends StatelessWidget {
  const NoteRowCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onPin,
    required this.onArchive,
    required this.onDelete,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  void _onSelected(_RowAction action) {
    switch (action) {
      case _RowAction.pin:
        onPin();
      case _RowAction.archive:
        onArchive();
      case _RowAction.delete:
        onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    final category = categoryOf(note.category);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: AppColors.line),
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: note.color.bg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(category.icon, color: category.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              note.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.subtitle,
                            ),
                          ),
                          if (note.pinned) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.push_pin_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: note.priority.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '${formatTanggal(note.date)} • ${note.category}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.caption,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<_RowAction>(
                  tooltip: 'Menu',
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.inkSoft,
                  ),
                  color: AppColors.surface,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onSelected: _onSelected,
                  itemBuilder: (_) => [
                    if (!note.archived)
                      PopupMenuItem(
                        value: _RowAction.pin,
                        child: Text(note.pinned ? 'Lepas sematan' : 'Sematkan'),
                      ),
                    PopupMenuItem(
                      value: _RowAction.archive,
                      child: Text(
                        note.archived ? 'Keluarkan dari arsip' : 'Arsipkan',
                      ),
                    ),
                    const PopupMenuItem(
                      value: _RowAction.delete,
                      child: Text(
                        'Hapus',
                        style: TextStyle(color: AppColors.danger),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
