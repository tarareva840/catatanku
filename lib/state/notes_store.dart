import 'package:flutter/foundation.dart';

import '../data/dummy_data.dart';
import '../models/note.dart';
import '../models/user_profile.dart';

class NotesStore extends ChangeNotifier {
  NotesStore._();

  static final NotesStore instance = NotesStore._();

  final List<Note> _notes = buildDummyNotes();
  int _nextId = 1000;

  UserProfile _profile = dummyProfile;
  bool _reminderOn = true;
  bool _lockOn = false;

  UserProfile get profile => _profile;
  bool get reminderOn => _reminderOn;
  bool get lockOn => _lockOn;

  List<Note> get notes {
    final active = _notes.where((note) => !note.archived).toList();
    active.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return b.date.compareTo(a.date);
    });
    return active;
  }

  List<Note> get archivedNotes {
    final archived = _notes.where((note) => note.archived).toList();
    archived.sort((a, b) => b.date.compareTo(a.date));
    return archived;
  }

  int get totalNotes => notes.length;

  int get pinnedCount => notes.where((note) => note.pinned).length;

  int get archivedCount => archivedNotes.length;

  Note? byId(int id) {
    for (final note in _notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  void add({
    required String title,
    required String content,
    required String category,
    required NoteColor color,
    required Priority priority,
  }) {
    _notes.add(
      Note(
        id: _nextId++,
        title: title,
        content: content,
        category: category,
        color: color,
        priority: priority,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void update(
    Note note, {
    required String title,
    required String content,
    required String category,
    required NoteColor color,
    required Priority priority,
  }) {
    note
      ..title = title
      ..content = content
      ..category = category
      ..color = color
      ..priority = priority;
    notifyListeners();
  }

  void togglePin(Note note) {
    note.pinned = !note.pinned;
    notifyListeners();
  }

  void toggleArchive(Note note) {
    note.archived = !note.archived;
    notifyListeners();
  }

  void toggleTask(Note note, int index) {
    final item = note.checklist[index];
    item.done = !item.done;
    notifyListeners();
  }

  void setColor(Note note, NoteColor color) {
    note.color = color;
    notifyListeners();
  }

  void remove(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  void updateProfile(UserProfile profile) {
    _profile = profile;
    notifyListeners();
  }

  void setReminder(bool value) {
    _reminderOn = value;
    notifyListeners();
  }

  void setLock(bool value) {
    _lockOn = value;
    notifyListeners();
  }
}
