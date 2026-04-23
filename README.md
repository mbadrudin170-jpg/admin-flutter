# **Aturan lainnya untuk AI**

### **1. Prinsip Utama: Interaksi dan Bahasa**

*   **1.1. Alur Kerja Berbasis Konfirmasi:** Sebelum melakukan tindakan modifikasi apa pun, AI **wajib** menyajikan rencana kerja yang terperinci kepada pengguna. Pekerjaan hanya dapat dilanjutkan setelah mendapatkan persetujuan eksplisit (misalnya, "setuju", "oke", "ok", "ya", "yes"). Jika pengguna menolak (misalnya, "jangan", "tidak", "nggk", "nggak"), AI harus membatalkan rencana tersebut dan menunggu arahan selanjutnya.
*   **1.2. Standar Bahasa Indonesia:** Seluruh komunikasi dengan pengguna, serta semua penamaan dalam kode (nama file, variabel, fungsi, parameter), harus konsisten menggunakan Bahasa Indonesia yang formal, baku, dan jelas.

### **2. Dokumentasi dan Manajemen Kode**

*   **2.1. Baca `README.md`:** Sebelum memulai tugas baru, AI wajib membaca file `README.md` terlebih dahulu untuk memahami konteks, alur kerja, dan status terakhir proyek.
*   **2.2. Komentar Kode Wajib:**
    *   **Path File:** Setiap file yang dimodifikasi harus mencantumkan path lengkapnya dalam bentuk komentar di baris paling atas. *Contoh:* `// path: lib/main.dart`.
    *   **Deskripsi Fungsi:** Setiap fungsi harus memiliki komentar deskriptif di atasnya yang menjelaskan tujuan dan cara kerjanya. *Contoh:* `// Fungsi untuk menavigasi pengguna ke halaman profil.`.
    *   **Logika Perubahan:** Setiap baris kode yang ditambah, diubah, atau dihapus harus disertai komentar di atas atau di sampingnya dengan struktur yang jelas: `// ditambah: [alasan penambahan]`, `// diubah: [alasan perubahan]`, atau `// dihapus: [alasan penghapusan]`.
    *   **Keterangan Tambahan:** Untuk logika atau alur kode yang kompleks, tambahkan komentar secukupnya untuk memastikan kode mudah dipahami oleh manusia.
*   **2.3. Pembaruan `README.md`:** Setelah menyelesaikan sebuah tugas, AI **wajib** memperbarui dokumentasi untuk file yang relevan di dalam `README.md`.
    *   Pembaruan harus mengikuti format yang ditentukan secara ketat.
    *   Hindari detail implementasi yang berlebihan atau catatan negatif (mis. "kode lama dihapus karena error").
    *   **Format Pembaruan:**
        ```
        **File:** `lib/path/nama_file.dart`
        **Fitur:** [Nama Fitur Utama yang Terkait dengan File]
        **Daftar Fungsi:**
        *   `namaFungsiA()`: Penjelasan singkat dan jelas mengenai kegunaan fungsi ini.
        *   `namaFungsiB()`: Penjelasan singkat dan jelas mengenai kegunaan fungsi ini.
        **Catatan:** [Informasi tambahan atau konteks penting jika diperlukan.]
        ```

### **3. Kualitas, Build, dan Konsistensi**

*   **3.1. Analisis Kode:** Setelah semua modifikasi kode selesai, jalankan perintah `flutter analyze` untuk memastikan tidak ada error atau *warning* yang tersisa.
*   **3.2. Proses Build Aplikasi:**
    *   Proses build **hanya** boleh dieksekusi atas perintah eksplisit dari pengguna.
    *   Sebelum memulai build, periksa `README.md` untuk mengidentifikasi apakah perubahan terakhir merupakan **fitur baru** atau hanya **perbaikan bug**.
    *   Jika hanya **perbaikan bug**, yang dinaikkan hanyalah nomor *build* di `pubspec.yaml` (misalnya, dari `1.0.0+1` menjadi `1.0.0+2`). Versi utama (`1.0.0`) tidak boleh diubah.
    *   Gunakan perintah berikut untuk proses build: `flutter clean && flutter pub get && flutter build apk --release --split-per-abi`.
*   **3.3. Perintah `clean`:** Jika pengguna memberikan perintah `clean`, jalankan `flutter clean && flutter pub get` di terminal.
*   **3.4. Hindari Asumsi:** AI tidak boleh membuat asumsi yang tidak berdasar atau "liar" yang dapat mengganggu sinkronisasi dan konsistensi antar file dalam proyek.
*   **3.5. Jaga Konsistensi:** AI harus selalu menjaga konsistensi dan kejelasan dalam struktur kode, penamaan, dan alur dokumentasi di seluruh proyek.
*   **3.6. Pola Asynchronous:** Setiap kali membuat fungsi yang melibatkan operasi I/O (misalnya, *network request* atau akses database), AI **wajib** menggunakan pola *Asynchronous* (`async`/`await`) dan membungkus hasilnya dalam objek `Future`. Hindari penggunaan metode `.then()` yang berantai untuk menjaga keterbacaan kode.

# **Dokumentasi Proyek Aplikasi Admin WiFi**

Selamat datang di dokumentasi resmi untuk proyek Aplikasi Admin WiFi. Dokumen ini berfungsi sebagai panduan utama untuk memahami arsitektur, fungsionalitas, dan alur kerja pengembangan aplikasi.
Analisis File: lib/utils/format/format_jam.dart
Tujuan Utama: Menjadi penyedia layanan tunggal (Single Source of Truth) untuk semua konformitas format waktu jam di aplikasi agar tampilan konsisten di seluruh halaman (UI).

Dependencies: package:intl/intl.dart (Wajib ada di pubspec.yaml).

1. Fitur & Fungsionalitas
Standardisasi 24 Jam: Memastikan semua waktu ditampilkan dalam format 24 jam (00:00 - 23:59).

Graceful Error Handling: Mencegah aplikasi berhenti tiba-tiba (crash) saat menerima data waktu yang korup atau tidak valid dari database SQLite atau Firestore.

Abstraksi Parsing: Menyederhanakan proses perubahan dari tipe data String (Database) ke String (Display) tanpa perlu melakukan DateTime.parse berulang kali di lapisan UI.

2. Dokumentasi Fungsi (API Reference)
static String formatKeJamMenit(DateTime waktu)

Input: Objek DateTime valid.

Output: String format "HH:mm".

Kegunaan: Digunakan pada kartu pelanggan (pelanggan aktif) untuk menunjukkan jam mulai koneksi.

static String formatKeJamLengkap(DateTime waktu)

Input: Objek DateTime valid.

Output: String format "HH:mm:ss".

Kegunaan: Digunakan pada sistem logging dan riwayat transaksi keuangan yang membutuhkan presisi tinggi hingga satuan detik.

static String formatTeksKeJam(String teksWaktu)

Input: String mentah (ISO 8601).

Logic: Menggunakan blok try-catch untuk membungkus DateTime.parse.

Output: String "HH:mm" atau fallback "--:--" jika gagal.

3. Aturan Ketat & Larangan (Constraint)
Hindari: Menggunakan DateFormat secara manual di file UI (.dart di folder halaman/). Semua harus memanggil kelas FormatJam.

Hindari: Memberikan nilai null pada parameter teksWaktu. Pastikan ada pengecekan awal atau gunakan fungsi formatTeksKeJam karena sudah memiliki proteksi error.

Peringatan Kode: Penggunaan format 'HH' (kapital) sangat krusial. Jangan diubah menjadi 'hh' (kecil) karena akan merusak logika sistem admin yang berbasis waktu 24 jam (menghindari kerancuan AM/PM pada transaksi malam hari).

4. Alur Kerja Kode (Pseudo-logic)
Teriman data (DateTime/String).

Lakukan validasi format melalui library intl.

Jika data tidak valid (pada fungsi teks), tangkap exception dan kembalikan nilai aman (--:--).

Kembalikan hasil transformasi ke pemanggil (UI/Model).

**File:** `lib/halaman/detail/detail_pelanggan_aktif.dart`
**Fitur:** Tampilan Detail Pelanggan Aktif
**Daftar Fungsi:**
*   `_loadDetails()`: Mengambil data detail pelanggan (nama, telepon) dan detail paket (nama paket) dari database secara asynchronous berdasarkan ID yang ada pada objek `PelangganAktif`.
*   `_navigateToEdit()`: Menavigasi pengguna ke halaman `FormPelangganAktif` untuk mengubah data. Setelah data berhasil diubah, fungsi ini akan memuat ulang detail untuk menampilkan informasi terbaru.
*   `_buildTeleponDisplay()`: Widget internal untuk menampilkan nomor telepon pelanggan. Menangani status `loading` dan kasus jika data tidak ditemukan.
*   `_buildPaketDisplay()`: Widget internal untuk menampilkan nama paket yang digunakan pelanggan. Menangani status `loading` dan kasus jika data tidak ditemukan.
**Catatan:** Halaman ini bertanggung jawab untuk menampilkan informasi lengkap dari seorang pelanggan yang sedang aktif berlangganan. Data diambil dari beberapa tabel (Pelanggan, Paket) dan digabungkan untuk ditampilkan.
