# **Panduan Kontribusi dan Aturan Pengembangan**

Dokumen ini berisi serangkaian aturan dan panduan yang **wajib ditaati** oleh semua kontributor proyek untuk menjaga kualitas, konsistensi, dan kejelasan kode.

### **1. Prinsip Utama: Bahasa dan Alur Kerja**

*   **1.1. Alur Kerja Terstruktur:** Sebelum mengimplementasikan fitur atau perubahan besar, diskusikan rencana kerja terlebih dahulu dengan tim untuk memastikan keselarasan.
*   **1.2. Standar Bahasa Indonesia:** Gunakan Bahasa Indonesia yang baku, formal, dan jelas untuk seluruh penamaan di dalam proyek, termasuk **nama file, variabel, fungsi, dan parameter**, serta dalam semua dokumentasi dan komentar.

### **2. Standar Dokumentasi Kode**

*   **2.1. Wajib Baca `README.md`:** Sebelum memulai pekerjaan, setiap pengembang wajib membaca dan memahami isi dari file `README.md` ini untuk mengetahui status terbaru, arsitektur, dan aturan yang berlaku.
*   **2.2. Komentar Kode Informatif:**
    *   **Path File:** Setiap file **wajib** diawali dengan komentar yang menunjukkan path lengkapnya. *Contoh:* `// path: lib/main.dart`.
    *   **Deskripsi Fungsi:** Setiap fungsi **wajib** memiliki komentar di atasnya yang menjelaskan tujuannya secara singkat dan jelas. *Contoh:* `// untuk mengambil data pengguna dari server.`
    *   **Log Perubahan:** Setiap baris kode yang mengalami perubahan signifikan (ditambah, diubah, atau dihapus) harus disertai komentar di atasnya dengan struktur: `// ditambah: [alasan]`, `// diubah: [alasan]`, atau `// dihapus: [alasan]`.
    *   **Penjelasan Logika:** Untuk alur kode yang kompleks, tambahkan komentar secukupnya untuk membantu pengembang lain memahami logika tersebut.

### **3. Pembaruan Dokumentasi Proyek (`README.md`)**

*   **3.1. Tanggung Jawab Pembaruan:** Setelah menyelesaikan pekerjaan pada sebuah file, pengembang **wajib** memperbarui atau menambahkan dokumentasi file tersebut di bagian **"Dokumentasi Proyek Aplikasi Admin WiFi"** pada file `README.md` ini.
*   **3.2. Format Pembaruan (Wajib Diikuti):**
    ```
    **File:** `lib/path/lengkap/nama_file.dart`
    **Fitur:** [Jelaskan fitur utama yang dikelola oleh file ini, mis: Autentikasi Pengguna]
    **Daftar Fungsi:**
    *   `namaFungsiA()`: Penjelasan singkat dan jelas mengenai kegunaan fungsi ini.
    *   `namaFungsiB()`: Penjelasan singkat dan jelas mengenai kegunaan fungsi ini.
    **Catatan:** [Informasi tambahan yang relevan, seperti ketergantungan atau cara penggunaan khusus.]
    **Rules:** [Jelaskan aturan spesifik yang harus ditaati saat menggunakan file ini. Buat serinci mungkin. Contoh: "Untuk semua operasi tanggal dan waktu dalam file ini, wajib menggunakan format dari kelas `FormatTanggal` dan `FormatJam`. Dilarang melakukan format manual untuk menjaga konsistensi UI."]
    ```

### **4. Kualitas dan Pola Kode**

*   **4.1. Analisis Kode:** Sebelum menyelesaikan tugas (misalnya, *commit* atau *merge*), pastikan perintah `flutter analyze` berjalan tanpa menghasilkan **error** atau **warning**.
*   **4.2. Pola Asynchronous (`async`/`await`):** Untuk semua operasi yang bersifat I/O (seperti request HTTP, query database, atau akses file), **wajib** menggunakan pola `async`/`await` dan membungkus hasilnya dalam objek `Future`. Hindari penggunaan `.then()` yang berantai untuk menjaga keterbacaan kode.
*   **4.3. Konsistensi:** Jaga konsistensi gaya penulisan kode, penamaan, dan struktur folder. Hindari membuat asumsi yang dapat menyebabkan inkonsistensi pada proyek.

### **5. Manajemen Build dan Perintah Terminal**

*   **5.1. Alur Perintah Build:**
    *   Proses build rilis (`apk --release`) hanya boleh dijalankan atas arahan yang jelas, bukan untuk pengembangan sehari-hari.
    *   **Aturan Versioning:** Sebelum melakukan build rilis, periksa perubahan yang ada:
        *   Jika hanya berisi **perbaikan bug**, yang dinaikkan hanyalah nomor *build* di `pubspec.yaml` (misalnya, dari `1.0.0+1` menjadi `1.0.0+2`).
        *   Jika ada **fitur baru**, diskusikan dengan tim untuk menaikkan versi minor (misal, `1.1.0+3`).
    *   **Perintah Build Standar:** `flutter clean && flutter pub get && flutter build apk --release --split-per-abi`.
*   **5.2. Perintah `clean`:** Jika diminta untuk membersihkan proyek, jalankan `flutter clean && flutter pub get` di terminal.

# **Dokumentasi Proyek Aplikasi Admin WiFi**

Selamat datang di dokumentasi resmi untuk proyek Aplikasi Admin WiFi. Dokumen ini berfungsi sebagai panduan utama untuk memahami arsitektur, fungsionalitas, dan alur kerja pengembangan aplikasi.

---

**File:** `lib/utils/perhitungan_util.dart`
**Fitur:** Utilitas Perhitungan Umum
**Daftar Fungsi:**
*   `sisaHari(DateTime tanggalBerakhir)`: Menghitung selisih hari (bulat ke bawah) antara tanggal sekarang dan tanggal berakhir.
*   `getTeksSisaMasaAktif(DateTime tanggalBerakhir)`: Menghasilkan teks deskriptif yang dinamis mengenai sisa masa aktif. Logika ini memberikan detail hingga level jam dan menit jika sisa waktu kurang dari satu hari (misalnya, "Sisa 18 jam", "Kadaluarsa 5 menit yang lalu").
*   `getWarnaSisaMasaAktif(DateTime tanggalBerakhir)`: Memberikan `Color` yang sesuai dengan status masa aktif untuk isyarat visual di UI (hijau, kuning, merah).
**Catatan:** Kelas ini mengelompokkan fungsi kalkulasi terkait durasi dan status untuk digunakan di seluruh aplikasi.
**Rules:** Setiap kali perlu melakukan perhitungan atau mendapatkan representasi (teks/warna) dari sisa masa aktif, **wajib** menggunakan fungsi dari kelas ini. Jangan membuat logika perhitungan serupa di tempat lain untuk menghindari inkonsistensi.

---

**File:** `lib/utils/format_util.dart`
**Fitur:** Utilitas Pemformatan Data Terpusat
**Daftar Kelas dan Fungsi:**
*   `FormatTanggal`: Kumpulan fungsi statis untuk format tanggal.
*   `FormatJam`: Kumpulan fungsi statis untuk format jam.
*   `FormatUang`: Kumpulan fungsi statis untuk format mata uang Rupiah.
**Catatan:** File ini adalah satu-satunya sumber kebenaran (Single Source of Truth) untuk semua jenis pemformatan data yang ditampilkan kepada pengguna.
**Rules:** Semua tampilan data di UI yang berkaitan dengan **tanggal, jam, dan mata uang** **wajib** diformat menggunakan kelas-kelas yang ada di file ini. Dilarang keras melakukan pemformatan manual (misalnya, menggunakan `toString()` langsung pada `DateTime`) di file lain.

---

**File:** `lib/halaman/detail/detail_pelanggan_aktif.dart`
**Fitur:** Tampilan Detail Pelanggan Aktif
**Daftar Fungsi:**
*   `_loadDetails()`: Mengambil data gabungan dari beberapa tabel (pelanggan, paket) secara asinkron.
*   `_navigateToEdit()`: Menavigasi ke form edit dan memuat ulang data setelah kembali.
**Catatan:** Halaman ini bersifat *read-only* dan berfungsi sebagai ringkasan informasi seorang pelanggan aktif.
**Rules:** Halaman ini harus menerima objek `PelangganAktif` sebagai argumen. Untuk menampilkan sisa masa aktif dan format tanggal, **wajib** menggunakan utilitas dari `perhitungan_util.dart` dan `format_util.dart`.

---

**File:** `lib/halaman/tab/pelanggan_aktif.dart`
**Fitur:** Manajemen Daftar Pelanggan Aktif
**Daftar Fungsi:**
*   `_loadPelangganAktif()`: Memuat dan mengurutkan daftar pelanggan aktif.
*   `_hapusPelangganAktif(PelangganAktif pelanggan)`: Menangani logika penghapusan satu pelanggan.
*   `_urutkanList(OpsiUrutkan pilihan)`: Mengurutkan daftar berdasarkan kriteria yang dipilih.
*   `_periksaDanJadwalkanNotifikasi(...)`: Menangani penjadwalan notifikasi lokal untuk paket yang akan berakhir.
**Catatan:** Ini adalah halaman utama untuk manajemen pelanggan aktif, mencakup operasi CRUD (Create, Read, Update, Delete) melalui navigasi dan dialog.
**Rules:** Setiap operasi yang memodifikasi data (tambah, edit, hapus) harus memanggil `_loadPelangganAktif()` pada akhirnya untuk memastikan data yang ditampilkan selalu sinkron. Tampilan sisa masa aktif dan status **wajib** menggunakan `PerhitunganUtil`.

---

**File:** `lib/halaman/tab/transaksi.dart`
**Fitur:** Riwayat dan Ringkasan Transaksi
**Daftar Fungsi:**
*   `_loadTransaksi()`: Memuat semua data transaksi dari database.
*   `_groupTransaksiByDate(...)`: Mengelompokkan transaksi berdasarkan tanggal untuk tampilan.
*   `_bangunRingkasan(...)`: Menghitung dan menampilkan total pemasukan, pengeluaran, dan transfer.
**Catatan:** Halaman ini memberikan gambaran keuangan secara kronologis.
**Rules:** Pemformatan nominal uang pada ringkasan dan daftar transaksi **wajib** menggunakan `FormatUang.formatMataUang()` dari `format_util.dart`.

---

**File:** `lib/halaman/tab/dompet.dart`
**Fitur:** Manajemen Dompet Digital
**Daftar Fungsi:**
*   `_loadDompet()`: Mengambil daftar semua dompet dari database.
*   `_tambahDompet()`: Menavigasi ke halaman form untuk membuat dompet baru.
**Catatan:** Pusat untuk melihat semua sumber dana beserta saldo totalnya.
**Rules:** Pemformatan saldo dompet **wajib** menggunakan `FormatUang.formatMataUang()` dari `format_util.dart`.

---

**File:** `lib/halaman/lainnya/kritik_saran.dart`
**Fitur:** Tampilan Kritik dan Saran Pengguna
**Daftar Fungsi:**
*   `_loadKritikSaran()`: Memuat daftar semua kritik dan saran dari database.
**Catatan:** Halaman ini berfungsi untuk menampilkan masukan dari pengguna aplikasi.
**Rules:** Format tanggal dan waktu pengiriman kritik dan saran **wajib** menggunakan `FormatTanggal.formatTanggalDanJam()` dari `format_util.dart`.