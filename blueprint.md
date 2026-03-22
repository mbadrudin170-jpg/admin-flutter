# Blueprint Proyek

Dokumen ini melacak arsitektur, fitur, dan rencana pengembangan untuk aplikasi Flutter ini.

## 1. Gambaran Umum

Aplikasi ini adalah dasbor sederhana yang dibuat dengan Flutter. Tujuan utamanya adalah untuk menampilkan data bisnis dalam antarmuka berbasis tab yang bersih. Saat ini, aplikasi menampilkan data yang dikelola dalam database SQLite lokal dan **disinkronkan dengan Firebase** untuk pencadangan dan konsistensi data di seluruh perangkat.

## 2. Kerangka Proyek

Dokumentasi ini mencakup semua gaya, desain, dan fitur yang diimplementasikan dari versi awal hingga saat ini.

### Desain & Gaya

*   **Tema**: Aplikasi ini menggunakan prinsip-prinsip Material Design 3.
    *   **Skema Warna**: Dihasilkan dari `ColorScheme.fromSeed` dengan warna dasar biru (`Colors.blueAccent`).
    *   **Tipografi**: Menggunakan paket `google_fonts` untuk menyediakan font kustom yang konsisten.
*   **Struktur Visual**:
    *   **Navigasi**: Menggunakan `BottomNavigationBar` untuk navigasi utama antar layar.
    *   **Tata Letak**: Menggunakan `Scaffold`, `AppBar`, dan `ListView.builder` untuk struktur halaman dan daftar.

### Fitur yang Diimplementasikan

*   **Arsitektur Aplikasi**:
    *   **Manajemen Status**: Menggunakan `provider` untuk manajemen status tema.
    *   **Struktur Proyek**: Kode diatur berdasarkan fitur, termasuk direktori untuk `data`, `model`, dan halaman UI.
*   **Persistensi Data (SQLite)**:
    *   **Database Helper**: File `lib/data/sqlite.dart` mengelola instance database SQLite tunggal.
    *   **Operasi CRUD**: File operasi terpisah untuk setiap model (`kategori_operasi.dart`, dll.) menyediakan fungsi Create, Read, Update, dan Delete untuk setiap tabel.
*   **Integrasi Firebase & Sinkronisasi Data**:
    *   **Konfigurasi Proyek**: Proyek telah dikonfigurasi untuk menggunakan Firebase dengan dependensi `firebase_core` dan `cloud_firestore`.
    *   **Layanan Sinkronisasi**: Sebuah `FirebaseService` (`lib/data/servis/firebase_servis.dart`) telah dibuat untuk mengelola sinkronisasi data dua arah antara database SQLite lokal dan Firestore.
    *   **Logika Sinkronisasi**: Saat aplikasi dimulai, layanan secara otomatis:
        *   Memeriksa data di Firestore.
        *   Jika Firestore kosong, data dari SQLite akan diunggah.
        *   Jika Firestore memiliki data, data SQLite lokal akan dihapus dan diganti dengan data dari cloud untuk memastikan konsistensi.
    *   **Serialisasi Model**: Model data (`Kategori`) telah diperbarui dengan metode `toMap()` dan `fromMap()` untuk konversi data yang mulus antara objek Dart dan dokumen Firestore.
*   **Fitur Pengguna**:
    *   **CRUD Pelanggan Aktif**: Tab "Home" menampilkan daftar pelanggan aktif.
    *   **CRUD Pelanggan**: Tab "Pelanggan" menampilkan daftar pelanggan.
    *   **CRUD Paket**: Tab "Paket" menampilkan daftar paket.
    *   **CRUD Kategori**: Tab "Kategori" menampilkan daftar kategori pemasukan dan pengeluaran.
    *   **CRUD Transaksi**: Tab "Transaksi" menampilkan daftar transaksi.
    *   **CRUD Dompet**: Tab "Dompet" memungkinkan pengguna untuk membuat, melihat detail, mengedit, dan menghapus dompet.
    *   **Halaman "Lainnya"**: Halaman `lib/lainnya.dart` menyediakan antarmuka pengguna dengan tombol berikon untuk navigasi mudah ke berbagai layar manajemen.
    *   **Pengalih Tema**: Tombol di AppBar memungkinkan pengguna beralih antara mode terang dan gelap.
    *   **Navigasi Tab**: Pengguna dapat beralih antara layar "Home", "Dompet", "Transaksi", dan "Lainnya".
    *   **Utilitas Pemformatan**: Fungsi untuk memformat tanggal dan waktu tersedia di `lib/utils/format_tanggal.dart`.
    *   **Fokus Input pada Formulir**: Formulir di seluruh aplikasi mendukung perpindahan fokus otomatis.

## 3. Rencana Saat Ini

1.  **Menambahkan Tombol Kembali**: Menambahkan tombol kembali pada `AppBar` di semua file yang relevan di dalam folder `lib/halaman` untuk meningkatkan navigasi.

## 4. Tugas Selesai

Berdasarkan permintaan sebelumnya, fitur-fitur berikut telah berhasil diimplementasikan:

1.  **Navigasi Halaman "Lainnya"**: File `lib/lainnya.dart` telah dibuat dan diisi dengan tombol navigasi berikon.
2.  **Konfigurasi Firebase**: Proyek telah diinisialisasi untuk Firebase, dan file konfigurasi telah dibuat.
3.  **Sinkronisasi Data (Firebase & SQLite)**: Fungsi untuk mengunduh data dari Firebase ke SQLite dan mengunggah dari SQLite ke Firebase telah dibuat dalam file layanan terpusat (`firebase_servis.dart`). Sinkronisasi ini terjadi secara otomatis saat aplikasi dimulai.
