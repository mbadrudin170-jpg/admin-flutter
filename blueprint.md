# Blueprint Proyek

Dokumen ini melacak arsitektur, fitur, dan rencana pengembangan untuk aplikasi Flutter ini.

## 1. Gambaran Umum

Aplikasi ini adalah dasbor sederhana yang dibuat dengan Flutter. Tujuan utamanya adalah untuk menampilkan data bisnis dalam antarmuka berbasis tab yang bersih. Saat ini, aplikasi menampilkan daftar "Pelanggan Aktif", "Pelanggan", "Paket", "Kategori", dan "Transaksi" dalam tab terpisah, dengan data yang sekarang dikelola dalam database SQLite lokal.

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
    *   **Database Helper**: File `lib/data/sqlite.dart` dibuat untuk mengelola instance database SQLite tunggal (pola Singleton).
    *   **Skema Tabel**: Tabel untuk `Kategori`, `SubKategori`, `Paket`, `Pelanggan`, `PelangganAktif`, dan `Transaksi` telah dibuat.
    *   **Operasi CRUD**: File operasi terpisah untuk setiap model (`kategori_operasi.dart`, `pelanggan_operasi.dart`, dll.) telah dibuat di `lib/data/operasi/` untuk menyediakan fungsi Create, Read, Update, dan Delete untuk setiap tabel.
*   **Fitur Pengguna**:
    *   **CRUD Pelanggan Aktif**: Tab "Home" menampilkan daftar pelanggan aktif.
    *   **CRUD Pelanggan**: Tab "Pelanggan" menampilkan daftar pelanggan.
    *   **CRUD Paket**: Tab "Paket" menampilkan daftar paket.
    *   **CRUD Kategori**: Tab "Kategori" menampilkan daftar kategori pemasukan dan pengeluaran.
    *   **CRUD Transaksi**: Tab "Transaksi" menampilkan daftar transaksi.
    *   **CRUD Dompet**:
        *   Tab "Dompet" menampilkan daftar dompet.
        *   Pengguna dapat membuat, melihat detail, mengedit, dan menghapus dompet.
        *   Model data `Dompet` (`model/dompet_model.dart`), halaman daftar (`lib/dompet.dart`), halaman detail (`lib/halaman/detail/detail_dompet.dart`), dan formulir (`lib/halaman/form/form_dompet.dart`) telah dibuat.
    *   **Pengalih Tema**: Tombol di AppBar memungkinkan pengguna beralih antara mode terang dan gelap.
    *   **Navigasi Tab**: Pengguna dapat beralih antara layar "Home", "Dompet", "Transaksi", dan "Lainnya" menggunakan `BottomNavigationBar`.
    *   **Utilitas Pemformatan**: Fungsi untuk memformat tanggal dan waktu telah dibuat di `lib/utils/format_tanggal.dart`.
    *   **Fokus Input pada Formulir**: Formulir di seluruh aplikasi sekarang mendukung perpindahan fokus otomatis.

## 3. Rencana yang harus kita kerjakan

1.  file lib/lainnya untuk membuat lsit tombol untuk menavigasi ke semua file yang ada di folder lib/halaman/lainnya dan tambahkan ikon di setiap tombol nya sesuai dengan halaman yang akan dituju nya.
2.  membuat file config untuk firebase de=an tempat kan file ini ke folder yang sesuai.
3.  buatkan file yang isinya berupa fungsi mengunduh data dari firebase ke sqlite beri nama file yang sesuai dengan isinya lalu tempatkan file ini ke folder yang sesuai juga.
4.  buatkan  file yang isinya berupa fungsi untuk mengirim data dari sqlite dan kasih nama yang sesuai dengan isi file nya lalu tempatkan file ini ke folder yang sesuai juga.
