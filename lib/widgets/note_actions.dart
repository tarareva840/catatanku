import 'package:flutter/material.dart';

import '../models/note.dart';
import '../state/notes_store.dart';
import '../theme/app_theme.dart';

/// Dialog konfirmasi hapus. Mengembalikan true jika catatan jadi dihapus.
Future<bool> confirmDeleteNote(BuildContext context, Note note) async {
  final messenger = ScaffoldMessenger.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Hapus catatan?'),
      content: Text('Catatan "${note.title}" akan dihapus dari daftar.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Hapus', style: TextStyle(color: AppColors.danger)),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;

  NotesStore.instance.remove(note);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(const SnackBar(content: Text('Catatan dihapus.')));
  return true;
}

/// Arsipkan atau keluarkan dari arsip, lengkap dengan tombol Urungkan.
void toggleArchiveNote(BuildContext context, Note note) {
  final store = NotesStore.instance;
  final messenger = ScaffoldMessenger.of(context);
  final archiving = !note.archived;

  store.toggleArchive(note);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          archiving ? 'Catatan diarsipkan.' : 'Catatan dikeluarkan dari arsip.',
        ),
        action: SnackBarAction(
          label: 'Urungkan',
          textColor: AppColors.accent,
          onPressed: () => store.toggleArchive(note),
        ),
      ),
    );
}
