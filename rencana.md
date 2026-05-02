# mengatasi data tidak diunduh ke sqlit dari firebase

# Rencana untuk Mengatasi Masalah File Tidak Terhapus di Firebase

Berikut adalah rencana langkah-demi-langkah untuk mengatasi masalah file yang tidak terhapus di Firebase dan memastikan sinkronisasi data yang benar antara Firestore dan database lokal.

## Langkah 1: Analisis Kode yang Ada

- **Tujuan:** Memahami implementasi sinkronisasi data saat ini.
- **Tindakan:**
    - Periksa file `lib/data/services/sinkronisasi_database.dart`.
    - Fokus pada metode `_unduhData` dan `_unggahData` untuk memahami bagaimana data ditransfer antara database lokal (SQLite) dan Firestore.
    - Identifikasi bagaimana operasi `create`, `update`, dan `delete` saat ini ditangani (atau tidak ditangani).

## Langkah 2: Identifikasi Masalah

- **Tujuan:** Mengkonfirmasi akar penyebab masalah.
- **Masalah yang Diketahui:** Item yang dihapus di Firestore tidak dihapus dari database lokal.
- **Hipotesis:** Logika sinkronisasi saat ini hanya menangani pembuatan dan pembaruan data, tetapi tidak memperhitungkan penghapusan.

## Langkah 3: Implementasi Penanganan Penghapusan

- **Tujuan:** Menambahkan fungsionalitas untuk menyinkronkan penghapusan.
- **Tindakan:**
    - Ubah metode `_unduhData` untuk menangani item yang ditandai sebagai "dihapus" di Firestore.
    - Buat kueri untuk mengambil dokumen di mana flag `deleted` diatur ke `true`.
    - Untuk setiap dokumen yang dihapus yang diambil, hapus catatan yang sesuai dari tabel SQLite lokal.

## Langkah 4: Tambahkan `deleted` Flag

- **Tujuan:** Memungkinkan "penghapusan lunak" di Firestore tanpa kehilangan data secara permanen.
- **Tindakan:**
    - Di setiap koleksi Firestore (`pelanggan_aktif`, `dompet`, `kategori`, dll.), tambahkan field boolean baru bernama `deleted`.
    - Atur nilai default untuk `deleted` ke `false` untuk semua dokumen yang ada.
    - Saat item "dihapus" di aplikasi, perbarui dokumen yang sesuai di Firestore untuk mengatur `deleted` ke `true` alih-alih menghapusnya sepenuhnya.

## Langkah 5: Uji Solusi

- **Tujuan:** Memastikan bahwa penghapusan sekarang disinkronkan dengan benar.
- **Tindakan:**
    1. **Uji Manual:**
        - Buka Konsol Firebase dan navigasikan ke salah satu koleksi Anda.
        - Perbarui dokumen secara manual dengan mengatur field `deleted` menjadi `true`.
        - Jalankan aplikasi dan mulai proses sinkronisasi.
        - Verifikasi bahwa catatan yang sesuai telah dihapus dari database SQLite lokal.
    2. **Uji Otomatis (Opsional):**
        - Tulis tes unit atau integrasi untuk memvalidasi alur sinkronisasi penghapusan.

## Langkah 6: Hapus Rencana

- **Tujuan:** Membersihkan file rencana setelah tugas selesai.
- **Tindakan:**
    - Setelah semua langkah di atas selesai dan diverifikasi, hapus file `rencana.md` ini dari proyek.
