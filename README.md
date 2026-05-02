# **Aturan lainnya untuk AI**

Berikut adalah serangkaian aturan yang harus diikuti oleh AI untuk menjaga konsistensi, kejelasan, dan kualitas dalam pengembangan proyek ini.

1.  **Penggunaan Bahasa Indonesia**: Wajib menggunakan Bahasa Indonesia yang formal dan jelas dalam semua aspek pengembangan, termasuk penamaan fungsi, variabel, parameter, nama file, serta dalam setiap interaksi verbal dan tulisan.

2.  **Komentar Path File**: Setiap file yang dibuat atau dimodifikasi harus memiliki komentar di baris paling atas yang menunjukkan path lengkap file tersebut. Format: `// path: lib/nama_folder/nama_file.dart`.

3.  **Prosedur Awal Pengerjaan**: Sebelum memulai tugas pengembangan apa pun, AI diwajibkan untuk membaca dan memahami keseluruhan isi dari file `README.md` ini. Tujuannya adalah untuk menyelaraskan pemahaman mengenai alur kerja, standar, dan dokumentasi proyek yang berlaku.

4.  **Dokumentasi Perubahan**: Setelah menyelesaikan modifikasi pada sebuah file, AI harus menambahkan atau memperbarui bagian dokumentasi file tersebut di dalam `README.md`. Ini mencakup deskripsi fitur, daftar fungsi, dan catatan relevan lainnya.

5.  **Protokol Proses Build**:
    *   Sebelum memulai proses build, lakukan analisis terhadap file `README.md` untuk mengidentifikasi apakah perubahan yang dilakukan merupakan penambahan fitur baru atau hanya perbaikan bug.
    *   Jika perubahan hanya berupa perbaikan bug, hanya nomor `buildNumber` di `pubspec.yaml` yang boleh dinaikkan. Versi aplikasi (`version`) harus tetap.
    *   Proses build hanya boleh dilakukan atas perintah eksplisit dari saya.
    *   Ketika diperintahkan, jalankan perintah berikut secara berurutan: `flutter clean && flutter pub get && flutter build apk --release --split-per-abi`.

6.  **Menjaga Konsistensi**: AI bertanggung jawab untuk menjaga konsistensi kode, struktur proyek, dan pola desain di seluruh aplikasi.

7.  **Pembaruan Dokumentasi README.md**: Setelah menyelesaikan pekerjaan, segera perbarui bagian dokumentasi yang relevan di dalam file `README.md`. Fokus pada deskripsi tujuan file, fitur yang diimplementasikan, dan daftar fungsi. Hindari menyertakan contoh kode yang ambigu atau berpotensi menimbulkan error.

8.  **Komentar Perubahan Kode**: Setiap baris kode yang dihapus, diubah, atau ditambahkan harus disertai dengan komentar yang jelas mengenai alasannya. Gunakan format berikut:
    *   `// dihapus: [alasan penghapusan]`
    *   `// diubah: [alasan perubahan]`
    *   `// ditambah: [alasan penambahan]`

9.  **Analisis Kode Statis**: Setelah menyelesaikan modifikasi kode, jalankan perintah `flutter analyze` di terminal untuk memastikan tidak ada error atau *warning* yang tersisa.

10. **Mekanisme Konfirmasi**: Sebelum melakukan tindakan atau modifikasi apa pun, AI harus memberikan penjelasan rinci mengenai rencana kerjanya. Pekerjaan hanya boleh dilanjutkan setelah mendapatkan konfirmasi eksplisit dari saya (misalnya: `setuju`, `oke`, `ok`, `ya`, `yes`). Jika saya merespons dengan negasi (misalnya: `jangan`, `tidak`, `nggak`), AI harus membatalkan rencana tersebut.

11. **Dokumentasi Fungsi**: Setiap fungsi yang dibuat harus memiliki komentar di atasnya yang menjelaskan tujuan dan kegunaan fungsi tersebut secara singkat dan jelas. Contoh: `// untuk menavigasi pengguna ke halaman pengaturan profil.`

12. **Komentar Penjelas Kode**: Tambahkan komentar-komentar informatif di dalam blok kode yang kompleks atau penting untuk membantu pemahaman mengenai logika atau alur kerja kode tersebut.

13. **Perintah `clean`**: Jika saya memberikan instruksi `clean`, AI harus segera menjalankan perintah `flutter clean && flutter pub get` di terminal.

14. **Menghindari Asumsi**: AI dilarang keras membuat asumsi yang tidak didasarkan pada instruksi atau dokumentasi yang ada. Hal ini untuk memastikan semua komponen proyek tetap sinkron dan selaras.

15. **Pola Pemrograman Asinkron**: Setiap fungsi yang berinteraksi dengan operasi I/O (input/output), permintaan jaringan (*network request*), atau akses database wajib diimplementasikan menggunakan pola *Asynchronous* (`async`/`await`) dan mengembalikan objek `Future`. Hindari penggunaan metode `.then()` yang berantai untuk menjaga keterbacaan kode.

16. **Format Standar Pembaruan README.md**: Saat memperbarui dokumentasi file di `README.md` setelah pengerjaan, kelompokkan dokumentasi berdasarkan direktori dan gunakan format terstruktur berikut:
    ```
    File: lib/path/ke/nama_file.dart
    Fitur: [Nama Fitur Utama yang Dikerjakan]
    Daftar Fungsi:
    - namaFungsiA(): Penjelasan singkat, jelas, dan padat mengenai kegunaan fungsi.
    - namaFungsiB(): Penjelasan singkat, jelas, dan padat mengenai kegunaan fungsi.
    Catatan: [Informasi tambahan, dependensi, atau konteks penting lainnya jika ada.]
    Rules: [Aturan spesifik yang harus diikuti saat menggunakan atau memodifikasi file ini. Contoh: "Untuk format tanggal dan angka, wajib menggunakan utilitas dari 'lib/utils/format_util.dart' agar konsisten."]
    ```

---

# **Kritik dan Saran untuk Peningkatan Proyek**

Berdasarkan analisis terhadap struktur dan aturan proyek, berikut adalah beberapa saran yang dapat dipertimbangkan untuk meningkatkan profesionalisme, efisiensi, dan kualitas aplikasi Anda:

1.  **Implementasi Pengujian Otomatis (Testing)**:
    *   **Saran**: Mulai mengadopsi *unit testing* untuk memverifikasi logika bisnis (misalnya, fungsi di `perhitungan_util.dart`) dan *widget testing* untuk memastikan komponen UI berfungsi seperti yang diharapkan.
    *   **Manfaat**: Ini akan secara drastis mengurangi regresi (bug yang muncul kembali) setiap kali ada perubahan, meningkatkan kepercayaan diri saat merilis versi baru, dan menjadikan proyek lebih profesional dan andal.

2.  **Manajemen State yang Lebih Terstruktur**:
    *   **Saran**: Saat ini, manajemen state masih bersifat lokal (`setState`). Seiring bertambahnya kompleksitas, pertimbangkan untuk mengadopsi solusi manajemen state yang lebih terpusat dan skalabel seperti **Riverpod** atau **Provider**.
    *   **Manfaat**: Memisahkan logika bisnis dari UI, membuat kode lebih mudah diuji (*testable*), dikelola (*maintainable*), dan dipahami oleh anggota tim lain di masa depan.

3.  **Struktur Proyek Berbasis Fitur (Feature-Driven)**:
    *   **Saran**: Kelompokkan file tidak hanya berdasarkan tipe (misalnya, `halaman`, `model`), tetapi juga berdasarkan fitur. Contoh: folder `lib/fitur/pelanggan/` akan berisi `halaman/`, `model/`, dan `operasi/` yang khusus untuk fitur pelanggan.
    *   **Manfaat**: Membuat proyek lebih mudah dinavigasi saat skala aplikasi membesar dan memungkinkan pengembangan fitur secara lebih modular dan independen.

4.  **Penerapan Version Control Semantik (Semantic Versioning)**:
    *   **Saran**: Adopsi standar *Semantic Versioning* (MAJOR.MINOR.PATCH) secara disiplin.
        *   **MAJOR**: Untuk perubahan yang tidak kompatibel (API breaking changes).
        *   **MINOR**: Untuk penambahan fitur baru yang kompatibel.
        *   **PATCH**: Untuk perbaikan bug yang kompatibel.
    *   **Manfaat**: Memberikan kejelasan kepada tim dan pengguna mengenai signifikansi setiap rilis versi baru.

5.  **Pengelolaan Dependensi dan Keamanan**:
    *   **Saran**: Lakukan audit dependensi secara berkala dengan menjalankan `flutter pub outdated`. Segera perbarui paket yang usang untuk mendapatkan perbaikan bug, peningkatan performa, dan patch keamanan.
    *   **Manfaat**: Mencegah masalah yang disebabkan oleh paket yang tidak lagi didukung dan menjaga keamanan aplikasi dari kerentanan yang diketahui.

---

# **Dokumentasi Proyek Aplikasi Admin WiFi**

Selamat datang di dokumentasi resmi untuk proyek Aplikasi Admin WiFi. Dokumen ini berfungsi sebagai panduan utama untuk memahami arsitektur, fungsionalitas, dan alur kerja pengembangan aplikasi.

---

## **Folder: lib/data**

**File:** `lib/data/sqlite.dart`
**Fitur:** Pengelola Database SQLite
**Daftar Fungsi:**
*   `database`: Properti getter untuk mendapatkan atau menginisialisasi instance database.
*   `_initDB()`: Menginisialisasi koneksi ke file database SQLite.
*   `_onCreate(Database db, int version)`: Membuat semua tabel saat database pertama kali dibuat.
*   `_onUpgrade(Database db, int oldVersion, int newVersion)`: Menangani migrasi skema database ketika versi dinaikkan.
*   `_createTables(Database db)`: Berisi definisi skema untuk semua tabel dalam aplikasi.
*   `_createKritikSaranTable(Database db)`: Membuat tabel `kritik_saran`.
*   `_createRiwayatLanggananTable(Database db)`: Membuat tabel `riwayat_langganan`.
*   `_createPesananTable(Database db)`: Membuat tabel `pesanan`.
**Catatan:** File ini adalah satu-satunya titik akses untuk semua operasi database. Ini menangani pembuatan, migrasi, dan koneksi ke database SQLite. Perubahan skema terbaru adalah penambahan kolom `sync_status` ke tabel `pelanggan_aktif` untuk menyelaraskannya dengan model `PelangganAktif`.
**Rules:** Setiap perubahan skema tabel harus disertai dengan kenaikan versi database di `_initDB()` dan logika migrasi yang sesuai di `_onUpgrade()`.

---

## **Folder: lib/data/operasi**

**File:** `lib/data/operasi/pelanggan_aktif_operasi.dart`
**Fitur:** Operasi Data Pelanggan Aktif
**Daftar Fungsi:**
- `createPelangganAktif(PelangganAktif pelangganAktif)`: Menambah pelanggan aktif baru dan menandainya `write` untuk sinkronisasi.
- `ambilSemuaPelangganAktif()`: Mengambil semua pelanggan aktif yang tidak ditandai `deleted`.
- `ambilSatuPelangganAktif(String id)`: Mengambil satu pelanggan aktif berdasarkan ID.
- `updatePelangganAktif(PelangganAktif pelangganAktif)`: Memperbarui data pelanggan aktif dan menandainya `write` untuk sinkronisasi.
- `updateSyncStatusToDeleted(String id)`: Melakukan soft delete dengan mengubah `sync_status` menjadi `deleted` dan memperbarui timestamp `diperbarui`.
- `hapusPelangganAktif(String id)`: Wrapper yang memanggil `updateSyncStatusToDeleted` untuk melakukan soft delete.
- `ambilDataUntukSinkronisasi()`: Mengambil semua data yang perlu disinkronkan (`write` atau `deleted`).
- `tandaiSudahSinkron(String id)`: Mengubah `sync_status` menjadi `synced` setelah berhasil diunggah.
- `hapusLokalPermanen(String id)`: Menghapus data secara fisik dari database lokal.
**Catatan:** Kelas ini mengelola semua logika CRUD untuk Pelanggan Aktif dan merupakan komponen kunci dalam strategi sinkronisasi data offline-first.
**Rules:** Semua operasi yang mengubah data (`create`, `update`, `delete`) harus memperbarui `sync_status` dan `diperbarui` dengan benar untuk memastikan integritas proses sinkronisasi.

---

## **Folder: lib/services**

**File:** `lib/services/cek_langganan_kadaluarsa_service.dart`
**Fitur:** Layanan Otomatis Pengarsipan Langganan Kadaluarsa
**Daftar Fungsi:**
- `prosesLanggananKadaluarsa()`: Memeriksa semua pelanggan aktif, memindahkan yang kadaluarsa ke riwayat, dan menandainya untuk dihapus menggunakan `updateSyncStatusToDeleted`.
**Catatan:** Layanan ini berjalan saat aplikasi dimulai untuk memastikan data pelanggan aktif selalu relevan. Logika ini sekarang menggunakan metode `soft delete` yang terpusat.
**Rules:** Layanan ini harus diinisialisasi pada saat startup aplikasi untuk menjalankan fungsinya secara efektif.

---

## **Folder: lib/utils**

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

## **Folder: lib/halaman/detail**

**File:** `lib/halaman/detail/detail_pelanggan_aktif.dart`
**Fitur:** Tampilan Detail Pelanggan Aktif
**Daftar Fungsi:**
*   `_loadDetails()`: Mengambil data gabungan dari beberapa tabel (pelanggan, paket) secara asinkron.
*   `_navigateToEdit()`: Menavigasi ke form edit dan memuat ulang data setelah kembali.
**Catatan:** Halaman ini bersifat *read-only* dan berfungsi sebagai ringkasan informasi seorang pelanggan aktif.
**Rules:** Halaman ini harus menerima objek `PelangganAktif` sebagai argumen. Untuk menampilkan sisa masa aktif dan format tanggal, **wajib** menggunakan utilitas dari `perhitungan_util.dart` dan `format_util.dart`.

---

## **Folder: lib/halaman/form**

**File:** `lib/halaman/form/form_pelanggan_aktif.dart`
**Fitur:** Formulir Aktivasi dan Edit Pelanggan
**Daftar Fungsi:**
*   `_loadAllData()`: Memuat data pelanggan dan paket yang diperlukan untuk mengisi dropdown form.
*   `_selectDate(BuildContext context)`: Menampilkan dialog pemilih tanggal untuk tanggal mulai aktivasi.
*   `_selectTime(BuildContext context)`: Menampilkan dialog pemilih waktu untuk waktu mulai aktivasi.
*   `_hitungTanggalBerakhir(DateTime startDate, Paket paket)`: Menghitung tanggal berakhir langganan berdasarkan durasi paket. Fungsi ini telah diperbaiki untuk menggunakan package `jiffy` agar penambahan durasi bulanan lebih aman dan akurat.
*   `_saveForm()`: Memvalidasi dan menyimpan data aktivasi pelanggan baru atau pembaruan data yang sudah ada.
**Catatan:** Formulir ini digunakan untuk membuat aktivasi baru atau mengedit aktivasi yang sudah ada. Terdapat perbaikan penting pada logika `_hitungTanggalBerakhir` untuk mencegah bug perhitungan tanggal.
**Rules:**
*   Setiap kali menyimpan data, form akan melakukan validasi untuk memastikan semua field yang diperlukan (pelanggan, paket, tanggal) telah terisi.
*   Pemformatan tanggal dan jam pada tampilan form wajib menggunakan utilitas dari `format_util.dart`.

---

## **Folder: lib/halaman/tab**

**File:** `lib/halaman/tab/pelanggan_aktif.dart`
**Fitur:** Manajemen Daftar Pelanggan Aktif
**Daftar Fungsi:**
*   `_loadData()`: Memuat dan mengurutkan daftar pelanggan aktif.
*   `_hapusPelangganAktif(PelangganAktif pelanggan)`: Menangani logika pengarsipan. Proses ini memindahkan data ke riwayat dan melakukan `soft delete` dengan memanggil `_pelangganAktifOperasi.hapusPelangganAktif()`.
*   `_applyFilterAndSort()`: Mengurutkan dan memfilter daftar berdasarkan kriteria yang dipilih.
*   `_periksaDanJadwalkanNotifikasi(...)`: Menangani penjadwalan notifikasi lokal untuk paket yang akan berakhir.
**Catatan:** Ini adalah halaman utama untuk manajemen pelanggan aktif. Logika penghapusan telah disederhanakan untuk menggunakan metode `soft delete` dari lapisan operasi data, memastikan konsistensi.
**Rules:** Setiap operasi yang memodifikasi data (tambah, edit, hapus) harus memanggil `_loadData()` pada akhirnya untuk memastikan data yang ditampilkan selalu sinkron. Tampilan sisa masa aktif dan status **wajib** menggunakan `PerhitunganUtil`.

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

**File:** `lib/halaman/tab/pesan.dart`
**Fitur:** Manajemen Pesanan. Halaman ini digunakan untuk melihat, mengelola, dan memfilter daftar pesanan yang masuk.
**Daftar Fungsi:**
*   `_muatPesanan()`: Memuat daftar pesanan dari database berdasarkan filter status yang aktif.
*   `_updateStatus(PesananModel pesanan, String statusBaru)`: Memperbarui status sebuah pesanan (misalnya dari 'baru' menjadi 'diproses').
*   `_hapusPesanan(PesananModel pesanan)`: Menghapus sebuah pesanan dari database setelah konfirmasi.
*   `_buildFilterChips()`: Membangun UI untuk filter pesanan berdasarkan status (Semua, Baru, Diproses, Selesai, Ditolak).
*   `_showPesananDetail(PesananModel pesanan)`: Menampilkan detail lengkap dari sebuah pesanan dalam *modal bottom sheet*.
**Catatan:** Halaman ini menyediakan ringkasan jumlah total pesanan dan memungkinkan interaksi cepat untuk mengubah status atau menghapus pesanan.
**Rules:**
*   Pemformatan tanggal pesanan wajib menggunakan utilitas dari `format_util.dart`.
*   Setiap operasi yang mengubah data (update status, hapus) harus memanggil `_muatPesanan()` untuk merefleksikan perubahan di UI.

---

**File:** `lib/halaman/tab/lainnya.dart`
**Fitur:** Pusat Pengaturan dan Navigasi. Halaman ini berfungsi sebagai hub untuk mengakses berbagai halaman manajemen lainnya dan untuk menguji fungsionalitas notifikasi.
**Daftar Fungsi:**
*   `_initNotifikasi()`: Menginisialisasi layanan notifikasi.
*   `_tampilkanNotifikasiLangsung()`: Mengirim notifikasi tes secara langsung.
*   `_jadwalkanNotifikasi()`: Menjadwalkan notifikasi tes untuk 10 detik ke depan.
*   `_buildNavigationButton(...)`: Fungsi pembantu untuk membuat tombol navigasi yang konsisten.
**Catatan:** Halaman ini berisi daftar navigasi ke semua halaman pengaturan dan manajemen penting dalam aplikasi, termasuk halaman 'Daftar Pesanan'.
**Rules:** Penambahan halaman manajemen baru harus disertai dengan penambahan tombol navigasi di file ini menggunakan `_buildNavigationButton` untuk menjaga konsistensi UI.

---

## **Folder: lib/halaman/lainnya**

**File:** `lib/halaman/lainnya/kritik_saran.dart`
**Fitur:** Tampilan Kritik dan Saran Pengguna
**Daftar Fungsi:**
*   `_loadKritikSaran()`: Memuat daftar semua kritik dan saran dari database.
**Catatan:** Halaman ini berfungsi untuk menampilkan masukan dari pengguna aplikasi.
**Rules:** Format tanggal dan waktu pengiriman kritik dan saran **wajib** menggunakan `FormatTanggal.formatTanggalDanJam()` dari `format_util.dart`.

---

**File:** `lib/halaman/lainnya/paket.dart`
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
