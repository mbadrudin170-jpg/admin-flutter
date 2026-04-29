# Daftar Perintah Terminal Flutter & Dart

Dokumen ini berisi kumpulan perintah terminal yang sering digunakan dalam pengembangan aplikasi Flutter untuk membantu manajemen proyek, dependensi, build, dan analisis kode.

---

## 1. Manajemen Proyek & Dependensi

### Membersihkan Proyek (`clean`)
Menghapus direktori `build` dan file-file lain yang dihasilkan oleh proses build. Berguna jika terjadi masalah terkait cache.
```sh
flutter clean
```

### Mendapatkan Dependensi (`pub get`)
Mengunduh semua dependensi yang terdaftar di file `pubspec.yaml`.
```sh
flutter pub get
```

### Memperbarui Dependensi (`upgrade`)
Memperbarui semua paket di `pubspec.yaml` ke versi terbaru yang kompatibel.
```sh
flutter pub upgrade
```

### Menambahkan Paket
Menambahkan paket baru ke `pubspec.yaml` dan langsung menjalakan `pub get`.
```sh
# Menambahkan dependensi utama
flutter pub add nama_paket

# Menambahkan dependensi pengembangan (misal: untuk testing)
flutter pub add dev:nama_paket
```

### Menghapus Paket
Menghapus paket dari `pubspec.yaml`.
```sh
flutter pub remove nama_paket
```

---

## 2. Proses Build & Menjalankan Aplikasi

### Membangun APK (`build apk`)
Membuat file APK untuk Android. Opsi `--split-per-abi` akan membuat APK terpisah untuk arsitektur prosesor yang berbeda, menghasilkan ukuran yang lebih kecil.
```sh
flutter build apk --split-per-abi
```

### Membangun App Bundle (`build appbundle`)
Membuat file Android App Bundle (AAB) yang direkomendasikan untuk rilis di Google Play Store.
```sh
flutter build appbundle
```

### Rangkaian Build Lengkap
Kombinasi perintah untuk memastikan proses build yang benar-benar bersih dari awal.
```sh
flutter clean && flutter pub get && flutter build apk --split-per-abi
```

### Menjalankan Aplikasi
Menjalankan aplikasi pada perangkat yang terhubung.
```sh
flutter run
```

---

## 3. Analisis & Kualitas Kode

### Menjalankan Analisis Kode (`analyze`)
Menganalisis basis kode untuk menemukan kemungkinan error dan pelanggaran gaya penulisan.
```sh
flutter analyze
```

### Menjalankan Tes (`test`)
Menjalankan semua tes yang ada di dalam direktori `test`.
```sh
flutter test
```

### Memformat Kode (`format`)
Secara otomatis memformat semua file Dart di proyek.
```sh
dart format .
```

---

## 4. Pembuatan Kode (`build_runner`)

### Menjalankan Build Runner
Membuat file-file yang diperlukan untuk paket seperti `freezed` atau `json_serializable`. Opsi `--delete-conflicting-outputs` menyelesaikan konflik file lama.
```sh
dart run build_runner build --delete-conflicting-outputs
```

---

## 5. Diagnostik & Pemecahan Masalah

### Flutter Doctor
Memeriksa lingkungan pengembangan Anda dan menampilkan laporan status instalasi.
```sh
flutter doctor -v
```

### Membersihkan Cache Gradle (Khusus Android)
Untuk masalah yang spesifik terkait Gradle. Jalankan dari dalam direktori `android`.
```sh
cd android
./gradlew clean
cd ..
```

### Menemukan File Terbesar (Linux/macOS)
Berguna untuk memeriksa apa yang paling banyak memakan ruang di proyek Anda.
```sh
# Menampilkan 10 file/direktori terbesar
du -ah . | sort -rh | head -n 10
```
