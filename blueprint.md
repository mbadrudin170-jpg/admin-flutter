# Blueprint Proyek

Dokumen ini melacak arsitektur, fitur, dan rencana pengembangan untuk aplikasi Flutter ini.

## 1. Gambaran Umum

Aplikasi ini adalah dasbor sederhana yang dibuat dengan Flutter. Tujuan utamanya adalah untuk menampilkan data bisnis dalam antarmuka berbasis tab yang bersih. Saat ini, aplikasi menampilkan daftar "Pelanggan Aktif", "Pelanggan", "Paket", "Kategori", dan "Transaksi" dalam tab terpisah.

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
        *   Halaman daftar (`lib/pelanggan.dart`), detail (`lib/halaman/detail/detail_pelanggan.dart`), dan formulir (`lib/halaman/form/form_pelanggan.dart`) telah dibuat dan dihubungkan.
    *   **CRUD Paket**:
        *   Tab "Paket" menampilkan daftar paket yang tersedia.
        *   Detail paket dapat dilihat dan paket baru dapat ditambahkan.
    *   **CRUD Kategori**:
        *   Tab "Kategori" menampilkan daftar kategori pemasukan dan pengeluaran.
        *   Pengguna dapat beralih antara tampilan pemasukan dan pengeluaran.
        *   Kategori dan subkategori baru dapat ditambahkan melalui formulir.
        *   Model data `Kategori` dan `SubKategori` (`model/kategori.dart`) dan data dummy (`data/kategori_data.dart`) telah dibuat.
        *   Halaman daftar (`lib/kategori.dart`) dan formulir (`lib/halaman/form/form_kategori.dart`) telah dibuat.
    *   **CRUD Transaksi**:
        *   Tab "Transaksi" menampilkan daftar transaksi yang dikelompokkan berdasarkan tanggal.
        *   Menampilkan ringkasan bulanan untuk pemasukan, pengeluaran, dan transfer.
        *   Detail transaksi dapat dilihat dan transaksi baru dapat ditambahkan.
        *   Model data `Transaksi` (`model/transaksi_model.dart`) dan data dummy (`data/transaksi_data.dart`) telah dibuat.
        *   Halaman daftar (`lib/transaksi.dart`), detail (`lib/halaman/detail/detail_transaksi.dart`), dan formulir (`lib/halaman/form/form_transaksi.dart`) telah dibuat.
    *   **Pengalih Tema**: Tombol di AppBar memungkinkan pengguna beralih antara mode terang dan gelap.
    *   **Navigasi Tab**: Pengguna dapat beralih antara layar "Home", "Pelanggan", "Kategori", "Transaksi", "Paket", dan "Profile" menggunakan `BottomNavigationBar`.
    *   **Utilitas Pemformatan**: Fungsi untuk memformat tanggal dan waktu telah dibuat di `lib/utils/format_tanggal.dart`.
    *   **Fokus Input pada Formulir**: Formulir di seluruh aplikasi sekarang mendukung perpindahan fokus otomatis. Menekan "Enter" pada `TextField` akan memindahkan fokus ke input berikutnya, dan keyboard akan ditutup setelah input terakhir.

## 3. Rencana yang harus kita kerjakan

(Tidak ada rencana aktif saat ini)
