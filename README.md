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
    *   **`main.dart`**: Titik masuk utama aplikasi, tempat inisialisasi dan konfigurasi tema.
    *   **`splash_screen.dart`**: Halaman awal yang ditampilkan saat aplikasi dimuat.
    *   **`halaman_utama.dart`**: Kerangka utama yang mengatur navigasi tab aplikasi.
*   **`lib/data/`**: Berisi semua logika yang berhubungan dengan pengelolaan data.
    *   **`sqlite.dart`**: Kelas *handler* untuk operasi database SQLite lokal.
    *   **`operasi/`**: Kelas-kelas untuk operasi *CRUD (Create, Read, Update, Delete)* pada setiap tabel.
    *   **`servis/`**: Layanan untuk sinkronisasi data dengan backend (Firebase).
*   **`lib/model/`**: Definisi struktur data (kelas model) yang merepresentasikan objek dalam aplikasi.
*   **`lib/halaman/`**: Semua file yang terkait dengan antarmuka pengguna (UI).
    *   **`tab/`**: Widget untuk setiap tab utama pada bilah navigasi bawah.
    *   **`form/`**: Halaman untuk menambah atau mengedit data.
    *   **`detail/`**: Halaman untuk menampilkan informasi rinci.
    *   **`lainnya/`**: Berisi halaman-halaman tambahan seperti `kritik_saran.dart`, yang menampilkan masukan dari pengguna.
*   **`lib/utils/`**: Kode utilitas yang dapat digunakan kembali (misalnya, format tanggal, palet warna).
*   **`lib/widget/`**: Komponen UI kustom yang dapat digunakan kembali.
    *   **`nama_dari_id.dart`**: Widget efisien yang menerima `userId`, mengambil data pelanggan dari database lokal, dan menampilkan nama pelanggan tersebut. Ini digunakan untuk menerjemahkan ID pengguna menjadi nama yang dapat dibaca di seluruh aplikasi, contohnya pada halaman Kritik & Saran.
*   **`assets/fonts/`**: Direktori berisi file font lokal yang digunakan di seluruh aplikasi.

---

## **3. Arsitektur & Desain**

### **Manajemen Status (State Management)**

Aplikasi ini menggunakan paket **`provider`** untuk manajemen status. Pendekatan ini memisahkan logika antarmuka pengguna (UI) dari logika bisnis, sehingga membuat aplikasi lebih mudah untuk dipelihara dan diskalakan. Pola `ChangeNotifier` dan `ChangeNotifierProvider` digunakan untuk menyediakan status aplikasi ke pohon widget.

### **Desain Visual & Tema (Visual Design & Theming)**

Antarmuka pengguna aplikasi ini dibangun mengikuti prinsip **Desain Material 3** untuk memastikan pengalaman pengguna yang modern dan intuitif.

*   **Tema:** Tema terpusat didefinisikan di `lib/main.dart` menggunakan `ThemeData`. Warna primer aplikasi dihasilkan dari `seedColor` **`Colors.deepPurple`**.
*   **Tipografi:** Untuk memastikan tipografi yang konsisten dan kinerja yang optimal, aplikasi ini menggunakan **font kustom yang di-hosting secara lokal** di direktori `assets/fonts/`. Ini menggantikan ketergantungan sebelumnya pada paket `google_fonts`, sehingga menghilangkan unduhan saat runtime dan potensi kegagalan jaringan. Font yang digunakan adalah:
    *   **Oswald:** Digunakan untuk judul utama dan teks yang menonjol (`displayLarge`, `appBarTheme`).
    *   **Roboto:** Digunakan untuk judul standar dan tombol (`titleLarge`, `elevatedButtonTheme`).
    *   **Open Sans:** Digunakan untuk teks isi (`bodyMedium`).

### **Navigasi (Navigation)**

Navigasi utama ditangani oleh `BottomNavigationBar` yang terletak di `lib/halaman_utama.dart`, yang mengontrol perpindahan antar tab utama. Navigasi ke halaman detail atau formulir dilakukan secara imperatif menggunakan `Navigator.push` dengan `MaterialPageRoute`.

---

## **4. Alur Kerja Pengembangan**

1.  **Perencanaan & Blueprint:** Sebelum memulai perubahan, AI akan menganalisis permintaan dan memperbarui file `blueprint.md` di root proyek. File ini berfungsi sebagai sumber kebenaran untuk fitur proyek dan tujuan pengembangan saat ini.
2.  **Implementasi:** AI akan mengimplementasikan perubahan sesuai dengan standar kode yang ditetapkan dalam panduan.
3.  **Dokumentasi:** AI akan memperbarui komentar kode dan file `README.md` ini jika ada perubahan signifikan.
4.  **Verifikasi & Kualitas Kode:** Setelah setiap perubahan, AI akan menjalankan `flutter analyze` dan `dart format .` untuk memastikan kualitas kode dan mendeteksi kesalahan secara otomatis.
5.  **Logging:** Untuk tujuan debugging, aplikasi menggunakan pustaka `dart:developer` untuk pencatatan terstruktur, yang dapat dilihat di konsol debug atau Dart DevTools.
