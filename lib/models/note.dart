import 'package:flutter/material.dart';

/// Warna latar kartu catatan (mirip pilihan warna di Google Keep).
class NoteColor {
  const NoteColor({required this.name, required this.bg});

  final String name;
  final Color bg;

  static const List<NoteColor> palette = [
    NoteColor(name: 'Kuning', bg: Color(0xFFFFF3BF)),
    NoteColor(name: 'Mint', bg: Color(0xFFD9F2E3)),
    NoteColor(name: 'Biru', bg: Color(0xFFDCEBFA)),
    NoteColor(name: 'Persik', bg: Color(0xFFFFE2D6)),
    NoteColor(name: 'Lavender', bg: Color(0xFFE9E1FB)),
    NoteColor(name: 'Netral', bg: Color(0xFFF0ECE4)),
  ];
}

enum Priority {
  rendah('Rendah', Color(0xFF2E9E6B)),
  sedang('Sedang', Color(0xFF3B7DDD)),
  tinggi('Tinggi', Color(0xFFC8473B));

  const Priority(this.label, this.color);

  final String label;
  final Color color;
}

/// Satu butir tugas pada catatan berbentuk daftar centang.
class ChecklistItem {
  ChecklistItem(this.text, {this.done = false});

  final String text;
  bool done;
}

class Note {
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.color,
    required this.date,
    this.priority = Priority.sedang,
    this.pinned = false,
    this.archived = false,
    List<ChecklistItem>? checklist,
  }) : checklist = checklist ?? <ChecklistItem>[];

  final int id;
  String title;
  String content;
  String category;
  NoteColor color;
  Priority priority;
  DateTime date;
  bool pinned;
  bool archived;
  final List<ChecklistItem> checklist;

  int get doneCount => checklist.where((item) => item.done).length;

  /// Ringkasan satu baris untuk tampilan daftar.
  String get preview {
    if (checklist.isNotEmpty) {
      return '$doneCount dari ${checklist.length} tugas selesai';
    }
    return content.replaceAll('\n', ' ');
  }
}
