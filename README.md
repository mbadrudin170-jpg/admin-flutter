# **Aturan lainnya untuk AI**

1. **Penggunaan Bahasa Indonesia**: Selalu gunakan bahasa Indonesia untuk penamaan fungsi, variabel, parameter, nama file, serta saat berkomunikasi dengan saya.

2. **Komentar Path File**: Selalu tambahkan komentar yang berisi path file di bagian paling atas pada setiap file yang dikerjakan. Contoh: `// path: lib/main.dart`

3. **Membaca README.md Sebelum Mengerjakan Proyek**: Sebelum mengerjakan proyek, AI diharapkan selalu membaca file `README.md` untuk memahami alur kerja proyek.

4. **Keterangan Fungsi dan Fitur Setelah Pengerjaan**: Ketika AI selesai mengerjakan tugas pada suatu file, tambahkan atau edit keterangan mengenai fungsi dan fitur yang ada di file tersebut. Tulis keterangan per file agar mudah saya ketahui.

5. **Aturan Sebelum Build**:
   - Baca dahulu file `README.md` untuk mengetahui apakah ada fitur baru atau hanya perbaikan bug.
   - Jika hanya perbaikan bug, maka yang dinaikkan hanya nomor build saja, jangan naikkan versi di `pubspec.yaml`.
   - Jalankan perintah: `flutter clean && flutter pub get && flutter build apk --release --split-per-abi`
   - Jangan melakukan build sebelum saya perintahkan.

6. **Konsistensi dan Kejelasan**: Selalu jaga konsistensi dan kejelasan dalam proyek saya.

7. **Pembaruan README.md Setelah Pengerjaan**: Setelah selesai mengerjakan tugas, edit isi file `README.md` berdasarkan file yang dikerjakan. Hindari mencantumkan contoh kode yang dapat menyebabkan error atau warning. Cukup tuliskan keterangan tujuan file, fitur, dan fungsi.

8. **Komentar Perubahan Kode**: Beri keterangan komentar di samping atau di atas kode yang diubah/ditambah dengan struktur:
   - `// dihapus: [alasan dihapus]`
   - `// diubah/ditambah: [alasan diubah/ditambah]`

9. **Menjalankan Flutter Analyze**: Setelah melakukan pekerjaan, jalankan `flutter analyze` di terminal untuk memastikan tidak ada error atau warning.

10. **Konfirmasi Sebelum Mengerjakan**: Sebelum mengerjakan tugas, berikan penjelasan mengenai apa yang akan dikerjakan. Saya akan mengonfirmasi dengan kata: `setuju`, `oke`, `ok`, `ya`, `yes` sebagai tanda izin. Jika saya menulis `jangan`, `tidak`, `nggk`, `nggak`, maka AI tidak boleh mengerjakan tugas tersebut.

11. **Komentar pada Setiap Fungsi**: Tambahkan keterangan di atas setiap fungsi yang menjelaskan alasan fungsi tersebut dibuat. Contoh: `// untuk menavigasi ke halaman A`

12. **Komentar Tambahan pada Kode**: Tambahkan komentar pada beberapa bagian kode di dalam file agar saya tidak bingung memahami alasan kode tersebut dibuat.

13. **Perintah Clean**: Jika saya memerintahkan `clean`, AI harus menjalankan `flutter clean && flutter pub get` di terminal.

14. **Larangan Asumsi Liar**: AI diharapkan tidak berasumsi liar agar semua file tetap sinkron.

15. **Pola Asynchronous untuk I/O, Network, Database**: Setiap kali membuat fungsi yang melibatkan I/O, network request, atau database, selalu gunakan pola asynchronous (`async/await`) dan bungkus hasilnya dalam objek `Future`. Hindari penggunaan `.then()` berantai.

16. **Format Pembaruan README.md**: Setelah pengerjaan file selesai, edit bagian dokumentasi file di `README.md` dan kelompokkan berdasarkan folder dengan format berikut:
    ```
    File: lib/path/nama_file.dart
    Fitur: [Nama Fitur]
    Daftar Fungsi:
    - namaFungsiA(): Penjelasan singkat kegunaan fungsi.
    - namaFungsiB(): Penjelasan singkat kegunaan fungsi.
    Catatan: [Informasi tambahan jika ada]
    Rules: [Aturan khusus seperti format tanggal, jam, dan angka yang wajib digunakan, merujuk ke file tertentu]
    ```

17. **Kritik dan Saran untuk Saya**: Setelah memperbarui isi file `README.md`, tambahkan kritik dan saran untuk saya agar proyek ini bisa lebih profesional, baik dari segi fitur, pengelolaan, efisiensi, dan lainnya. Tulis kritik dan saran tersebut di bawah aturan ini.

---

**Kritik dan Saran untuk Saya**:

1. **Dokumentasi Berkelanjutan**: Saran saya agar setiap kali menambahkan fitur baru, segera perbarui dokumentasi di `README.md` secara real-time, jangan menunggu akhir pengerjaan. Ini akan membantu pelacakan perubahan.

2. **Pengujian Otomatis**: Untuk meningkatkan profesionalisme, pertimbangkan menambahkan unit testing dan widget testing pada proyek. Ini akan meminimalkan bug saat build.

3. **Manajemen State**: Jika proyek sudah semakin kompleks, gunakan manajemen state yang terstruktur seperti Riverpod, Bloc, atau GetX untuk menjaga kode tetap bersih dan mudah di-maintain.

4. **Code Review Berkala**: Lakukan code review mandiri atau minta rekan kerja meninjau kode secara berkala untuk menjaga kualitas dan konsistensi.

5. **Versioning yang Jelas**: Tetapkan standar versioning (contoh: Semantic Versioning) agar perbedaan antara major, minor, dan patch lebih mudah dipahami.

6. **Logging dan Error Handling**: Tambahkan sistem logging yang baik untuk mencatat error atau aktivitas penting, serta tangani error dengan lebih elegan menggunakan `try-catch` dan feedback ke pengguna.

7. **Optimasi Build**: Untuk build APK, pertimbangkan membedakan mode `--debug` untuk pengujian internal dan `--release` untuk distribusi, serta gunakan `--obfuscate` jika diperlukan untuk keamanan.

---


# **Dokumentasi Proyek Aplikasi Admin WiFi**

Selamat datang di dokumentasi resmi untuk proyek Aplikasi Admin WiFi. Dokumen ini berfungsi sebagai panduan utama untuk memahami arsitektur, fungsionalitas, dan alur kerja pengembangan aplikasi.

---

**File:** `lib/utils/perhitungan_util.dart`
**Fitur:** Utilitas Perhitungan Umum
**Daftar Fungsi:**
*   `sisaHari(DateTime tanggalBerakhir)`: Menghitung selisih hari (bulat ke bawah) antara tanggal sekarang dan tanggal berakhir.
*   `getTeksSisaMasaAktif(DateTime tanggalBerakhir)`: Menghasilkan teks status masa aktif. Jika sudah lewat, menampilkan "Berakhir". Jika masih aktif, menampilkan sisa waktu dalam format hari, jam, atau menit (mis: "Sisa 5 hari", "Sisa 12 jam").
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

---

### File: `lib/halaman/lainnya/paket.dart`
**Fitur:** Manajemen Paket WiFi. Halaman ini bertanggung jawab untuk menampilkan daftar paket, serta menyediakan fungsionalitas untuk menambah, mengedit, dan menghapus paket.
**Daftar Fungsi:**
- `_refreshPaketList()`: Memuat ulang daftar paket dari database untuk memastikan data yang ditampilkan di UI selalu yang terbaru.
- `_showEditDeleteDialog(Paket paket)`: Menampilkan dialog kontekstual saat item paket ditekan lama, memberikan opsi untuk "Edit" atau "Hapus".
- `_showDeleteConfirmationDialog(Paket paket)`: Menampilkan dialog konfirmasi untuk mencegah penghapusan paket yang tidak disengaja.
- `_hapusSemuaPaket()`: Menangani logika untuk menghapus semua data paket dari database, dengan dialog konfirmasi sebelumnya.
**Catatan:** Halaman ini menggunakan `FutureBuilder` untuk menangani pemuatan data secara asinkron. Setiap operasi yang mengubah data (tambah, edit, hapus) akan memicu `_refreshPaketList()` untuk konsistensi data.
**Rules:** 
- Navigasi ke halaman pembuatan atau edit (`FormPaket`) harus memanggil `_refreshPaketList` setelah kembali untuk menampilkan data yang diperbarui.
- Penghapusan paket, baik tunggal maupun semua, harus selalu didahului oleh dialog konfirmasi untuk mencegah kehilangan data.
- Tampilan harga paket direkomendasikan untuk menggunakan `FormatUang.formatMataUang()` untuk konsistensi di seluruh aplikasi.

---

**File:** `lib/halaman/lainnya/riwayat_aktivasi_paket.dart`
**Fitur:** Manajemen Riwayat Aktivasi
**Daftar Fungsi:**
*   `_loadPelangganAktif()`: Memuat, mengurutkan, dan menampilkan semua data pelanggan yang pernah diaktifkan.
*   `_urutkanList(OpsiUrutkan pilihan)`: Menyediakan berbagai opsi untuk mengurutkan daftar riwayat (berdasarkan tanggal, nama, status, dll.).
*   `_hapusPelangganAktif(PelangganAktif pelanggan)`: Menangani logika untuk menghapus satu entri riwayat.
*   `_opsiHapus()`: Menampilkan dialog untuk menghapus data secara massal (semua atau yang sudah kadaluarsa).
*   `_tambahPelangganAktif()`: Menyediakan tombol navigasi untuk menambah data aktivasi baru.
*   `_periksaDanJadwalkanNotifikasi(...)`: Menangani penjadwalan notifikasi untuk paket yang akan berakhir (fungsionalitas bawaan dari "Pelanggan Aktif").
**Catatan:** Halaman ini merupakan duplikat fungsional dari "Pelanggan Aktif" dan ditempatkan di menu "Lainnya" untuk menyediakan akses penuh terhadap data riwayat, termasuk kemampuan untuk menambah, mengubah, dan menghapus data.
**Rules:** Karena merupakan salinan, semua aturan yang berlaku di `lib/halaman/tab/pelanggan_aktif.dart` juga berlaku di sini, terutama penggunaan `PerhitunganUtil` dan `FormatUtil` untuk konsistensi tampilan data. Setiap perubahan data harus diikuti dengan pemuatan ulang daftar.
