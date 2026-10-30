import 'package:flutter/material.dart';

class NoteCategory {
  const NoteCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;
}
