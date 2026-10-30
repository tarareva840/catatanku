# CatatanKu

Aplikasi catatan sederhana berbasis Flutter. Output Fase 2: 100% slicing UI,
navigasi antar-halaman, dan data statis (dummy).

## Lima halaman wajib

| # | Halaman | Named route | File |
|---|---------|-------------|------|
| 1 | Splash Screen | `/` | `lib/screens/splash_screen.dart` |
| 2 | Login Statis | `/login` | `lib/screens/login_screen.dart` |
| 3 | Beranda | `/home` | `lib/screens/home_screen.dart` |
| 4 | Tambah Catatan | `/add` | `lib/screens/add_note_screen.dart` |
| 5 | Detail Catatan | `/detail` | `lib/screens/note_detail_screen.dart` |

Alur: Splash -> Login -> Beranda -> (Tambah Catatan / Detail Catatan).
Route didaftarkan di `lib/routes/app_routes.dart` dengan transisi fade/slide.

Beranda memiliki bottom navigation (Beranda, Arsip, Profil). Arsip dan Profil
adalah tab di dalam halaman Beranda (`lib/screens/tabs/`), bukan halaman baru.
Halaman Tambah Catatan juga dipakai untuk mengubah catatan (tombol pensil di Detail).

## Fitur

- Login: validasi email dan password, tampilkan/sembunyikan password (statis, tanpa server)
- Beranda: pencarian, filter kategori dan prioritas, tampilan daftar/grid, menu titik tiga
- Tambah Catatan: judul, isi, kategori (dropdown), warna, prioritas, validasi form
- Detail: ubah, hapus, sematkan, arsipkan, salin, ganti warna, centang daftar tugas
- Layout responsif untuk berbagai ukuran layar

## Data dummy

Semua data ada di `lib/data/dummy_data.dart` dan disimpan di memori oleh
`lib/state/notes_store.dart`. Belum ada API atau database.

## Menjalankan

```
flutter pub get
flutter run
```
