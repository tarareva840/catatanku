import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/note.dart';
import '../state/notes_store.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/color_dot.dart';

/// Halaman 4: Tambah Catatan. Jika [note] diisi, halaman ini menjadi Ubah Catatan.
class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, this.note});

  final Note? note;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _content;
  String? _category;
  late NoteColor _color;
  late Priority _priority;

  bool get _editing => widget.note != null;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _title = TextEditingController(text: note?.title ?? '');
    _content = TextEditingController(text: note?.content ?? '');
    _category = note?.category;
    _color = note?.color ?? NoteColor.palette.first;
    _priority = note?.priority ?? Priority.sedang;
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final store = NotesStore.instance;
    final messenger = ScaffoldMessenger.of(context);
    final note = widget.note;

    if (note == null) {
      store.add(
        title: _title.text.trim(),
        content: _content.text.trim(),
        category: _category!,
        color: _color,
        priority: _priority,
      );
    } else {
      store.update(
        note,
        title: _title.text.trim(),
        content: _content.text.trim(),
        category: _category!,
        color: _color,
        priority: _priority,
      );
    }

    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(_editing ? 'Perubahan disimpan.' : 'Catatan disimpan.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = pagePadding(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_editing ? 'Ubah Catatan' : 'Tambah Catatan'),
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(pad, 8, pad, 28),
            children: [
              const _Label('Judul Catatan'),
              TextFormField(
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Masukkan judul catatan',
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Judul tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 18),
              const _Label('Isi Catatan'),
              TextFormField(
                controller: _content,
                minLines: 5,
                maxLines: 10,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Tulis catatan Anda di sini...',
                  alignLabelWithHint: true,
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Isi catatan tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 18),
              const _Label('Kategori'),
              DropdownButtonFormField<String>(
                initialValue: _category,
                isExpanded: true,
                borderRadius: BorderRadius.circular(16),
                dropdownColor: AppColors.surface,
                decoration: const InputDecoration(
                  hintText: 'Pilih kategori',
                  prefixIcon: Icon(Icons.label_outline_rounded),
                ),
                items: [
                  for (final category in dummyCategories)
                    DropdownMenuItem(
                      value: category.name,
                      child: Row(
                        children: [
                          Icon(category.icon, size: 18, color: category.color),
                          const SizedBox(width: 10),
                          Text(category.name),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _category = value),
                validator: (value) =>
                    value == null ? 'Pilih salah satu kategori' : null,
              ),
              const SizedBox(height: 18),
              const _Label('Warna'),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final color in NoteColor.palette)
                    ColorDot(
                      color: color,
                      selected: color == _color,
                      onTap: () => setState(() => _color = color),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              const _Label('Prioritas'),
              Row(
                children: [
                  for (var i = 0; i < Priority.values.length; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Expanded(
                      child: _PriorityOption(
                        priority: Priority.values[i],
                        selected: Priority.values[i] == _priority,
                        onTap: () =>
                            setState(() => _priority = Priority.values[i]),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 28),
              ElevatedButton(onPressed: _save, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppText.label),
    );
  }
}

class _PriorityOption extends StatelessWidget {
  const _PriorityOption({
    required this.priority,
    required this.selected,
    required this.onTap,
  });

  final Priority priority;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? priority.color : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? priority.color : AppColors.line,
          ),
        ),
        child: Text(
          priority.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
