# Blueprint Proyek

Dokumen ini melacak arsitektur, fitur, dan rencana pengembangan untuk aplikasi Flutter ini.

## 1. Gambaran Umum

Aplikasi ini adalah dasbor sederhana yang dibuat dengan Flutter. Tujuan utamanya adalah untuk menampilkan data bisnis dalam antarmuka berbasis tab yang bersih. Saat ini, aplikasi menampilkan daftar "Pelanggan Aktif", "Pelanggan", dan "Paket" dalam tab terpisah.

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
*   **Fitur Pengguna**:
    *   **CRUD Pelanggan Aktif**:
        *   Tab "Home" menampilkan daftar pelanggan aktif.
        *   Detail pelanggan dapat dilihat dengan mengetuk item daftar.
        *   Pelanggan baru dapat ditambahkan melalui `FloatingActionButton`.
    *   **CRUD Pelanggan**:
        *   Tab "Pelanggan" menampilkan daftar semua pelanggan dari data dummy.
        *   Model data `Pelanggan` (`model/pelanggan.dart`) dan data dummy (`data/pelanggan_data.dart`) telah dibuat.
        *   Halaman daftar (`lib/pelanggan.dart`), detail (`lib/detail_pelanggan.dart`), dan formulir (`lib/form_pelanggan.dart`) telah dibuat dan dihubungkan.
    *   **CRUD Paket**:
        *   Tab "Paket" menampilkan daftar paket yang tersedia.
        *   Detail paket dapat dilihat dan paket baru dapat ditambahkan.
    *   **Pengalih Tema**: Tombol di AppBar memungkinkan pengguna beralih antara mode terang dan gelap.
    *   **Navigasi Tab**: Pengguna dapat beralih antara layar "Home", "Pelanggan", "Paket", dan "Profile" menggunakan `BottomNavigationBar`.

## 3. Rencana Saat Ini

(Tidak ada rencana aktif saat ini.)
1. membuat file untuk menampilkan kategori dan sub kategori dan buat file baru lib/kategori.dart tambahkan dua tombol di atas dengan tipe pemasukan dan pengeluaran serta warna teks nya bedakan,  lalu buatkan file model dan datanya.
2. membbaut file lib/form_kategori.dart utnuk membuat kategori dan sub kategori baru berdasarkan tipe pengelauran dan pemasukan serta tambahkan tombol di lib/kategori.dart untuk menuju ke halaman ini.
3. membuat file lib/halaman/form/ untuk mengelompokan file berdasarkan nama filenya yang awalan form