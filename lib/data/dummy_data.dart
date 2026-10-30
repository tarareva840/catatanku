import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/note_category.dart';
import '../models/user_profile.dart';

/// Seluruh data pada aplikasi ini masih statis (dummy), tanpa API/database.

const List<NoteCategory> dummyCategories = [
  NoteCategory(
    name: 'Penting',
    icon: Icons.star_rounded,
    color: Color(0xFFE0A100),
  ),
  NoteCategory(
    name: 'Kuliah',
    icon: Icons.school_rounded,
    color: Color(0xFF3B7DDD),
  ),
  NoteCategory(
    name: 'Kerja',
    icon: Icons.work_rounded,
    color: Color(0xFFE07A3F),
  ),
  NoteCategory(
    name: 'Pribadi',
    icon: Icons.favorite_rounded,
    color: Color(0xFFD45B8A),
  ),
  NoteCategory(
    name: 'Ide',
    icon: Icons.lightbulb_rounded,
    color: Color(0xFF8A63D2),
  ),
];

NoteCategory categoryOf(String name) {
  return dummyCategories.firstWhere(
    (category) => category.name == name,
    orElse: () => dummyCategories.first,
  );
}

const UserProfile dummyProfile = UserProfile(
  name: 'Tara',
  email: 'tara@example.com',
  bio: 'Mahasiswa yang suka mencatat ide dan rencana.',
);

List<Note> buildDummyNotes() {
  return [
    Note(
      id: 1,
      title: 'Ide Aplikasi',
      content:
          'Ide untuk membuat aplikasi catatan sederhana dengan fitur '
          'kategori, warna, dan prioritas. Aplikasi ini digunakan untuk '
          'mencatat ide, rencana, dan hal penting sehari-hari.',
      category: 'Penting',
      color: NoteColor.palette[0],
      priority: Priority.sedang,
      date: DateTime(2026, 10, 19, 9, 30),
      pinned: true,
    ),
    Note(
      id: 2,
      title: 'Rencana Mingguan',
      content: 'Prioritas minggu ini sebelum akhir pekan.',
      category: 'Kerja',
      color: NoteColor.palette[1],
      priority: Priority.tinggi,
      date: DateTime(2026, 10, 18, 8, 15),
      pinned: true,
      checklist: [
        ChecklistItem('Kumpulkan laporan praktikum', done: true),
        ChecklistItem('Rapat kelompok proyek'),
        ChecklistItem('Latihan presentasi'),
        ChecklistItem('Rapikan slide'),
      ],
    ),
    Note(
      id: 3,
      title: 'Catatan Kuliah Basis Data',
      content:
          'Backup dibuat dengan mongodump, pemulihan dilakukan dengan '
          'mongorestore ke database yang berbeda agar data sumber tidak '
          'tertimpa.\n\nSetelah restore, bandingkan jumlah dokumen di kedua '
          'database untuk memastikan datanya utuh.',
      category: 'Kuliah',
      color: NoteColor.palette[4],
      priority: Priority.sedang,
      date: DateTime(2026, 10, 17, 14, 0),
    ),
    Note(
      id: 4,
      title: 'Hal yang Perlu Dibeli',
      content: 'Daftar belanja untuk akhir pekan.',
      category: 'Pribadi',
      color: NoteColor.palette[3],
      priority: Priority.rendah,
      date: DateTime(2026, 10, 16, 18, 45),
      checklist: [
        ChecklistItem('Beras'),
        ChecklistItem('Telur', done: true),
        ChecklistItem('Minyak goreng'),
        ChecklistItem('Sabun cuci'),
        ChecklistItem('Buah'),
      ],
    ),
    Note(
      id: 5,
      title: 'Jurnal Harian',
      content:
          'Hari ini selesai mengerjakan tugas praktikum lebih cepat dari '
          'perkiraan. Besok fokus merapikan laporan dan menyiapkan '
          'tangkapan layar.',
      category: 'Pribadi',
      color: NoteColor.palette[2],
      priority: Priority.rendah,
      date: DateTime(2026, 10, 15, 21, 10),
    ),
    Note(
      id: 6,
      title: 'Target Semester Ini',
      content:
          'Menjaga IPK di atas 3,5, ikut satu lomba, dan menyelesaikan '
          'proyek PBL tepat waktu.',
      category: 'Penting',
      color: NoteColor.palette[5],
      priority: Priority.tinggi,
      date: DateTime(2026, 10, 14, 7, 40),
    ),
    Note(
      id: 7,
      title: 'Rapat Kelompok PBL',
      content:
          'Pembagian tugas: satu orang merancang UI, satu orang menyusun '
          'data dummy, sisanya dokumentasi. Rapat berikutnya hari Rabu.',
      category: 'Kerja',
      color: NoteColor.palette[0],
      priority: Priority.sedang,
      date: DateTime(2026, 10, 13, 13, 20),
    ),
    Note(
      id: 8,
      title: 'Ide Konten Mingguan',
      content: 'Tips belajar Flutter, rekap tugas, dan review alat tulis.',
      category: 'Ide',
      color: NoteColor.palette[1],
      priority: Priority.rendah,
      date: DateTime(2026, 10, 12, 16, 5),
    ),
    Note(
      id: 9,
      title: 'Praktikum Jaringan Komputer',
      content:
          'Konfigurasi VLAN dan routing statis sudah selesai diuji. '
          'Laporan sudah dikumpulkan.',
      category: 'Kuliah',
      color: NoteColor.palette[5],
      priority: Priority.rendah,
      date: DateTime(2026, 9, 28, 10, 0),
      archived: true,
    ),
    Note(
      id: 10,
      title: 'Resep Percobaan',
      content: 'Nasi goreng telur: bawang putih, kecap manis, dan sedikit '
          'lada. Masak api sedang selama lima menit.',
      category: 'Pribadi',
      color: NoteColor.palette[3],
      priority: Priority.rendah,
      date: DateTime(2026, 9, 20, 19, 30),
      archived: true,
    ),
  ];
}
