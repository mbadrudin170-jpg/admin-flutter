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

---

## **2. Struktur Direktori Proyek**

Struktur direktori di dalam `lib/` diatur berdasarkan fitur untuk memastikan skalabilitas dan kemudahan pemeliharaan.

*   **`lib/`**: Direktori utama kode sumber aplikasi.
    *   **`main.dart`**: Titik masuk utama aplikasi.
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

### **Manajemen Data (Pelanggan, Paket, Transaksi)**
*   **Tujuan:** Mengelola data inti bisnis, termasuk informasi pelanggan, layanan yang ditawarkan, dan riwayat pembayaran.
*   **File Terkait:** `lib/model/`, `lib/data/operasi/`, `lib/halaman/`.
*   **Fitur Detail Pelanggan:** Halaman `lib/halaman/detail/detail_pelanggan.dart` menyediakan tampilan lengkap informasi pelanggan. Fitur ini mencakup:
    *   Menampilkan semua detail pelanggan (Nama, Telepon, Alamat, MAC Address).
    *   Tombol untuk menyalin informasi individu seperti nomor telepon dan MAC Address.
    *   Kemampuan untuk melihat atau menyembunyikan password.
    *   **Tombol "Salin Semua Info":** Untuk kemudahan, ditambahkan sebuah tombol yang memungkinkan admin menyalin seluruh informasi pelanggan (Nama, Telepon, Alamat, MAC Address, dan Password) ke clipboard dengan sekali tekan.

### **Dompet Digital (Manajemen Keuangan)**
*   **Tujuan:** Melacak saldo, pemasukan, dan pengeluaran untuk memberikan gambaran keuangan yang jelas.
*   **File Terkait:** `lib/model/dompet_model.dart`, `lib/data/operasi/dompet_operasi.dart`, `lib/halaman/tab/dompet.dart`.

### **Sinkronisasi Data dengan Firebase**
*   **Tujuan:** Memastikan konsistensi data antara database lokal (SQLite) dan backend (Firebase). Ini memungkinkan data tetap *up-to-date* dan dapat diakses dari mana saja.
*   **File Terkait:** `lib/data/servis/firebase_servis.dart`.
*   **Proses:** Layanan ini secara periodik melakukan **sinkronisasi inkremental**. Ia mengunggah data lokal yang baru dan mengunduh data terbaru dari Firebase, hanya berdasarkan data yang berubah sejak sinkronisasi terakhir. Proses ini sangat efisien karena menggunakan *timestamp* `diperbarui` pada setiap model data.

### **Notifikasi & Pengingat Jatuh Tempo**
*   **Tujuan:** Memberikan pengingat otomatis kepada admin agar dapat menindaklanjuti paket pelanggan yang akan segera berakhir masa aktifnya.
*   **File Terkait:**
    *   **`lib/data/servis/notifikasi_servis.dart`**: Layanan inti yang bertanggung jawab untuk menginisialisasi dan menjadwalkan notifikasi lokal menggunakan paket `flutter_local_notifications`.
    *   **`lib/halaman/tab/pelanggan_aktif.dart`**: Halaman ini memicu penjadwalan notifikasi setiap kali daftar pelanggan aktif dimuat.
*   **Mekanisme:**
    1.  Saat daftar pelanggan aktif ditampilkan, sistem akan memeriksa setiap pelanggan.
    2.  Notifikasi akan dijadwalkan untuk dua kondisi:
        *   **3 hari sebelum** tanggal kadaluarsa.
        *   **Tepat pada hari** kadaluarsa.
    3.  Untuk memastikan setiap notifikasi unik, ID notifikasi digenerasi dari `hashCode` ID pelanggan yang berupa string, sehingga menghindari konflik dan error saat runtime.

### **Kritik dan Saran Pengguna**
*   **Tujuan:** Menyediakan wadah bagi pengguna untuk memberikan masukan, yang kemudian dapat dilihat oleh administrator. Fitur ini sepenuhnya terintegrasi dengan sistem sinkronisasi data.
*   **File Terkait:**
    *   **`lib/model/kritik_saran_model.dart`**: Mendefinisikan struktur data untuk setiap masukan.
    *   **`lib/data/operasi/kritik_saran_operasi.dart`**: Menangani operasi CRUD di database SQLite lokal.
    *   **`lib/halaman/lainnya/kritik_saran.dart`**: Antarmuka pengguna untuk menampilkan daftar masukan.
    *   **`lib/data/servis/firebase_servis.dart`**: Mengintegrasikan sinkronisasi data kritik dan saran.

---

## **5. Alur Kerja Pengembangan**

1.  **Perencanaan & Blueprint:** AI akan menganalisis permintaan dan memperbarui file `blueprint.md` sebelum memulai kode.
2.  **Implementasi:** AI akan mengimplementasikan perubahan sesuai dengan standar kode yang ditetapkan.
3.  **Dokumentasi:** AI akan memperbarui komentar kode dan file `README.md` ini jika ada perubahan signifikan.
4.  **Verifikasi & Kualitas Kode:** Setelah setiap perubahan, AI akan menjalankan `flutter analyze` dan `dart format .` untuk memastikan kualitas kode.
5.  **Logging:** Aplikasi menggunakan pustaka `dart:developer` untuk pencatatan terstruktur.
