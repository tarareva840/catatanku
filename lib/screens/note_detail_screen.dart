import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/dummy_data.dart';
import '../models/note.dart';
import '../state/notes_store.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';
import '../utils/responsive.dart';
import '../routes/app_routes.dart';
import '../widgets/color_dot.dart';
import '../widgets/note_actions.dart';

class NoteDetailScreen extends StatelessWidget {
  const NoteDetailScreen({super.key, required this.note});

  final Note note;

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(
      ClipboardData(text: '${note.title}\n\n${note.content}'),
    );
    messenger.showSnackBar(
      const SnackBar(content: Text('Catatan disalin ke papan klip.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = NotesStore.instance;
    final pad = pagePadding(context);

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final category = categoryOf(note.category);
        final words = note.content.trim().isEmpty
            ? 0
            : note.content.trim().split(RegExp(r'\s+')).length;

        return TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: note.color.bg),
          duration: const Duration(milliseconds: 250),
          builder: (context, color, child) {
            return Scaffold(backgroundColor: color, body: child);
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text('Detail Catatan'),
              leading: IconButton(
                tooltip: 'Kembali',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              actions: [
                IconButton(
                  tooltip: note.pinned ? 'Lepas sematan' : 'Sematkan',
                  onPressed: () => store.togglePin(note),
                  icon: Icon(
                    note.pinned
                        ? Icons.push_pin_rounded
                        : Icons.push_pin_outlined,
                  ),
                ),
                IconButton(
                  tooltip: 'Ubah',
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AppRoutes.add, arguments: note.id),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Hapus',
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final deleted = await confirmDeleteNote(context, note);
                    if (deleted) navigator.pop();
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: ListView(
                padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
                children: [
                  Text(
                    note.title,
                    style: AppText.display.copyWith(fontSize: 30),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Pill(
                        icon: category.icon,
                        iconColor: category.color,
                        text: category.name,
                      ),
                      _Pill(
                        icon: Icons.flag_rounded,
                        iconColor: note.priority.color,
                        text: 'Prioritas ${note.priority.label}',
                      ),
                      _Pill(
                        icon: Icons.calendar_today_rounded,
                        text: formatTanggal(note.date),
                      ),
                      _Pill(
                        icon: Icons.schedule_rounded,
                        text: formatJam(note.date),
                      ),
                    ],
                  ),
                  if (note.content.trim().isNotEmpty) ...[
                    const SizedBox(height: 22),
                    Text(
                      note.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                  if (note.checklist.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    _Checklist(note: note, store: store),
                  ],
                  const SizedBox(height: 26),
                  const Text('Warna catatan', style: AppText.label),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final option in NoteColor.palette)
                        ColorDot(
                          color: option,
                          selected: option == note.color,
                          onTap: () => store.setColor(note, option),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _copy(context),
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          label: const Text('Salin'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Fitur bagikan belum tersedia di versi ini.',
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.share_outlined, size: 18),
                          label: const Text('Bagikan'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      final navigator = Navigator.of(context);
                      toggleArchiveNote(context, note);
                      navigator.pop();
                    },
                    icon: Icon(
                      note.archived
                          ? Icons.unarchive_outlined
                          : Icons.archive_outlined,
                      size: 18,
                    ),
                    label: Text(
                      note.archived ? 'Keluarkan dari arsip' : 'Arsipkan',
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      '$words kata  •  Dibuat ${formatTanggal(note.date)}',
                      style: AppText.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text, this.iconColor});

  final IconData icon;
  final String text;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: iconColor ?? AppColors.inkSoft),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _Checklist extends StatelessWidget {
  const _Checklist({required this.note, required this.store});

  final Note note;
  final NotesStore store;

  @override
  Widget build(BuildContext context) {
    final total = note.checklist.length;
    final done = note.doneCount;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Text('Daftar tugas', style: AppText.label)),
              Text('$done/$total selesai', style: AppText.caption),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              minHeight: 6,
              backgroundColor: AppColors.line,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < total; i++)
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => store.toggleTask(note, i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Row(
                  children: [
                    Icon(
                      note.checklist[i].done
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 22,
                      color: note.checklist[i].done
                          ? AppColors.primary
                          : AppColors.inkSoft,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        note.checklist[i].text,
                        style: TextStyle(
                          fontSize: 15,
                          color: note.checklist[i].done
                              ? AppColors.inkSoft
                              : AppColors.ink,
                          decoration: note.checklist[i].done
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
