# Blueprint Proyek: Admin Wifi

Dokumen ini adalah sumber kebenaran untuk arsitektur, fitur, dan desain aplikasi Admin Wifi.

## Gambaran Umum

Admin Wifi adalah aplikasi manajemen untuk penyedia layanan internet skala kecil. Aplikasi ini memungkinkan admin untuk mengelola data pelanggan, paket internet, pembayaran, dan langganan. Fitur utamanya adalah kemampuan untuk bekerja secara offline dan menyinkronkan data secara otomatis saat kembali online.

---

## Arsitektur Inti & Fitur

### 1. Desain Material 3 & Gaya Visual

- **Tema**: Menggunakan `ThemeData` Material 3 dengan `ColorScheme.fromSeed` berbasis warna `Colors.deepPurple`.
- **Tipografi**: Menggunakan font `Roboto` untuk konsistensi di seluruh aplikasi, dengan `TextTheme` yang terdefinisi untuk `displayLarge`, `titleLarge`, dan `bodyMedium`.
- **UI**: Antarmuka yang bersih, responsif, dan fungsional, dengan komponen standar seperti `AppBar`, `ElevatedButton`, dan `ListView`.

### 2. Manajemen Database & State

- **Database Lokal**: Menggunakan **SQLite** (`sqflite`) sebagai sumber kebenaran utama saat aplikasi berjalan (offline-first). Skema database didefinisikan dan dibuat oleh `DatabaseHelper`.
- **Database Jarak Jauh**: Menggunakan **Cloud Firestore** sebagai pencadangan dan untuk sinkronisasi antar perangkat.
- **Manajemen State**: Menggunakan pendekatan state lokal (`StatefulWidget`) untuk manajemen UI di masing-masing halaman.
- **Notifikasi**: Menggunakan `flutter_local_notifications` untuk menjadwalkan pengingat pembayaran dan menampilkan notifikasi penting.

### 3. Arsitektur Sinkronisasi Data (Hibrida) - **[DIRANCANG ULANG]**

Ini adalah fitur paling kompleks dan penting dari aplikasi. Layanan `SinkronisasiDatabase` bertindak sebagai orkestrator cerdas untuk menjaga data lokal (SQLite) dan jarak jauh (Firestore) tetap selaras.

**Pemicu Sinkronisasi:**
- **Saat Aplikasi Mulai**: Sinkronisasi penuh dijalankan saat aplikasi pertama kali dibuka.
- **Saat Konektivitas Berubah**: `connectivity_plus` mendeteksi kapan perangkat kembali online dan secara otomatis memicu proses sinkronisasi.

**Logika Sinkronisasi Hibrida:**

Sistem ini menggunakan dua strategi berbeda, tergantung pada jenis data:

#### a. Sinkronisasi Berbasis Status (`sync_status`)
- **Target**: Hanya untuk tabel `pelanggan_aktif`.
- **Cara Kerja**: Tabel ini memiliki kolom `sync_status` (`synced`, `write`, `deleted`).
- **Unggah Perubahan Lokal**:
  1. Ambil semua item dari `pelanggan_aktif` dengan status `write` (dibuat/diperbarui offline) atau `deleted` (dihapus offline).
  2. Kirim perubahan ini ke Firestore dalam satu *batch*:
     - `write` -> `batch.set()`
     - `deleted` -> `batch.delete()`
  3. Setelah *batch* berhasil, perbarui status lokal: item `write` menjadi `synced`, dan item `deleted` dihapus permanen dari SQLite.
- **Kelebihan**: Sangat kuat, dapat menangani pembuatan, pembaruan, dan **penghapusan** data saat offline dengan andal.

#### b. Sinkronisasi Berbasis Waktu (`timestamp`)
- **Target**: Untuk **semua tabel lain** (`kategori`, `dompet`, `pelanggan`, `paket`, `transaksi`, dll.).
- **Cara Kerja**: Semua tabel ini memiliki kolom `diperbarui` (timestamp).
- **Unggah Perubahan Lokal**:
  1. Ambil *timestamp* sinkronisasi terakhir yang berhasil dari `SharedPreferences`.
  2. Ambil semua item dari tabel-tabel ini di SQLite yang `diperbarui`-nya lebih baru dari *timestamp* tersebut.
  3. Unggah semua item yang berubah ke koleksi Firestore yang sesuai.
- **Unduh Perubahan Jarak Jauh**:
  1. Ambil *timestamp* sinkronisasi terakhir.
  2. Untuk **setiap koleksi** di Firestore, ambil semua dokumen yang `diperbarui`-nya lebih baru dari *timestamp* tersebut.
  3. Sisipkan atau perbarui (`insert or replace`) data yang diunduh ke dalam tabel SQLite yang benar.
- **Keterbatasan**: Tidak dapat menangani penghapusan data saat offline untuk tabel-tabel ini. Penghapusan harus terjadi saat online.

**Proses Gabungan:**
Setiap kali sinkronisasi berjalan, kedua logika (berbasis status dan waktu) dieksekusi secara berurutan untuk memastikan semua jenis data diperbarui dengan benar.

---

## Rencana Perubahan Saat Ini

- **Tugas**: Memperbarui dokumentasi proyek.
- **Status**: **Selesai**. Dokumen `blueprint.md` ini sekarang mencerminkan arsitektur sinkronisasi hibrida yang baru diimplementasikan.
