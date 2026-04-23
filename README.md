# **Aturan lainnya untuk AI**
1. 

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
*   **Notifikasi Otomatis:** Memberikan pengingat proaktif mengenai paket pelanggan yang akan berakhir.
*   **Mode Offline:** Memberi tahu pengguna ketika aplikasi tidak terhubung ke internet.
*   **Informasi Aplikasi:** Menyediakan halaman khusus "Tentang Aplikasi" yang menampilkan versi dan deskripsi.

---

## **2. Struktur Direktori Proyek**

Struktur direktori di dalam `lib/` diatur berdasarkan fitur untuk memastikan skalabilitas dan kemudahan pemeliharaan.

*   **`lib/`**: Direktori utama kode sumber aplikasi.
    *   **`main.dart`**: Titik masuk utama aplikasi.
    *   **`splash_screen.dart`**: Layar pembuka yang juga menangani pemeriksaan konektivitas awal.
    *   **`data/`**: Logika pengelolaan data.
        *   **`operasi/`**: Kelas-kelas yang bertanggung jawab untuk operasi CRUD pada database lokal (SQLite).
        *   **`repositori/`**: Lapisan yang bertanggung jawab untuk operasi data (CRUD) langsung dengan sumber data eksternal seperti Firestore.
        *   **`services/`**: Layanan latar belakang seperti sinkronisasi data dan notifikasi.
    *   **`model/`**: Definisi kelas model data.
    *   **`halaman/`**: Komponen antarmuka pengguna (UI), diatur per fitur.
    *   **`utils/`**: Kode utilitas yang dapat digunakan kembali.
    *   **`widget/`**: Komponen UI kustom yang dapat digunakan kembali.
*   **`assets/`**: Berisi aset statis seperti font lokal.

---

## **3. Arsitektur & Desain**

### **Manajemen Status (State Management)**

Aplikasi ini menggunakan paket **`provider`** untuk memisahkan logika UI dari logika bisnis, dengan pola `ChangeNotifier` dan `ChangeNotifierProvider`.

### **Desain Visual & Tema (Visual Design & Theming)**

Antarmuka pengguna mengikuti prinsip **Desain Material 3**.

*   **Tema:** Tema terpusat didefinisikan di `lib/main.dart` dengan `seedColor` **`Colors.deepPurple`**.
*   **Tipografi:** Menggunakan **font kustom lokal** dari `assets/fonts/` (Oswald, Roboto, Open Sans) untuk kinerja optimal dan tampilan yang konsisten.

### **Navigasi (Navigation)**

Navigasi utama menggunakan `BottomNavigationBar` di `lib/halaman_utama.dart`. Navigasi sekunder menggunakan `Navigator.push` dengan `MaterialPageRoute`.

---

## **4. Fungsionalitas Inti**

Aplikasi ini memiliki beberapa modul fitur utama yang bekerja secara terintegrasi.

### **Pemeriksaan Konektivitas & Mode Offline**
*   **Tujuan:** Memberikan umpan balik langsung kepada pengguna mengenai status koneksi internet mereka untuk mengelola ekspektasi terkait sinkronisasi data.
*   **File Terkait:** `lib/splash_screen.dart`, `lib/services/cek_koneksi_internet.dart`.

### **Manajemen Data & Arsitektur Penghapusan**
*   **Tujuan:** Mengelola data inti bisnis secara konsisten dengan pemisahan tanggung jawab yang jelas.
*   **File Terkait:** `lib/data/operasi/`, `lib/data/repositori/`, `lib/halaman/tab/pelanggan_aktif.dart`.
*   **Alur Penghapusan Data:** Proses penghapusan data diinisiasi dari lapisan UI, namun logikanya dienkapsulasi pada lapisan yang sesuai untuk memastikan pemisahan tanggung jawab (Separation of Concerns).
    1.  **Pengecekan Koneksi:** UI (`pelanggan_aktif.dart`) memeriksa status koneksi internet.
    2.  **Operasi Jarak Jauh (Online):** Jika aplikasi online, UI memanggil `PelangganAktifRepositori` (`lib/data/repositori/pelanggan_aktif_repositori.dart`) untuk menghapus dokumen yang relevan dari **Firestore**.
    3.  **Operasi Lokal:** Setelah operasi jarak jauh (jika ada) selesai, UI memanggil `PelangganAktifOperasi` (`lib/data/operasi/pelanggan_aktif_operasi.dart`) untuk menghapus data dari **database SQLite lokal**.
    *   Pendekatan ini memastikan bahwa logika interaksi dengan Firebase terisolasi di dalam **lapisan repositori**, sementara logika interaksi dengan database lokal berada di dalam **lapisan operasi**, sesuai dengan arsitektur yang bersih.

### **Dompet Digital (Manajemen Keuangan)**
*   **Tujuan:** Melacak saldo, pemasukan, dan pengeluaran untuk memberikan gambaran keuangan yang jelas.
*   **File Terkait:** `lib/model/dompet_model.dart`, `lib/data/operasi/dompet_operasi.dart`, `lib/halaman/tab/dompet.dart`.

### **Sinkronisasi Data dengan Firebase**
*   **Tujuan:** Memastikan konsistensi data antara database lokal (SQLite) dan backend (Firebase Firestore) secara efisien.
*   **File Terkait:** `lib/data/services/sinkronisasi_database.dart`.
*   **Mekanisme:** Proses sinkronisasi periodik yang berjalan di latar belakang untuk mengunggah dan mengunduh perubahan data secara inkremental.

### **Notifikasi & Pengingat Jatuh Tempo**
*   **Tujuan:** Memberikan pengingat otomatis kepada admin mengenai paket pelanggan yang akan segera berakhir.
*   **File Terkait:** `lib/data/services/notifikasi_servis.dart`, `lib/halaman/tab/pelanggan_aktif.dart`.

### **Kritik dan Saran Pengguna**
*   **Tujuan:** Menyediakan wadah bagi pengguna untuk memberikan masukan, yang kemudian dapat dilihat oleh administrator.
*   **File Terkait:** `lib/model/kritik_saran_model.dart`, `lib/data/operasi/kritik_saran_operasi.dart`, `lib/halaman/lainnya/kritik_saran.dart`.

### **Halaman Tentang Aplikasi**
*   **Tujuan:** Memberikan informasi penting kepada pengguna mengenai aplikasi, termasuk versi saat ini dan deskripsi singkat.
*   **File Terkait:** `lib/halaman/lainnya/tentang_aplikasi.dart`, `lib/halaman/tab/lainnya.dart`.
*   **Mekanisme:**
    1.  Halaman ini dapat diakses melalui menu "Lainnya".
    2.  Secara dinamis mengambil informasi versi aplikasi menggunakan paket `package_info_plus`.
    3.  Menampilkan logo, nama aplikasi, versi, dan deskripsi dengan tata letak yang bersih.

---

## **5. Alur Kerja Pengembangan**

1.  **Perencanaan & Blueprint:** AI akan menganalisis permintaan dan memperbarui file `blueprint.md` sebelum memulai kode.
2.  **Implementasi:** AI akan mengimplementasikan perubahan sesuai dengan standar kode yang ditetapkan.
3.  **Dokumentasi:** AI akan memperbarui komentar kode dan file `README.md` ini jika ada perubahan signifikan.
4.  **Verifikasi & Kualitas Kode:** Setelah setiap perubahan, AI akan menjalankan `flutter analyze` dan `dart format .` untuk memastikan kualitas kode.
5.  **Logging:** Aplikasi menggunakan pustaka `dart:developer` untuk pencatatan terstruktur.
