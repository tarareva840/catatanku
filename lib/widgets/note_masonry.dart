import 'package:flutter/material.dart';

import '../models/note.dart';
import 'note_card.dart';

/// Grid dua/tiga kolom dengan tinggi kartu yang berbeda-beda (masonry).
/// Kartu baru selalu ditaruh di kolom yang paling pendek.
class NoteMasonry extends StatelessWidget {
  const NoteMasonry({
    super.key,
    required this.notes,
    required this.onOpen,
    required this.onPin,
  });

  final List<Note> notes;
  final ValueChanged<Note> onOpen;
  final ValueChanged<Note> onPin;

  double _estimateHeight(Note note) {
    final double body;
    if (note.checklist.isNotEmpty) {
      final rows = note.checklist.length > 3 ? 3 : note.checklist.length;
      body = rows * 24.0 + 10;
    } else {
      final chars = note.content.length > 220 ? 220 : note.content.length;
      body = (chars / 30).ceil() * 19.0;
    }
    final titleExtra = note.title.length > 22 ? 20.0 : 0.0;
    return 90 + body + titleExtra;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 3 : 2;
        final heights = List<double>.filled(columns, 0);
        final buckets = List.generate(columns, (_) => <Widget>[]);

        for (final note in notes) {
          var target = 0;
          for (var i = 1; i < columns; i++) {
            if (heights[i] < heights[target]) target = i;
          }
          buckets[target].add(
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NoteCard(
                note: note,
                onTap: () => onOpen(note),
                onPin: () => onPin(note),
              ),
            ),
          );
          heights[target] += _estimateHeight(note) + 12;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < columns; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: Column(children: buckets[i])),
            ],
          ],
        );
      },
    );
  }
}
