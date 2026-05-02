# **Dokumentasi Proyek Aplikasi Admin WiFi**

Selamat datang di dokumentasi resmi untuk proyek Aplikasi Admin WiFi. Dokumen ini berfungsi sebagai panduan utama untuk memahami arsitektur, fungsionalitas, dan alur kerja pengembangan aplikasi.

---

## **Folder: lib/data/operasi**

**File:** `lib/data/operasi/pelanggan_aktif_operasi.dart`
**Fitur:** Operasi CRUD dan Sinkronisasi untuk Pelanggan Aktif
**Daftar Fungsi:**
*   `unggahKeFirebase(PelangganAktif pelanggan)`: Mengunggah data pelanggan ke Firestore. Fungsi ini hanya akan memproses pelanggan dengan status `SyncStatus.write`. Sebelum mengirim, fungsi ini akan mengubah status `sync_status` dalam data yang dikirim menjadi `synced`.
*   `tandaiSudahSinkron(String pelangganId)`: Memperbarui status sinkronisasi pelanggan di database lokal menjadi `synced`.
*   `unduhPelangganAktif(PelangganAktif pelangganAktif)`: Menyimpan pelanggan aktif dari server ke database lokal dengan status `synced`.
*   `createPelangganAktif(PelangganAktif pelangganAktif)`: Membuat pelanggan aktif baru di database lokal dengan status `write`.
*   `ambilSemuaPelangganAktif()`: Mengambil semua pelanggan aktif dari database lokal yang tidak ditandai untuk dihapus.
*   `ambilSatuPelangganAktif(String id)`: Mengambil satu pelanggan aktif berdasarkan ID.
*   `updatePelangganAktif(PelangganAktif pelangganAktif)`: Memperbarui pelanggan aktif di database lokal dan menandainya dengan status `write`.
*   `hapusPelangganAktif(String id)`: Menandai pelanggan aktif untuk dihapus dengan mengubah statusnya menjadi `deleted`.
*   `_jadwalkanNotifikasi(PelangganAktif pelangganAktif)`: Menjadwalkan notifikasi lokal untuk pengingat masa berlaku paket.
*   `hapusSemuaPelangganAktif()`: Menghapus semua data pelanggan aktif dari database lokal.
*   `hapusPelangganKadaluarsa()`: Menghapus pelanggan aktif yang sudah melewati tanggal masa berlakunya.
**Catatan:** File ini menangani seluruh alur kerja sinkronisasi, mulai dari pengunggahan data hingga pembaruan status di database lokal.
**Rules:** Gunakan kelas ini untuk semua interaksi dengan tabel `pelanggan_aktif` untuk memastikan konsistensi dan integritas data.

---

**File:** `lib/data/operasi/transaksi_operasi.dart`
**Fitur:** Operasi CRUD dan Agregasi untuk Entitas Transaksi
**Daftar Fungsi:**
- `tambahTransaksi(TransaksiModel transaksi)`: Menyimpan transaksi baru.
- `ambilSemuaTransaksi()`: Mengambil seluruh daftar transaksi.
- `updateTransaksi(TransaksiModel transaksi)`: Memperbarui transaksi yang ada.
- `deleteTransaksi(String id)`: Menghapus transaksi.
- `getTotalPemasukan()`: Menghitung total pemasukan. Telah diperbaiki untuk menangani *case-sensitivity* dengan mencari `tipe = 'pemasukan'`.
- `getTotalPengeluaran()`: Menghitung total pengeluaran. Telah diperbaiki untuk mencari `tipe = 'pengeluaran'`.
- `getNetTotal()`: Menghitung selisih bersih antara pemasukan dan pengeluaran.
**Catatan:** File ini adalah pusat logika untuk semua interaksi dengan tabel `transaksi`. Perbaikan krusial telah dilakukan pada fungsi agregasi (`getTotal...`) untuk memastikan perhitungan saldo yang akurat dengan mencocokkan string *case-sensitive* (`'pemasukan'`, `'pengeluaran'`) yang disimpan di database.
**Rules:** Gunakan kelas ini untuk semua operasi data transaksi guna memastikan konsistensi dan akurasi perhitungan.

---
**File:** `lib/data/operasi/kritik_saran_operasi.dart`
**Fitur:** Operasi CRUD dan Sinkronisasi untuk Kritik & Saran
**Daftar Fungsi:**
- `createKritikSaran(KritikSaranModel kritikSaran)`: Menyimpan data baru ke database lokal.
- `getKritikSaran()`: Mengambil semua data dari database lokal.
- `getKritikSaranById(String id)`: Mengambil satu data berdasarkan ID.
- `getPerubahan(DateTime lastSync)`: Mengambil data yang berubah sejak sinkronisasi terakhir.
- `sisipkanAtauPerbaruiBatch(List<KritikSaranModel> daftarKritikSaran)`: Menyisipkan atau memperbarui banyak data sekaligus ke database lokal. Sangat efisien untuk sinkronisasi.
- `hapusKritikSaran(String id)`: Menghapus data berdasarkan ID.
- `unduhDataDariFirebase()`: **(Baru)** Fungsi statis untuk mengunduh semua data kritik dan saran dari koleksi `kritik_saran` di Firestore.
**Catatan:** Kelas ini sekarang menjadi pusat untuk operasi lokal dan sinkronisasi data kritik dan saran dari Firebase.
**Rules:** Gunakan fungsi `unduhDataDariFirebase()` dilanjutkan dengan `sisipkanAtauPerbaruiBatch()` untuk melakukan sinkronisasi data dari server ke database lokal.

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
**Catatan:** File ini adalah satu-satunya titik akses untuk semua operasi database. Versi database saat ini adalah **16**. Perubahan terakhir adalah perbaikan skema tabel `transaksi` untuk menggunakan format `snake_case` (misal: `id_dompet`), agar sinkron sepenuhnya dengan `transaksi_model.dart`. Proses migrasi di `_onUpgrade` telah diperbarui untuk menangani perubahan ini dengan aman.
**Rules:** Setiap perubahan skema tabel harus disertai dengan kenaikan versi database di `_initDB()` dan logika migrasi yang sesuai di `_onUpgrade()`.

---

## **Folder: lib/model**

**File:** `lib/model/transaksi_model.dart`
**Fitur:** Model Data untuk Entitas Transaksi
**Daftar Fungsi:**
- `TransaksiModel()`: Konstruktor untuk membuat atau memperbarui objek transaksi. Menggunakan `Uuid` untuk ID unik jika tidak disediakan.
- `fromMap(Map<String, dynamic> map)`: Factory constructor yang membuat instance `TransaksiModel` dari data Map (biasanya dari SQLite atau Firestore).
- `toMap()`: Mengonversi instance `TransaksiModel` menjadi Map, siap untuk ditulis ke database.
**Catatan:** Model ini adalah cetak biru untuk setiap data transaksi. Ini menerapkan denormalisasi dengan menyimpan nama-nama terkait (seperti `nama_dompet`, `nama_kategori`) untuk mengurangi query yang kompleks dan meningkatkan performa baca. Semua properti dan kunci Map menggunakan format `snake_case` sebagai standar.
**Rules:** Wajib gunakan model ini untuk semua operasi CRUD yang terkait dengan transaksi untuk menjamin konsistensi, keamanan tipe, dan struktur data yang benar.

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

## **Folder: lib/widget**

**File:** `lib/widget/thousands_input_formatter.dart`
**Fitur:** Pemformat Angka dengan Dukungan Negatif
**Daftar Fungsi:**
- `formatEditUpdate(oldValue, newValue)`: Memformat input teks secara real-time untuk menampilkan pemisah ribuan dan mengizinkan tanda minus ('-') di awal.
**Catatan:** Kelas ini menggantikan implementasi sebelumnya yang hanya mendukung angka positif. Nama kelas diubah menjadi `ThousandsAndNegativeInputFormatter` untuk merefleksikan fungsionalitas barunya.
**Rules:** Gunakan formatter ini pada `TextFormField` yang memerlukan input angka (termasuk negatif) dengan format ribuan yang jelas. Pastikan `keyboardType` pada `TextFormField` diatur ke `TextInputType.numberWithOptions(signed: true)`.

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

**File:** `lib/halaman/form/form_dompet.dart`
**Fitur:** Formulir Tambah dan Edit Dompet
**Daftar Fungsi:**
- `_simpanForm()`: Memvalidasi input dan menangani logika untuk membuat dompet baru atau memperbarui dompet yang sudah ada.
**Catatan:** Formulir ini sekarang mendukung input saldo negatif berkat penggunaan `ThousandsAndNegativeInputFormatter`. Validator juga telah disesuaikan untuk menangani input tanda minus.
**Rules:**
- Nama dompet tidak boleh kosong.
- Saldo harus berupa angka yang valid.
- Pemformatan saldo menggunakan `ThousandsAndNegativeInputFormatter` untuk konsistensi.

---

**File:** `lib/halaman/form/form_transaksi.dart`
**Fitur:** Formulir Tambah Transaksi
**Daftar Fungsi:**
- `_loadInitialData()`: Memuat data awal yang diperlukan seperti daftar dompet dan kategori.
- `_filterKategori()`: Memfilter daftar kategori berdasarkan tipe transaksi yang dipilih (Pemasukan/Pengeluaran).
- `_pilihTanggal(BuildContext context)`: Menampilkan dialog pemilih tanggal.
- `_pilihWaktu(BuildContext context)`: Menampilkan dialog pemilih waktu untuk memilih jam dan menit.
- `_simpanForm()`: Memvalidasi dan menyimpan data transaksi baru ke database.
**Catatan:** Formulir ini telah diperbarui untuk memungkinkan pengguna memilih tidak hanya tanggal tetapi juga waktu transaksi secara spesifik, memberikan kontrol yang lebih detail.
**Rules:**
- Semua field wajib diisi sebelum menyimpan.
- Format tanggal dan jam yang ditampilkan harus konsisten, menggunakan format `yyyy-MM-dd HH:mm`.
- Pemilihan kategori disesuaikan secara dinamis berdasarkan tipe transaksi yang dipilih.

---

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
**Fitur:** Manajemen Daftar Pelanggan Aktif & Sinkronisasi
**Daftar Fungsi:**
*   `_loadData()`: Memuat data pelanggan aktif dari database lokal.
*   `_sinkronkanDataKeFirebase()`: Memeriksa koneksi internet, mengumpulkan semua data dengan status `SyncStatus.write`, mengunggahnya ke Firebase, memperbarui status lokal menjadi `synced`, dan memuat ulang data di UI. Fungsi ini dipicu saat pengguna melakukan *pull-to-refresh*.
*   `_hapusPelangganAktif(PelangganAktif pelanggan)`: Menangani logika untuk mengarsipkan pelanggan ke riwayat dan menghapusnya dari daftar aktif.
*   `_applyFilterAndSort()`: Menerapkan logika filter (pencarian, status sinkronisasi) dan urutan pada daftar pelanggan yang ditampilkan.
*   `_periksaDanJadwalkanNotifikasi(...)`: Menangani penjadwalan notifikasi lokal untuk paket yang akan berakhir.
**Catatan:** Halaman ini adalah pusat manajemen pelanggan aktif. Fungsi `_sinkronkanDataKeFirebase` sekarang menangani seluruh alur sinkronisasi, memberikan umpan balik visual langsung kepada pengguna setelah selesai.
**Rules:** Penggunaan `PerhitunganUtil` dan `FormatUtil` wajib untuk konsistensi tampilan. Refresh data dari database lokal dilakukan dengan menavigasi kembali ke halaman atau setelah melakukan edit/tambah.

---

**File:** `lib/halaman/tab/transaksi.dart`
**Fitur:** Riwayat dan Ringkasan Transaksi
**Daftar Fungsi:**
- `_getData()`: Fungsi terpusat baru yang mengambil semua data (daftar transaksi, total pemasukan, pengeluaran, dan saldo bersih) secara efisien menggunakan `Future.wait`.
- `_loadData()`: Memuat ulang semua data dengan memanggil ulang `_getData`, memastikan UI selalu sinkron.
- `_groupTransaksiByDate(...)`: Mengelompokkan transaksi berdasarkan tanggal untuk tampilan.
- `RingkasanTransaksi`: Widget `Stateless` baru yang bertanggung jawab murni untuk menampilkan data ringkasan yang diterimanya.
**Catatan:** Arsitektur halaman ini telah di-refactor secara signifikan. Penggunaan satu `FutureBuilder` yang memanggil `_getData()` menyelesaikan masalah `LateInitializationError` dan memastikan data ringkasan (pemasukan, pengeluaran) ditampilkan dengan andal dan konsisten setelah setiap perubahan.
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
**Fitur:** Pusat Pengaturan dan Navigasi. Halaman ini berfungsi sebagai hub untuk mengakses berbagai halaman manajemen lainnya.
**Daftar Fungsi:**
*   `_buildNavigationButton(...)`: Fungsi pembantu untuk membuat tombol navigasi yang konsisten.
**Catatan:** Tombol "Kritik & Saran" pada halaman ini telah diperbarui. Saat diketuk, aplikasi akan terlebih dahulu mengunduh data dari Firebase, menyimpannya ke database lokal, baru kemudian menavigasi ke halaman `KritikSaranPage`. Ini memastikan data yang ditampilkan selalu yang terbaru.
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

---

### Folder: lib/halaman/lainnya/
**File:** `lib/halaman/lainnya/tentang_aplikasi.dart`
**Fitur:** Menampilkan Informasi Detail Aplikasi
**Daftar Fungsi:**
- `_initInfo()`: Mengambil informasi paket (versi, build number) dan informasi perangkat (arsitektur CPU, versi Android) secara asynchronous.
- `_buildInfoRow(String label, String value)`: Widget helper untuk membangun setiap baris informasi teknis agar konsisten.
**Catatan:** Halaman ini telah diperbarui untuk menampilkan informasi teknis yang lebih lengkap seperti nomor build, minimal versi OS Android, dan arsitektur perangkat. Tampilan juga diubah menggunakan `ListView` agar konten tidak terpotong pada layar kecil.
**Rules:**
- Selalu gunakan widget `_buildInfoRow` untuk menambahkan informasi teknis baru agar tata letak tetap rapi dan seragam.

---

# **Kritik dan Saran untuk Peningkatan Proyek**

Berdasarkan analisis terbaru dan implementasi fitur sinkronisasi, berikut adalah beberapa rekomendasi lanjutan:

1.  **Optimalkan Proses Sinkronisasi**:
    *   **Saran**: Daripada mengunduh *seluruh* data setiap kali, pertimbangkan untuk hanya mengunduh data yang berubah sejak sinkronisasi terakhir. Ini bisa dicapai dengan menyimpan *timestamp* sinkronisasi terakhir dan menggunakannya untuk memfilter query di Firebase.
    *   **Manfaat**: Mengurangi penggunaan *bandwidth* dan mempercepat proses sinkronisasi, terutama saat jumlah data sudah sangat besar.

2.  **Berikan Umpan Balik Visual Saat Sinkronisasi**:
    *   **Saran**: Saat pengguna menekan tombol "Kritik & Saran" dan proses sinkronisasi berjalan, tampilkan indikator loading (misalnya, `CircularProgressIndicator` di dalam `AlertDialog` atau `SnackBar`).
    *   **Manfaat**: Memberikan umpan balik yang jelas kepada pengguna bahwa aplikasi sedang bekerja, mencegah kebingungan atau penekanan tombol berulang kali.

3.  **Pemisahan Logika Sinkronisasi**:
    *   **Saran**: Buat sebuah kelas `SinkronisasiService` terpusat yang bertanggung jawab untuk semua logika sinkronisasi (baik unggah maupun unduh) untuk semua model data (pelanggan, kritik saran, dll.).
    *   **Manfaat**: Membuat kode lebih rapi (tidak mencampur logika UI dan sinkronisasi di `onTap` button), lebih mudah dikelola, dan dapat digunakan kembali di berbagai bagian aplikasi.

4.  **Implementasi Sinkronisasi Otomatis**:
    *   **Saran**: Pertimbangkan untuk menjalankan proses sinkronisasi secara otomatis di latar belakang pada interval waktu tertentu atau saat aplikasi pertama kali dibuka (setelah login).
    *   **Manfaat**: Memastikan data di perangkat pengguna selalu *up-to-date* tanpa memerlukan interaksi manual, meningkatkan pengalaman pengguna secara keseluruhan.
