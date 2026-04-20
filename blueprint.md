
# Blueprint Aplikasi Flutter

## Gambaran Umum

Aplikasi ini adalah aplikasi Flutter yang berfungsi sebagai dasbor admin untuk mengelola berbagai aspek bisnis, termasuk pelanggan, paket, transaksi keuangan, dan banyak lagi.

## Fitur yang Diterapkan

### Manajemen Data
- **Pelanggan:** Menambah, melihat, memperbarui, dan menghapus data pelanggan.
- **Paket:** Mengelola paket layanan yang ditawarkan.
- **Dompet:** Melacak beberapa sumber dana.
- **Kategori:** Mengklasifikasikan transaksi (pemasukan dan pengeluaran).
- **Transaksi:** Mencatat semua aktivitas keuangan.

### Interaksi Pengguna
- **Formulir Input:** Formulir terstruktur untuk menambahkan dan mengedit data.
- **Navigasi:** Antarmuka tab untuk beralih di antara berbagai bagian.
- **Umpan Balik:** Dialog konfirmasi dan pesan umpan balik.

### Fitur Tambahan
- **Kritik dan Saran:** Memungkinkan pengguna untuk memberikan umpan balik.

## Rencana Saat Ini: Mengambil dan Menyimpan Data dari API Publik

### Tujuan
Mengintegrasikan aplikasi dengan API publik (`https://reqres.in/api/users`) untuk mengambil daftar pengguna, menampilkannya, dan menyimpan data secara lokal dalam format JSON.

### Langkah-langkah
1.  **Tambahkan Dependensi:**
    *   `http`: Untuk melakukan permintaan jaringan.
    *   `path_provider`: Untuk mendapatkan direktori penyimpanan lokal.

2.  **Buat Model Pengguna:**
    *   Buat file `lib/model/user_model.dart` untuk mendefinisikan struktur data pengguna.

3.  **Buat Layanan API:**
    *   Buat file `lib/api/api_service.dart` untuk merangkum logika pengambilan data dari API.

4.  **Buat Halaman Tampilan API:**
    *   Buat file `lib/halaman/api/pengguna_dari_api.dart` untuk menampilkan daftar pengguna yang diambil dari API.
    *   Implementasikan penanganan status:
        *   **Loading:** Tampilkan indikator kemajuan.
        *   **Sukses:** Tampilkan daftar pengguna.
        *   **Error:** Tampilkan pesan kesalahan.
    *   Tambahkan fungsionalitas untuk menyimpan data ke file JSON lokal.

5.  **Buat Halaman Tampilan JSON:**
    *   Buat file `lib/halaman/api/pengguna_dari_json.dart` untuk membaca dan menampilkan data pengguna dari file JSON lokal.

6.  **Integrasikan ke Navigasi Utama:**
    *   Perbarui `lib/main.dart` untuk menambahkan rute ke halaman baru.
    *   Tambahkan tombol di antarmuka utama untuk mengakses halaman "Pengguna dari API" dan "Pengguna dari JSON".
