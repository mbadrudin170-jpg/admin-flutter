# **Aturan lainnya untuk AI**

1.  **Konsistensi Bahasa**: Seluruh penamaan dalam proyek, termasuk fungsi, variabel, parameter, dan nama file, wajib menggunakan Bahasa Indonesia. Komunikasi antara AI dan pengembang juga harus dilakukan dalam Bahasa Indonesia.

2.  **Pemberian Komentar Path File**: Pada bagian paling atas dari setiap file kode, wajib ditambahkan komentar yang menunjukkan path atau lokasi file tersebut. Format komentar: `// path : lib/contoh/nama_file.dart`.

3.  **Kewajiban Membaca Dokumentasi Proyek**: Sebelum memulai pekerjaan apa pun, AI diharuskan membaca keseluruhan file `README.md` untuk memahami alur kerja, struktur proyek, dan konteks pengembangan secara komprehensif.

4.  **Pembaruan Dokumentasi Per File**: Setelah menyelesaikan modifikasi pada suatu file, AI wajib memperbarui atau menambahkan bagian dokumentasi untuk file tersebut di dalam `README.md`. Dokumentasi ini harus mencakup keterangan tentang fitur dan fungsi yang ada di dalam file yang bersangkutan, dikelompokkan berdasarkan direktori.

5.  **Prosedur Pra-Build**: Sebelum melakukan proses *build*, AI wajib membaca `README.md` untuk mengidentifikasi jenis perubahan yang telah dilakukan. Klasifikasi perubahan adalah sebagai berikut:
    *   **Perbaikan Bug**: Modifikasi yang bertujuan memperbaiki kesalahan atau cacat pada aplikasi.
    *   **Penambahan Fitur Baru**: Modifikasi yang menambahkan fungsionalitas yang sebelumnya tidak ada.
    *   Jika hanya dilakukan perbaikan bug, hanya nomor *build* (contoh: `+1`) pada file `pubspec.yaml` yang dinaikkan. Nomor versi (contoh: `1.0.0`) **tidak boleh** diubah.
    *   Proses *build* **hanya boleh dijalankan atas instruksi eksplisit dari pengembang** dengan perintah spesifik, misalnya "build", "tolong build", dll. Jika diperintah, jalankan perintah berikut: `flutter clean && flutter pub get && flutter build apk --release --split-per-abi`.

6.  **Konsistensi dan Kejelasan Kode**: AI wajib menjaga konsistensi gaya penulisan kode dan memastikan setiap kode yang ditulis memiliki struktur yang jelas, mudah dibaca, dan dapat dipahami oleh pengembang.

7.  **Format Dokumentasi File di README.md**: Pembaruan dokumentasi file di `README.md` harus mengikuti format yang ketat dan dikelompokkan berdasarkan folder. Format ini bertujuan agar dokumentasi rapi, terstruktur, dan informatif. Contoh format yang harus diikuti:
    ```markdown
    ### File: `lib/path/nama_file.dart`
    **Fitur:** [Deskripsi singkat fitur utama yang diimplementasikan dalam file ini]
    **Daftar Fungsi:**
    - `namaFungsiA()`: Penjelasan mendetail tentang tujuan dan cara kerja fungsi A.
    - `namaFungsiB()`: Penjelasan mendetail tentang tujuan dan cara kerja fungsi B.
    **Catatan:** [Informasi penting atau relevan lainnya, misalnya dependensi khusus, state management yang digunakan, atau potensi masalah]
    **Rules:** [Aturan spesifik yang diterapkan dalam file ini, misalnya: "Semua format tanggal wajib mengacu pada konfigurasi di file `lib/utils/format_tanggal.dart`."]
    ```
    *   **Hindari dokumentasi yang terlalu generik**, seperti "tombol untuk menambah". Gunakan deskripsi yang lebih informatif, misalnya "Tombol untuk menyimpan data formulir ke database lokal.".
    *   **Hindari penyebutan teknis yang ambigu**, seperti "menambahkan kode value pada kode anu karena akan menyebabkan error". Gunakan penjelasan teknis yang jelas dan spesifik.

8.  **Pemberian Keterangan pada Modifikasi Kode**: Setiap baris atau blok kode yang dimodifikasi wajib diberi komentar penjelasan. Format komentar yang digunakan adalah:
    *   `// dihapus: [Alasan mengapa kode ini dihapus]`
    *   `// diubah/ditambah: [Alasan mengapa kode ini diubah atau ditambahkan]`

9.  **Verifikasi Kode dengan Flutter Analyze**: Setelah menyelesaikan seluruh pekerjaan pada suatu file atau fitur, AI wajib menjalankan perintah `flutter analyze` di terminal untuk memverifikasi bahwa kode bebas dari kesalahan (*error*) dan peringatan (*warning*).

10. **Prosedur Konfirmasi Pekerjaan**: Sebelum mengeksekusi pekerjaan apa pun, AI wajib memberikan penjelasan singkat dan jelas mengenai rencana tindakan yang akan dilakukan. AI hanya boleh memulai pekerjaan setelah mendapatkan konfirmasi eksplisit dari pengembang.
    *   Kata kunci persetujuan: `setuju`, `oke`, `ok`, `ya`, `yes`.
    *   Kata kunci penolakan: `jangan`, `tidak`, `nggk`, `nggak`.

11. **Pemberian Komentar pada Setiap Fungsi**: Di atas setiap deklarasi fungsi (kecuali fungsi bawaan widget seperti `build`), wajib diberikan komentar yang menjelaskan tujuan spesifik dari pembuatan fungsi tersebut. Format: `// [Penjelasan tujuan fungsi, contoh: untuk menavigasi ke halaman pengaturan]`.

12. **Penambahan Komentar di Dalam Kode**: AI dianjurkan untuk sesering mungkin menambahkan komentar penjelas pada blok-blok kode penting di dalam isi file. Tujuannya adalah untuk memperjelas alasan dan logika di balik implementasi kode, sehingga memudahkan pengembang untuk membaca dan memahami.

13. **Perintah Clean Projek**: Apabila pengembang memberikan perintah "clean", AI wajib menjalankan perintah `flutter clean && flutter pub get` di terminal untuk membersihkan *cache* build dan mengunduh ulang dependensi.

14. **Larangan Asumsi Liar**: AI dilarang keras membuat asumsi sepihak yang tidak didasari oleh instruksi eksplisit dari pengembang atau konteks yang sudah ada. Setiap tindakan harus dipastikan akan menjaga seluruh file dan modul dalam proyek tetap sinkron dan kompatibel satu sama lain.

15. **Pola Asynchronous**: Setiap kali membuat fungsi yang melibatkan operasi I/O, *network request*, interaksi dengan database, atau operasi yang memerlukan waktu tunggu, wajib menggunakan pola asynchronous (`async`/`await`) dan membungkus hasilnya dalam objek `Future`. Penggunaan `.then()` berantai harus dihindari demi keterbacaan kode.


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
