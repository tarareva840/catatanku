import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../state/notes_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/note_actions.dart';
import '../../widgets/note_row_card.dart';

/// Tab Arsip: catatan yang disimpan di luar beranda.
class ArchiveTab extends StatelessWidget {
  const ArchiveTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = NotesStore.instance;
    final pad = pagePadding(context);

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final notes = store.archivedNotes;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 16, pad, 4),
              child: const Text('Arsip', style: AppText.display),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 0, pad, 16),
              child: const Text(
                'Catatan yang tidak ingin ditampilkan di beranda.',
                style: AppText.body,
              ),
            ),
            Expanded(
              child: notes.isEmpty
                  ? const EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'Arsip masih kosong',
                      message:
                          'Pilih Arsipkan pada menu catatan untuk menyimpannya di sini.',
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(pad, 0, pad, 24),
                      itemCount: notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, index) {
                        final note = notes[index];
                        return NoteRowCard(
                          note: note,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.detail,
                            arguments: note.id,
                          ),
                          onPin: () => store.togglePin(note),
                          onArchive: () => toggleArchiveNote(context, note),
                          onDelete: () => confirmDeleteNote(context, note),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
