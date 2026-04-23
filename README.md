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

---

**File:** `lib/utils/format/format_tanggal.dart`
**Fitur:** Utilitas Pemformatan Tanggal
**Daftar Fungsi:**
*   `formatTanggal(DateTime tanggal)`: Mengubah objek `DateTime` menjadi format tanggal yang mudah dibaca (contoh: "17 Agu 2024").
**Catatan:** Menggunakan `package:intl` untuk lokalisasi format tanggal ke gaya Indonesia ('id_ID').

---

**File:** `lib/utils/format/format_jam.dart`
**Fitur:** Utilitas Pemformatan Jam
**Daftar Fungsi:**
*   `formatKeJamMenit(DateTime waktu)`: Mengubah `DateTime` menjadi format "HH:mm".
*   `formatKeJamLengkap(DateTime waktu)`: Mengubah `DateTime` menjadi format "HH:mm:ss".
*   `formatTeksKeJam(String teksWaktu)`: Mengonversi string waktu (ISO 8601) menjadi format "HH:mm", dengan penanganan error jika format tidak valid.
**Catatan:** Menggunakan format 24 jam (`HH`) untuk menghindari ambiguitas AM/PM, yang krusial untuk logika transaksi.

---

**File:** `lib/halaman/detail/detail_pelanggan_aktif.dart`
**Fitur:** Tampilan Detail Pelanggan Aktif
**Daftar Fungsi:**
*   `_loadDetails()`: Mengambil data detail pelanggan (nama, telepon) dan detail paket (nama paket) dari database secara asynchronous.
*   `_navigateToEdit()`: Menavigasi pengguna ke halaman `FormPelangganAktif` untuk mengubah data, lalu memuat ulang detail setelah kembali.
*   `_buildTeleponDisplay()`: Widget internal untuk menampilkan nomor telepon pelanggan, dengan penanganan status loading.
*   `_buildPaketDisplay()`: Widget internal untuk menampilkan nama paket, dengan penanganan status loading.
**Catatan:** Halaman ini menggabungkan dan menampilkan informasi dari beberapa tabel (Pelanggan, Paket) untuk satu pelanggan aktif.

---

**File:** `lib/halaman/tab/pelanggan_aktif.dart`
**Fitur:** Daftar Pelanggan Aktif
**Daftar Fungsi:**
*   `_loadPelangganAktif()`: Memuat daftar pelanggan aktif dari database lokal.
*   `_hapusPelangganAktif(PelangganAktif pelanggan)`: Menghapus satu pelanggan aktif setelah konfirmasi.
*   `_urutkanList(OpsiUrutkan pilihan)`: Mengurutkan daftar pelanggan berdasarkan kriteria yang dipilih (tanggal, nama, status).
*   `_showUrutkanDialog()`: Menampilkan dialog untuk memilih opsi pengurutan.
*   `_tambahPelangganAktif()`: Menavigasi ke halaman form untuk menambah pelanggan baru.
*   `_opsiHapus()`: Menampilkan dialog untuk opsi hapus massal (semua atau yang sudah kadaluarsa).
*   `_periksaDanJadwalkanNotifikasi(List<PelangganAktif> pelanggan)`: Menjadwalkan notifikasi lokal untuk paket yang akan berakhir.
**Catatan:** Halaman utama untuk manajemen pelanggan, termasuk notifikasi, pengurutan, dan penghapusan.

---

**File:** `lib/halaman/tab/transaksi.dart`
**Fitur:** Daftar dan Ringkasan Transaksi
**Daftar Fungsi:**
*   `_loadTransaksi()`: Memuat semua data transaksi dari database.
*   `_tambahTransaksi()`: Menavigasi ke halaman form untuk menambah transaksi baru.
*   `_groupTransaksiByDate(List<Transaksi> transaksi)`: Mengelompokkan daftar transaksi berdasarkan tanggal.
*   `_bangunRingkasan(...)`: Membangun widget ringkasan total pemasukan, pengeluaran, dan transfer.
*   `_bangunItemTransaksi(Transaksi transaksi)`: Membangun satu item UI untuk setiap transaksi.
**Catatan:** Menampilkan riwayat keuangan lengkap yang dikelompokkan per hari.

---

**File:** `lib/halaman/tab/dompet.dart`
**Fitur:** Manajemen Dompet
**Daftar Fungsi:**
*   `_loadDompet()`: Mengambil daftar semua dompet dari database.
*   `_tambahDompet()`: Menavigasi ke halaman form untuk membuat dompet baru.
**Catatan:** Pusat untuk melihat semua dompet beserta saldonya dan ringkasan keuangan dasar.

---

**File:** `lib/halaman/lainnya/kritik_saran.dart`
**Fitur:** Menampilkan Kritik dan Saran
**Daftar Fungsi:**
*   `_loadKritikSaran()`: Memuat daftar kritik dan saran dari database.
**Catatan:** Halaman untuk menampilkan semua masukan dari pengguna.

