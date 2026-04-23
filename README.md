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

---

## **2. Struktur Direktori Proyek**

Struktur direktori di dalam `lib/` diatur berdasarkan fitur untuk memastikan skalabilitas dan kemudahan pemeliharaan.

*   **`lib/`**: Direktori utama kode sumber aplikasi.
    *   **`main.dart`**: Titik masuk utama aplikasi.
    *   **`splash_screen.dart`**: Layar pembuka yang juga menangani pemeriksaan konektivitas awal.
    *   **`data/`**: Logika pengelolaan data (operasi SQLite, servis sinkronisasi Firebase, servis notifikasi).
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
*   **File Terkait:** `lib/splash_screen.dart`.
*   **Mekanisme:**
    1.  Saat aplikasi dimulai, `SplashScreen` memeriksa konektivitas dan menavigasi ke halaman utama.
    2.  Jika tidak ada koneksi, `SnackBar` akan muncul untuk memberitahu pengguna bahwa mereka dalam mode offline.
    3.  Logika ini juga telah diperkuat dengan pemeriksaan `mounted` untuk mencegah error saat melakukan navigasi atau menampilkan `SnackBar` setelah operasi asinkron, sehingga meningkatkan stabilitas aplikasi.

### **Manajemen Data (Pelanggan, Paket, Transaksi)**
*   **Tujuan:** Mengelola data inti bisnis secara konsisten di database lokal (SQLite) dan Firebase.
*   **File Terkait:** `lib/model/`, `lib/data/operasi/`, `lib/halaman/`.
*   **Alur Penghapusan Data:** Proses penghapusan data, seperti pada pelanggan aktif, diatur secara terpusat dari lapisan UI (`lib/halaman/tab/pelanggan_aktif.dart`). Setelah pengguna mengonfirmasi, aplikasi akan memanggil dua fungsi secara berurutan:
    1.  Fungsi dari kelas `PelangganAktifOperasi` untuk menghapus data dari **database SQLite lokal**.
    2.  Fungsi dari kelas `SinkronisasiService` untuk menghapus data dari **Firestore**.
    *   Pendekatan ini memastikan data terhapus secara konsisten di kedua penyimpanan dan menjaga pemisahan tanggung jawab antar lapisan kode.

### **Dompet Digital (Manajemen Keuangan)**
*   **Tujuan:** Melacak saldo, pemasukan, dan pengeluaran untuk memberikan gambaran keuangan yang jelas.
*   **File Terkait:** `lib/model/dompet_model.dart`, `lib/data/operasi/dompet_operasi.dart`, `lib/halaman/tab/dompet.dart`.

### **Sinkronisasi Data dengan Firebase**
*   **Tujuan:** Memastikan konsistensi data antara database lokal (SQLite) dan backend (Firebase Firestore) secara efisien.
*   **File Terkait:** `lib/data/services/sinkronisasi_database.dart`.
*   **Mekanisme:**
    1.  Layanan ini, yang diimplementasikan dalam kelas `SinkronisasiService`, berjalan secara periodik di latar belakang.
    2.  Proses sinkronisasi bersifat **dua arah dan inkremental**:
        *   **Unggah:** Perubahan yang terjadi di database lokal (data baru atau yang diperbarui) akan diunggah ke Firestore.
        *   **Unduh:** Perubahan yang terjadi di Firestore akan diunduh dan disimpan ke database SQLite lokal.
    3.  Sinkronisasi ini efisien karena hanya memproses data yang berubah sejak waktu sinkronisasi terakhir, menggunakan *timestamp* `diperbarui`.

### **Notifikasi & Pengingat Jatuh Tempo**
*   **Tujuan:** Memberikan pengingat otomatis kepada admin agar dapat menindaklanjuti paket pelanggan yang akan segera berakhir masa aktifnya.
*   **File Terkait:** `lib/data/services/notifikasi_servis.dart`, `lib/halaman/tab/pelanggan_aktif.dart`.
*   **Mekanisme:**
    1.  Saat daftar pelanggan aktif dimuat, sistem akan menjadwalkan notifikasi untuk setiap pelanggan yang relevan.
    2.  Notifikasi dijadwalkan untuk **3 hari sebelum** dan **tepat pada hari** kadaluarsa.
    3.  ID notifikasi yang unik dihasilkan dari `hashCode` ID pelanggan untuk mencegah konflik.

### **Kritik dan Saran Pengguna**
*   **Tujuan:** Menyediakan wadah bagi pengguna untuk memberikan masukan, yang kemudian dapat dilihat oleh administrator dan disinkronkan dengan Firebase.
*   **File Terkait:** `lib/model/kritik_saran_model.dart`, `lib/data/operasi/kritik_saran_operasi.dart`, `lib/halaman/lainnya/kritik_saran.dart`.

---

## **5. Alur Kerja Pengembangan**

1.  **Perencanaan & Blueprint:** AI akan menganalisis permintaan dan memperbarui file `blueprint.md` sebelum memulai kode.
2.  **Implementasi:** AI akan mengimplementasikan perubahan sesuai dengan standar kode yang ditetapkan.
3.  **Dokumentasi:** AI akan memperbarui komentar kode dan file `README.md` ini jika ada perubahan signifikan.
4.  **Verifikasi & Kualitas Kode:** Setelah setiap perubahan, AI akan menjalankan `flutter analyze` dan `dart format .` untuk memastikan kualitas kode.
5.  **Logging:** Aplikasi menggunakan pustaka `dart:developer` untuk pencatatan terstruktur.
