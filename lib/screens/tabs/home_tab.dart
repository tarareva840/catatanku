import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../models/note.dart';
import '../../routes/app_routes.dart';
import '../../state/notes_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/filter_chip_button.dart';
import '../../widgets/note_actions.dart';
import '../../widgets/note_masonry.dart';
import '../../widgets/note_row_card.dart';
import '../../widgets/user_avatar.dart';

/// Tab Beranda: sapaan, pencarian, filter kategori/prioritas, daftar catatan.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.onOpenProfile});

  final VoidCallback onOpenProfile;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  String _category = 'Semua';
  String _query = '';
  int _priorityFilter = -1; // -1 = semua prioritas
  bool _gridView = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Note> _filtered(NotesStore store) {
    final query = _query.trim().toLowerCase();
    return store.notes.where((note) {
      final matchCategory = _category == 'Semua' || note.category == _category;
      final matchPriority =
          _priorityFilter == -1 || note.priority.index == _priorityFilter;
      final matchQuery = query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
      return matchCategory && matchPriority && matchQuery;
    }).toList();
  }

  void _openDetail(Note note) {
    Navigator.of(context).pushNamed(AppRoutes.detail, arguments: note.id);
  }

  @override
  Widget build(BuildContext context) {
    final store = NotesStore.instance;
    final pad = pagePadding(context);
    final categories = ['Semua', ...dummyCategories.map((c) => c.name)];

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final notes = _filtered(store);
        final profile = store.profile;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 16, pad, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Halo,', style: AppText.body),
                        Text(
                          '${profile.name} 👋',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.display,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Apa yang ingin kamu catat hari ini?',
                          style: AppText.body,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onOpenProfile,
                    child: UserAvatar(initial: profile.initial, size: 48),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 18, pad, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                      decoration: InputDecoration(
                        hintText: 'Cari catatan...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _PriorityFilterButton(
                    value: _priorityFilter,
                    onSelected: (value) =>
                        setState(() => _priorityFilter = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: pad),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final name = categories[index];
                  return FilterChipButton(
                    label: name,
                    selected: name == _category,
                    onTap: () => setState(() => _category = name),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 8, pad - 8 < 0 ? 0 : pad - 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${notes.length} catatan', style: AppText.caption),
                  ),
                  IconButton(
                    tooltip: _gridView ? 'Tampilan daftar' : 'Tampilan grid',
                    onPressed: () => setState(() => _gridView = !_gridView),
                    icon: Icon(
                      _gridView
                          ? Icons.view_agenda_outlined
                          : Icons.grid_view_rounded,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: notes.isEmpty
                  ? const EmptyState(
                      icon: Icons.edit_note_rounded,
                      title: 'Catatan tidak ditemukan',
                      message:
                          'Coba kata kunci lain, ganti filter, atau tulis catatan baru dengan tombol +.',
                    )
                  : _gridView
                      ? SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(pad, 4, pad, 96),
                          child: NoteMasonry(
                            notes: notes,
                            onOpen: _openDetail,
                            onPin: store.togglePin,
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(pad, 4, pad, 96),
                          itemCount: notes.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, index) {
                            final note = notes[index];
                            return NoteRowCard(
                              note: note,
                              onTap: () => _openDetail(note),
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

class _PriorityFilterButton extends StatelessWidget {
  const _PriorityFilterButton({required this.value, required this.onSelected});

  final int value;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final active = value != -1;

    return PopupMenuButton<int>(
      tooltip: 'Filter prioritas',
      onSelected: onSelected,
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (_) => [
        const PopupMenuItem(value: -1, child: Text('Semua prioritas')),
        for (final priority in Priority.values)
          PopupMenuItem(
            value: priority.index,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: priority.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text('Prioritas ${priority.label}'),
              ],
            ),
          ),
      ],
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: active ? AppColors.primarySoft : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.line,
          ),
        ),
        child: Icon(
          Icons.tune_rounded,
          color: active ? AppColors.primary : AppColors.inkSoft,
        ),
      ),
    );
  }
}
