# **Dokumentasi Proyek Aplikasi Admin WiFi**

Selamat datang di dokumentasi resmi untuk proyek Aplikasi Admin WiFi. Dokumen ini berfungsi sebagai panduan utama untuk memahami arsitektur, fungsionalitas, dan alur kerja pengembangan aplikasi.

---

## **1. Tujuan Aplikasi**

Aplikasi Admin WiFi adalah sebuah sistem manajemen lengkap yang dirancang untuk membantu administrator dalam mengelola layanan jaringan WiFi. Fungsi utamanya meliputi:

*   **Manajemen Pelanggan:** Mengelola data pelanggan, baik yang aktif maupun yang sudah tidak berlangganan.
*   **Manajemen Transaksi:** Mencatat semua transaksi pembayaran dari pelanggan.
*   **Manajemen Paket:** Mengatur berbagai paket layanan WiFi yang ditawarkan.
*   **Manajemen Keuangan:** Melacak pemasukan dan pengeluaran melalui fitur dompet digital.
*   **Interaksi Pengguna:** Menyediakan platform bagi pengguna untuk memberikan kritik dan saran.

---

## **2. Struktur Direktori Proyek**

Struktur direktori di dalam `lib/` diatur berdasarkan fitur untuk memastikan skalabilitas dan kemudahan pemeliharaan.

*   **`lib/`**: Direktori utama kode sumber aplikasi.
    *   **`main.dart`**: Titik masuk utama aplikasi.
    *   **`splash_screen.dart`**: Halaman awal yang ditampilkan saat aplikasi pertama kali dimuat.
    *   **`halaman_utama.dart`**: Halaman utama yang mengatur navigasi tab setelah splash screen.
*   **`lib/data/`**: Berisi semua logika yang berhubungan dengan pengelolaan data.
    *   **`sqlite.dart`**: Kelas *handler* utama untuk operasi database SQLite.
    *   **`operasi/`**: Direktori yang berisi kelas-kelas untuk operasi *CRUD (Create, Read, Update, Delete)* pada setiap tabel di database.
    *   **`servis/`**: Terkait dengan layanan eksternal, seperti sinkronisasi data dengan Firebase.
*   **`lib/model/`**: Berisi definisi struktur data (kelas model) yang merepresentasikan objek dalam aplikasi (misalnya, `Pelanggan`, `Transaksi`, `Paket`).
*   **`lib/halaman/`**: Berisi semua file yang terkait dengan antarmuka pengguna (UI).
    *   **`tab/`**: Widget untuk setiap tab utama pada bilah navigasi bawah.
    *   **`form/`**: Halaman untuk menambah atau mengedit data.
    *   **`detail/`**: Halaman untuk menampilkan informasi rinci dari sebuah item data.
    *   **`lainnya/`**: Halaman-halaman tambahan yang dapat diakses dari tab "Lainnya".
*   **`lib/utils/`**: Berisi kode utilitas yang dapat digunakan kembali di seluruh aplikasi, seperti format tanggal, manajemen warna, dll.
*   **`lib/widget/`**: Berisi komponen-komponen UI kustom yang dapat digunakan kembali.

---

## **3. Deskripsi File dan Fungsionalitas**

Berikut adalah penjelasan rinci untuk setiap komponen utama dalam aplikasi.

### **File Utama**

*   **`lib/main.dart`**
    *   **Tujuan:** Menginisialisasi aplikasi dan Firebase, serta mendefinisikan tema global.
    *   **Fitur:** Titik masuk aplikasi Flutter.
*   **`lib/splash_screen.dart`**
    *   **Tujuan:** Menampilkan layar pembuka (logo atau animasi) saat aplikasi dimuat.
    *   **Fitur:** Navigasi otomatis ke halaman utama setelah beberapa detik.
*   **`lib/halaman_utama.dart`**
    *   **Tujuan:** Menjadi kerangka utama aplikasi yang menampung bilah navigasi bawah.
    *   **Fitur:** Mengatur perpindahan antar tab utama (Home, Pelanggan Aktif, Transaksi, Dompet, Lainnya).

### **Manajemen Data (`lib/data/`)**

*   **`lib/data/sqlite.dart`**
    *   **Tujuan:** Mengelola seluruh siklus hidup database SQLite, mulai dari pembuatan tabel hingga koneksi.
    *   **Fungsi:** `initDB()`: Membuat atau membuka database dan tabel-tabel yang diperlukan.
*   **Operasi CRUD (`lib/data/operasi/`)**
    *   **Tujuan:** Setiap file di direktori ini bertanggung jawab untuk operasi database pada satu tabel spesifik (misalnya, `pelanggan_operasi.dart` untuk tabel pelanggan).
    *   **Fungsi Umum:** `tambah`, `semua`, `hapus`, `perbarui`, `cari`.
*   **`lib/data/servis/firebase_servis.dart`**
    *   **Tujuan:** Mengelola sinkronisasi data antara database lokal (SQLite) dan Firebase Firestore.
    *   **Fitur:** Sinkronisasi dua arah untuk memastikan konsistensi data.

### **Model Data (`lib/model/`)**

*   **Tujuan:** Setiap file `.dart` di direktori ini mendefinisikan sebuah kelas model yang mencerminkan struktur sebuah tabel di database. Ini membantu memastikan tipe data yang konsisten di seluruh aplikasi.
    *   `pelanggan_model.dart`: Merepresentasikan data seorang pelanggan.
    *   `transaksi_model.dart`: Merepresentasikan sebuah transaksi pembayaran.
    *   Dan seterusnya untuk model lainnya.

### **Halaman (UI) (`lib/halaman/`)**

*   **Tab Utama (`lib/halaman/tab/`)**
    *   `home.dart`: Menampilkan ringkasan atau dasbor utama.
    *   `pelanggan_aktif.dart`: Menampilkan daftar pelanggan yang sedang aktif.
    *   `transaksi.dart`: Menampilkan riwayat semua transaksi.
    *   `dompet.dart`: Menampilkan saldo dan riwayat keuangan.
    *   `lainnya.dart`: Menyediakan menu navigasi ke halaman sekunder seperti Kategori, Paket, dan Pelanggan.
*   **Formulir (`lib/halaman/form/`)**
    *   **Tujuan:** Menyediakan antarmuka bagi admin untuk memasukkan atau mengubah data.
    *   **Contoh:** `form_pelanggan.dart` berisi formulir untuk menambah atau mengedit detail pelanggan.
*   **Detail (`lib/halaman/detail/`)**
    *   **Tujuan:** Menampilkan informasi lengkap tentang item tertentu yang dipilih dari daftar.
    *   **Contoh:** `detail_pelanggan.dart` menampilkan semua informasi terkait seorang pelanggan, termasuk riwayat pembayarannya.

---

## **4. Alur Kerja Pengembangan**

1.  **Analisis & Perencanaan:** Sebelum melakukan perubahan, AI akan menganalisis permintaan dan membuat rencana kerja.
2.  **Konfirmasi:** Rencana akan diajukan kepada pengguna untuk mendapatkan persetujuan.
3.  **Implementasi:** Setelah disetujui, AI akan mengimplementasikan perubahan sesuai standar kode yang ditetapkan.
4.  **Dokumentasi:** AI akan memperbarui komentar kode dan file `README.md` ini.
5.  **Verifikasi:** AI akan menjalankan `flutter analyze` untuk memastikan kualitas kode sebelum menyelesaikan tugas.