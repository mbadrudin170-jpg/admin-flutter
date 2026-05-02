Baik, berikut aturan yang telah diperbarui dengan penomoran dan bahasa yang lebih formal dan jelas, siap untuk ditambahkan ke file README.md Anda:

# **Aturan Lainnya untuk AI**

1.  **Penggunaan Bahasa**: Seluruh penamaan dalam kode, termasuk namun tidak terbatas pada fungsi, variabel, parameter, dan nama file, wajib menggunakan Bahasa Indonesia. Bahasa Indonesia juga wajib digunakan dalam setiap sesi komunikasi atau percakapan.

2.  **Komentar Path File**: Setiap file kode wajib memiliki komentar yang menunjukkan path atau lokasi file tersebut. Komentar ini harus diletakkan di bagian paling atas file dengan format: `// path : lib/path/nama_file.dart`.

3.  **Konsultasi Proyek**: Sebelum memulai eksekusi tugas apa pun, sistem diharuskan untuk membaca dan memahami keseluruhan isi dari file `README.md` guna mengetahui alur kerja, aturan, serta konteks proyek secara menyeluruh.

4.  **Dokumentasi Pasca Pengerjaan**: Setelah menyelesaikan pengerjaan pada suatu file, sistem wajib menambahkan atau memperbarui keterangan mengenai fungsi dan fitur yang terdapat di dalam file yang telah dikerjakan. Keterangan ini harus ditulis per file di dalam `README.md` untuk memudahkan identifikasi dan pemeliharaan.

5.  **Prosedur Build**: Sebelum melakukan build proyek, sistem wajib membaca file `README.md` terlebih dahulu untuk mengidentifikasi apakah perubahan yang dilakukan berupa fitur baru atau hanya perbaikan bug. Apabila hanya perbaikan bug, tingkatkan hanya nomor build, bukan versi pada file `pubspec.yaml`. Proses build hanya boleh dilakukan setelah mendapatkan perintah eksplisit dari pengguna, dengan menjalankan perintah: `flutter clean && flutter pub get && flutter build apk --release --split-per-abi`.

6.  **Konsistensi dan Kejelasan**: Sistem wajib menjaga konsistensi dan kejelasan dalam setiap aspek proyek, termasuk penulisan kode, dokumentasi, dan komunikasi, setiap saat.

7.  **Format Pembaruan README.md**: Setelah pengerjaan file selesai, sistem wajib mengedit atau menambahkan bagian dokumentasi file di `README.md` berdasarkan folder tempat file tersebut berada. Penulisan dokumentasi harus mengikuti format rinci di bawah ini agar rekan kerja dapat memahami aturan dan isi proyek tanpa kebingungan:
    ```
    File: lib/path/nama_file.dart
    Fitur: [Nama Fitur]
    Daftar Fungsi:
    namaFungsiA(): [Penjelasan singkat kegunaan fungsi.]
    namaFungsiB(): [Penjelasan singkat kegunaan fungsi.]
    Catatan: [Informasi tambahan jika ada.]
    Rules: [Ketentuan atau aturan spesifik yang berlaku pada file ini, misalnya format tanggal, jam, atau angka.]
    ```

8.  **Komentar Perubahan Kode**: Setiap perubahan yang dilakukan pada kode (baik penghapusan, perubahan, maupun penambahan) wajib diberi komentar di samping atau di atas baris kode terkait dengan struktur penjelasan berikut: `// [dihapus/diubah/ditambah]: [alasan perubahan dilakukan].`

9.  **Analisis Statis**: Setelah menyelesaikan seluruh tugas pada suatu sesi pengerjaan, sistem wajib menjalankan perintah `flutter analyze` di terminal untuk memastikan bahwa kode telah terbebas dari galat (*error*) dan peringatan (*warning*).

10. **Konfirmasi Pekerjaan**: Sebelum memulai eksekusi teknis, sistem wajib memberikan penjelasan mengenai alasan dan rencana pekerjaan yang akan dilakukan. Eksekusi hanya boleh dilanjutkan setelah mendapatkan konfirmasi eksplisit dari pengguna melalui respons positif (contoh: "setuju", "oke", "ok", "ya", "yes"). Sebaliknya, jika pengguna memberikan respons negatif (contoh: "jangan", "tidak", "nggk", "nggak"), pekerjaan tidak boleh dilaksanakan.

11. **Dokumentasi Fungsi**: Setiap fungsi yang dibuat atau diubah wajib dilengkapi dengan komentar penjelas yang menerangkan tujuan atau alasan pembuatan fungsi tersebut. Komentar diletakkan di atas deklarasi fungsi dengan format: `// [Penjelasan tujuan atau alasan fungsi dibuat.]`

12. **Komentar Tambahan pada Kode**: Sistem diharapkan untuk menambahkan komentar secukupnya pada bagian-bagian kode yang kompleks atau krusial di dalam file, guna mengurangi potensi kebingungan saat membaca atau memelihara kode di masa mendatang.

13. **Perintah Clean**: Apabila pengguna memberikan perintah "clean", sistem wajib menjalankan perintah `flutter clean && flutter pub get` di terminal untuk membersihkan dan memperbarui dependensi proyek.

14. **Larangan Berasumsi**: Sistem dilarang keras membuat asumsi liar terkait logika, implementasi, atau ketergantungan antar-file. Setiap file harus dipastikan selaras dan sinkron satu sama lain berdasarkan implementasi yang telah dikonfirmasi.

15. **Pola Pemrograman Asynchronous**: Setiap fungsi yang melibatkan operasi I/O, network request, atau akses basis data wajib menggunakan pola Asynchronous (`async/await`) dan membungkus hasilnya dalam objek `Future`. Penggunaan metode `.then()` secara berantai tidak diperkenankan.

16. **Pratinjau Kode Sebelum Eksekusi**: Sebelum mengeksekusi perubahan pada suatu file, sistem wajib menampilkan potongan atau blok kode spesifik yang akan diperbarui (bukan keseluruhan isi file) untuk ditinjau dan dikonfirmasi oleh pengguna.

17. **Pengecekan Mounted pada Widget**: Dalam konteks operasi asynchronous pada StatefulWidget, sistem wajib menggunakan pengecekan `if (!mounted) return;` setelah operasi `await` untuk mencegah potensi galat akibat widget sudah tidak berada di dalam widget tree.

**Kritik dan Saran untuk Peningkatan Profesionalisme Proyek:**

*   **Fitur**: Disarankan untuk mengadopsi mekanisme state management yang lebih terstruktur (seperti Provider, Riverpod, atau BLoC) ketika kompleksitas proyek meningkat. Hal ini memisahkan logika UI dari logika bisnis secara lebih bersih. Selain itu, terapkanlah sistem penanganan galat global yang menyajikan dialog atau notifikasi yang informatif kepada pengguna untuk setiap kegagalan yang tidak tertangani, guna meningkatkan pengalaman pengguna.
*   **Pengelolaan**: Aturan penulisan kode yang ketat akan lebih optimal jika diselaraskan dengan berkas `analysis_options.yaml`. Konfigurasikan linter agar dapat mengawasi dan menegakkan aturan penamaan, format, dan praktik terbaik secara otomatis, sehingga mengurangi ketergantungan pada pemeriksaan manual. Proyek juga akan terlihat lebih profesional jika memiliki panduan gaya kode (style guide) tertulis yang menjadi acuan bersama seluruh tim.
*   **Efisiensi**: Konfigurasikan alur Continuous Integration (CI) dasar yang secara otomatis menjalankan `flutter analyze` dan `flutter test` pada setiap pull request atau commit. Langkah ini memastikan bahwa semua aturan yang telah disepakati dipatuhi secara konsisten tanpa perlu diingat secara manual, serta secara signifikan meningkatkan keandalan dan stabilitas kode sebelum digabungkan ke cabang utama.

__________________________________________


## **Modifikasi Kode & Manajemen Dependensi**

AI diberdayakan untuk memodifikasi basis kode Flutter dan mengelola dependensinya secara mandiri berdasarkan permintaan pengguna dan masalah yang terdeteksi. AI bersifat kreatif dan mengantisipasi fitur yang mungkin dibutuhkan pengguna meskipun tidak diminta secara eksplisit.

* **Asumsi Kode Inti:** Ketika pengguna meminta perubahan (misalnya, "Tambahkan tombol untuk menavigasi ke layar baru"), AI akan fokus utama pada modifikasi kode Dart. lib/main.dart diasumsikan sebagai titik masuk utama, dan AI akan menyimpulkan file relevan lainnya (misalnya, membuat file widget baru, memperbarui pubspec.yaml).
* **Manajemen Paket:** Jika fitur baru memerlukan paket eksternal, AI akan mengidentifikasi paket yang paling sesuai dan stabil dari pub.dev.
  * Untuk menambahkan dependensi biasa, ia akan menjalankan `flutter pub add <nama_paket>`.
  * Untuk menambahkan dependensi pengembangan (misalnya, untuk pengujian atau pembuatan kode), ia akan menjalankan `flutter pub add dev:<nama_paket>`.
* **Pembuatan Kode (build_runner):**
  1. Ketika perubahan memperkenalkan kebutuhan untuk pembuatan kode (misalnya, untuk kelas freezed, model json_serializable, atau riverpod_generator), AI akan:
     1. Memastikan build_runner terdaftar di dev_dependencies di pubspec.yaml.
     2. Secara otomatis menjalankan `dart run build_runner build --delete-conflicting-outputs`.
* **Kualitas Kode:** AI bertujuan untuk mematuhi praktik terbaik Flutter/Dart, termasuk:
  * Struktur kode yang bersih dan pemisahan masalah (misalnya, logika UI terpisah dari logika bisnis).
  * Konvensi penamaan yang bermakna dan konsisten.
  * Penggunaan efektif konstruktor dan widget const untuk optimisasi kinerja.
  * Solusi manajemen status yang sesuai (misalnya, Provider).
  * Menghindari komputasi atau operasi I/O yang mahal secara langsung di dalam metode build.
  * Penggunaan async/await yang benar untuk operasi asinkron dengan penanganan kesalahan yang kuat.

## **Deteksi & Perbaikan Kesalahan Otomatis**

Fungsi penting dari AI adalah untuk terus memantau dan secara otomatis menyelesaikan kesalahan untuk menjaga status aplikasi tetap dapat dijalankan dan benar.

* **Pemeriksaan Pasca-Modifikasi:** Setelah *setiap* modifikasi kode (termasuk menambahkan paket, menjalankan pembuatan kode, atau memodifikasi file yang ada), AI akan:
  1. Memantau diagnostik IDE (panel masalah) dan output terminal (dari `flutter run`, `flutter analyze`) untuk kesalahan kompilasi, peringatan analisis Dart, dan pengecualian runtime.
  2. Memeriksa output server pratinjau untuk masalah rendering, kerusakan aplikasi, atau perilaku tak terduga.
* **Koreksi Kesalahan Otomatis:** AI akan mencoba memperbaiki kesalahan yang terdeteksi secara otomatis. Ini termasuk, tetapi tidak terbatas pada:
  * Kesalahan sintaksis dalam kode Dart.
  * Ketidakcocokan tipe dan pelanggaran keamanan null.
  * Impor yang belum terselesaikan atau referensi paket yang hilang.
  * Pelanggaran aturan linting (AI akan secara otomatis menjalankan `flutter format .` dan mengatasi peringatan lint).
  * Ketika kesalahan analisis terdeteksi, AI pertama-tama akan mencoba menyelesaikannya dengan menjalankan `flutter fix --apply .`.
  * Masalah umum khusus Flutter seperti memanggil setState pada widget yang tidak dipasang, pembuangan sumber daya yang tidak benar dalam metode dispose(), atau struktur pohon widget yang salah.
  * Memastikan penanganan kesalahan asinkron yang benar (misalnya, menambahkan blok try-catch untuk operasi Future, menggunakan pemeriksaan terpasang sebelum setState).
* **Pelaporan Masalah:** Jika kesalahan tidak dapat diselesaikan secara otomatis (misalnya, kesalahan logika yang memerlukan klarifikasi pengguna, atau masalah lingkungan), AI akan dengan jelas melaporkan pesan kesalahan spesifik, lokasinya, dan penjelasan singkat dengan intervensi manual yang disarankan atau pendekatan alternatif kepada pengguna.

## **Spesifikasi Desain Material**

### **Tema**

AI akan mengimplementasikan dan mengelola tema yang komprehensif dan konsisten untuk aplikasi, dengan mematuhi prinsip-prinsip Desain Material 3. Ini termasuk mendefinisikan skema warna, tipografi, dan gaya komponen dalam objek `ThemeData` terpusat.

#### **Skema Warna (Material 3)**

AI akan memprioritaskan penggunaan `ColorScheme.fromSeed` untuk menghasilkan palet warna yang harmonis dan dapat diakses dari satu warna benih. Ini adalah dasar dari tema Material 3 dan mendukung warna dinamis pada platform seperti Android.

#### **Tipografi dan Font Kustom**

AI akan menggunakan `TextTheme` untuk mendefinisikan gaya teks yang konsisten (misalnya, `displayLarge`, `titleMedium`, `bodySmall`). Untuk menggunakan font kustom, AI akan mereferensikannya berdasarkan `family` yang didefinisikan di `pubspec.yaml`.

*Contoh `pubspec.yaml` untuk font kustom:*
```yaml
flutter:
  fonts:
    - family: Oswald
      fonts:
        - asset: assets/fonts/Oswald.ttf
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Medium.ttf
          weight: 500
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
    - family: Open Sans
      fonts:
        - asset: assets/fonts/OpenSans.ttf
```

*Contoh `TextTheme` dengan font kustom lokal:*

```dart
import 'package:flutter/material.dart';

final TextTheme myTextTheme = TextTheme(
  displayLarge: TextStyle(fontFamily: 'Oswald', fontSize: 57, fontWeight: FontWeight.bold),
  titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 22, fontWeight: FontWeight.w500),
  bodyMedium: TextStyle(fontFamily: 'Open Sans', fontSize: 14),
);
```

#### **Tema Komponen**

Untuk memastikan konsistensi UI, AI akan menggunakan properti tema spesifik (misalnya, `appBarTheme`, `elevatedButtonTheme`) untuk menyesuaikan tampilan masing-masing komponen Material.

#### **Mode Gelap/Terang dan Pengalih Tema**

AI akan mengimplementasikan dukungan untuk tema terang dan gelap. Solusi manajemen status seperti `provider` sangat ideal untuk membuat pengalih tema yang menghadap pengguna (`ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`).

#### **Contoh Tema Lengkap**

Contoh berikut menunjukkan pengaturan tema lengkap menggunakan `provider` untuk pengalih tema dan font lokal.

Untuk menggunakan `provider`, tambahkan ke proyek Anda:

```shell
flutter pub add provider
```

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Impor Provider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// Kelas ThemeProvider untuk mengelola status tema
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Default ke tema sistem

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.deepPurple;

    // Definisikan TextTheme umum
    final TextTheme appTextTheme = TextTheme(
      displayLarge: TextStyle(fontFamily: 'Oswald', fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontFamily: 'Open Sans', fontSize: 14),
    );

    // Tema Terang
    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto', // Set font default
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontFamily: 'Oswald', fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    // Tema Gelap
    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto', // Set font default
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontFamily: 'Oswald', fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: primarySeedColor.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Material AI App',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material AI Demo'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.auto_mode),
            onPressed: () => themeProvider.setSystemTheme(),
            tooltip: 'Set System Theme',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome!', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 20),
            Text('This text uses a custom font.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: () {}, child: const Text('Press Me')),
          ],
        ),
      ),
    );
  }
}
```

### **Aset, Gambar, dan Ikon**

Widget-widget ini digunakan untuk mengelola dan menampilkan berbagai jenis aset, termasuk gambar dan ikon.

* **Deklarasi Aset di pubspec.yaml**: Sebelum menggunakan aset, aset tersebut harus dideklarasikan di file pubspec.yaml. AI akan meminta pengguna untuk memastikan ini dikonfigurasi dengan benar atau menambahkannya jika perlu.

```yaml
# Di pubspec.yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/ # Contoh: seluruh folder
    - assets/icons/my_icon.png # Contoh: file spesifik
```

* **Image.asset**: Menampilkan gambar dari bundel aset aplikasi.

```dart
// Dengan asumsi 'assets/images/placeholder.png' dideklarasikan di pubspec.yaml
Image.asset(
  'assets/images/placeholder.png',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)
```

* **Image.network**: Menampilkan gambar dari URL.

```dart
Image.network(
  'https://picsum.photos/200/300',
  width: 200,
  height: 300,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.progress,
      ),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.error, color: Colors.red, size: 50);
  },
)
```

* **Ikon**: Menampilkan ikon Desain Material (dari kelas Ikon).

```dart
const Icon(
  Icons.favorite,
  color: Colors.red,
  size: 30.0,
)
```

* **ImageIcon**: Menampilkan ikon dari ImageProvider (berguna untuk ikon kustom yang tidak ada di kelas Ikon).

```dart
// Dengan asumsi 'assets/icons/custom_icon.png' dideklarasikan di pubspec.yaml
ImageIcon(
  const AssetImage('assets/icons/custom_icon.png'),
  size: 24,
  color: Colors.green,
)
```

### **Perutean dan Navigasi**

Flutter menyediakan mekanisme yang kuat untuk bernavigasi di antara berbagai layar (rute) dalam sebuah aplikasi. AI akan memanfaatkan dan merekomendasikan strategi perutean yang sesuai berdasarkan kompleksitas dan persyaratan alur navigasi.

* **Navigasi Imperatif Dasar (Navigator)**: Untuk tumpukan navigasi sederhana, Navigator bawaan Flutter sangat mudah.
  * **Navigator.push**: Mendorong rute baru ke tumpukan navigator.

```dart
// Dari Layar A ke Layar B
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ScreenB()),
);
```

* **Navigator.pop**: Melepas rute teratas dari tumpukan navigator.

```dart
// Dari Layar B kembali ke Layar A
Navigator.pop(context);
```

* **Navigator.pushReplacement**: Mengganti rute saat ini dengan yang baru.

```dart
// Ganti layar saat ini dengan yang baru (misalnya, setelah login)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
);
```

* **Navigasi Deklaratif dengan go_router**: Untuk navigasi yang lebih kompleks, tautan dalam, dan dukungan web, paket go_router adalah solusi yang kuat dan direkomendasikan. AI akan mengintegrasikan dan mengonfigurasi go_router ketika navigasi deklaratif atau fitur-fitur canggih seperti tautan dalam diperlukan.
  Untuk menggunakan go_router, pertama-tama tambahkan ke proyek Anda dengan menjalankan:

```shell
flutter pub add go_router
```

  **Contoh Konfigurasi go_router:**

```dart
// Di main.dart atau file router.dart khusus
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Definisikan rute Anda
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen(); // Layar beranda Anda
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:id', // Rute dengan parameter path
          builder: (BuildContext context, GoRouterState state) {
            final String id = state.pathParameters['id']!;
            return DetailScreen(id: id); // Layar untuk menampilkan detail
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen(); // Layar pengaturan Anda
          },
        ),
      ],
    ),
  ],
);

// Di MaterialApp atau CupertinoApp Anda
/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'GoRouter Example',
      // ... data tema Anda
    );
  }
}
*/

// Contoh layar untuk router
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/details/123'), // Navigasi ke detail dengan ID
              child: const Text('Go to Details 123'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/settings'), // Navigasi ke pengaturan
              child: const Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Screen: $id')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.pop(), // Kembali
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.pop(), // Kembali
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}
```

* **Tautan Dalam**: go_router menangani tautan dalam secara otomatis berdasarkan path URL yang ditentukan, memungkinkan layar tertentu dibuka langsung dari sumber eksternal (misalnya, tautan web, notifikasi push).
* **Pengalihan Otentikasi**: AI dapat mengonfigurasi properti pengalihan go_router untuk menangani alur otentikasi, memastikan pengguna dialihkan ke layar login saat tidak sah, dan kembali ke tujuan yang dimaksud setelah login berhasil.

## **Arsitektur Aplikasi**

Bagian ini menguraikan pendekatan AI untuk menyusun aplikasi Flutter, yang mencakup konsep arsitektur inti, pola yang direkomendasikan, dan prinsip desain untuk memastikan pemeliharaan, skalabilitas, dan kemampuan pengujian.

### **Konsep Arsitektur**

AI akan memahami dan menerapkan konsep arsitektur fundamental di Flutter:

* **Widget adalah UI**: Semua yang ada di UI Flutter adalah widget. AI akan menyusun UI yang kompleks dari widget yang lebih kecil dan dapat digunakan kembali.
* **Imutabilitas**: Widget (terutama StatelessWidget) bersifat abadi. Saat UI perlu diubah, Flutter membangun kembali pohon widget.
* **Manajemen Status**: Memahami pentingnya mengelola status yang dapat diubah. AI akan merekomendasikan dan menerapkan solusi manajemen status yang sesuai berdasarkan kompleksitas aplikasi.
* **Pemisahan Masalah**: Berusaha untuk memisahkan UI (widget), logika bisnis, dan lapisan data untuk meningkatkan pengaturan kode, kemampuan pengujian, dan pemeliharaan.

### **Rekomendasi Manajemen Status**

Pilihan solusi manajemen status bergantung pada skala dan kompleksitas proyek. AI akan merekomendasikan dan menggunakan alat yang paling sesuai dan sederhana untuk pekerjaan itu, dimulai dengan kemampuan manajemen status bawaan Flutter dan menggunakan `provider` untuk skenario yang lebih kompleks.

* **Manajemen Status Lokal (Bawaan)**

  * **ValueNotifier & ValueListenableBuilder**: Untuk mengelola status satu nilai. Ini adalah opsi yang paling ringan dan efisien untuk status lokal sederhana (misalnya, penghitung, bendera boolean, atau teks di bidang). AI akan menggunakan `ValueListenableBuilder` untuk memastikan hanya widget yang bergantung pada status yang dibangun kembali.

    *Contoh:*

```dart
// 1. Definisikan ValueNotifier untuk menampung status.
final ValueNotifier<int> _counter = ValueNotifier<int>(0);

// 2. Gunakan ValueListenableBuilder untuk mendengarkan dan membangun kembali.
ValueListenableBuilder<int>(
  valueListenable: _counter,
  builder: (context, value, child) {
    return Text('Count: $value');
  },
)

// 3. Perbarui nilai secara langsung.
_counter.value++;
```

  * **Stream & StreamBuilder**: Untuk menangani urutan peristiwa asinkron, seperti data dari permintaan jaringan, input pengguna, atau stream Firebase. `StreamBuilder` mendengarkan stream dan membangun kembali UI-nya setiap kali data baru dipancarkan.

  * **Future & FutureBuilder**: Untuk menangani satu operasi asinkron yang akan selesai di masa mendatang, seperti mengambil data dari API. `FutureBuilder` menampilkan widget berdasarkan status `Future` (misalnya, menampilkan pemintal pemuatan saat menunggu, data saat selesai, atau pesan kesalahan).


* **Manajemen Status dan Injeksi Ketergantungan di Seluruh Aplikasi**

  * **ChangeNotifier & ChangeNotifierProvider**: Ketika status lebih kompleks daripada satu nilai atau perlu dibagikan di beberapa widget yang bukan turunan langsung. AI akan menggunakan `ChangeNotifier` untuk merangkum status dan logika bisnis, dan `ChangeNotifierProvider` untuk menyediakannya ke pohon widget. Ini adalah pola dasar untuk paket `provider`.

  * **Provider**: Untuk injeksi ketergantungan dan mengelola status yang perlu diakses di beberapa tempat di seluruh aplikasi. AI akan menggunakan `provider` untuk menyediakan layanan, repositori, atau objek status kompleks ke lapisan UI tanpa penggandengan yang erat. Ini adalah pendekatan yang direkomendasikan untuk aplikasi menengah hingga besar.

### **Aliran Data dan Layanan**

AI akan merancang aliran data secara searah, biasanya dari sumber data (misalnya, jaringan, basis data) melalui layanan/repositori ke lapisan manajemen status, dan akhirnya ke UI.

* **Repositori/Layanan**: Untuk mengabstraksi sumber data (misalnya, panggilan API, operasi basis data). Ini mendorong kemampuan pengujian dan memungkinkan pertukaran sumber data yang mudah.
* **Model/Entitas**: Mendefinisikan struktur data (kelas) untuk mewakili data yang digunakan dalam aplikasi.
* **Injeksi Ketergantungan**: Gunakan injeksi konstruktor sederhana atau paket seperti provider untuk mengelola dependensi antara berbagai lapisan aplikasi.

### **Pola Arsitektur Umum**

AI akan menerapkan pola arsitektur umum untuk memastikan aplikasi yang terstruktur dengan baik:

* **MVC (Model-View-Controller) / MVVM (Model-View-ViewModel) / MVI (Model-View-Intent)**: Meskipun sifat widget-sentris Flutter membuat kepatuhan ketat pada pola-pola ini menjadi tantangan, AI akan bertujuan untuk pemisahan masalah yang serupa.
  * **Model**: Lapisan data dan logika bisnis.
  * **Tampilan**: UI (widget).
  * **Pengontrol/ViewModel/Presenter**: Menangani logika UI, berinteraksi dengan model, dan memperbarui tampilan.
* **Arsitektur Berlapis**: Mengatur proyek ke dalam lapisan logis seperti:
  * presentasi (UI, widget, halaman)
  * domain (logika bisnis, model, kasus penggunaan)
  * data (repositori, sumber data, klien API)
  * inti (utilitas bersama, ekstensi umum)
* **Struktur Berbasis Fitur**: Mengatur kode berdasarkan fitur, di mana setiap fitur memiliki subfolder presentasi, domain, dan datanya sendiri. Ini meningkatkan kemampuan navigasi dan skalabilitas untuk proyek yang lebih besar.

### **Penanganan Kesalahan dan Pencatatan**

* **Penanganan Kesalahan Terpusat**: Menerapkan mekanisme untuk menangani kesalahan dengan baik di seluruh aplikasi (misalnya, menggunakan blok try-catch, tipe Either untuk penanganan kesalahan fungsional, atau penangan kesalahan global).
* **Pencatatan**: Memasukkan pencatatan untuk debugging dan memantau perilaku aplikasi.

### **Pencatatan dengan `dart:developer`**

Untuk debugging dan pemantauan yang efektif, AI akan menggunakan pustaka `dart:developer`, yang menyediakan pencatatan terstruktur yang terintegrasi dengan Dart DevTools.

* **Pencatatan Dasar**: Untuk pesan sederhana, fungsi `log` digunakan.

```dart
import 'dart:developer' as developer;

developer.log('This is a simple log message.');
```

* **Pencatatan Terstruktur**: Untuk log yang lebih detail, fungsi `log` menerima beberapa parameter opsional:

  * `name`: Sebuah `String` untuk mengkategorikan pesan log (misalnya, 'my_app.network').
  * `level`: Sebuah `int` untuk tingkat keparahan (misalnya, `800` untuk `INFO`, `900` untuk `WARNING`, `1000` untuk `SEVERE`).
  * `error`: Sebuah `Object` untuk mencatat pengecualian.
  * `stackTrace`: Sebuah objek `StackTrace`.


  *Contoh:*

```dart
import 'dart:developer' as developer;

try {
  throw 'Something went wrong!';
} catch (e, s) {
  developer.log(
    'An error occurred',
    name: 'my_app.network',
    level: 900, // WARNING
    error: e,
    stackTrace: s,
  );
}
```

* **Melihat Log**: Log terstruktur dapat dilihat di "Debug Console" IDE atau, untuk analisis yang lebih mendalam, di tab "Logging" Dart DevTools. Ini memungkinkan untuk memfilter dan memeriksa entri log, membuat debugging lebih efisien.

## **AI Generatif dengan Firebase**

Saat pengguna meminta fitur yang melibatkan AI generatif (teks, gambar, atau multimodal), AI akan menggunakan Firebase AI SDK untuk Dart (`firebase_ai`). Ini menyediakan cara yang aman dan terintegrasi untuk mengakses model Gemini dan Imagen Google.

### **Pengaturan dan Konfigurasi**

Jika AI generatif diminta untuk pertama kalinya, AI akan melakukan langkah-langkah pengaturan berikut:

1. **Aktifkan Gemini API**: AI akan menginstruksikan pengguna untuk membuka Firebase Console, memilih "Build with Gemini," dan mengaktifkan Gemini API. Ini adalah langkah manual bagi pengguna.
2. **Tambahkan Dependensi**: AI akan menambahkan paket yang diperlukan ke `pubspec.yaml`.

```shell
flutter pub add firebase_core firebase_ai
```

3. **Inisialisasi Firebase**: AI akan memastikan Firebase diinisialisasi di `lib/main.dart`.

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

4. **Keamanan Kunci API**: AI akan **tidak pernah** melakukan hardcode kunci API dalam kode sumber. Paket `firebase_ai` menangani ini dengan aman dengan berkomunikasi dengan layanan backend Google, yang dilindungi oleh Firebase App Check.

### **Pembuatan Teks (Gemini)**

Untuk fitur pembuatan teks, peringkasan, atau obrolan, AI akan menggunakan model Gemini.

* **Pemilihan Model**: AI akan default ke `gemini-1.5-flash` untuk keseimbangan kecepatan dan kemampuannya.
* **Implementasi**:

```dart
import 'package:firebase_ai/firebase_ai.dart';

Future<String> generateText(String promptText) async {
  try {
    // 1. Dapatkan model generatif
    final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');

    // 2. Hasilkan konten
    final response = await model.generateContent([Content.text(promptText)]);

    // 3. Kembalikan teks
    return response.text ?? 'No response from model.';
  } catch (e) {
    return 'Error generating text: $e';
  }
}
```

### **Pembuatan Multimodal (Gemini Vision)**

Untuk fitur yang memerlukan pemahaman gambar (misalnya, "apa yang ada di gambar ini?"), AI akan menggunakan model Gemini Vision.

* **Implementasi**: AI akan mengharapkan data gambar sebagai `Uint8List`.

```dart
import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';

Future<String> analyzeImage(String promptText, Uint8List imageData) async {
  try {
    // 1. Dapatkan model generatif
    final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash-vision');

    // 2. Buat konten multimodal
    final content = Content.multi([
      TextPart(promptText),
      DataPart('image/jpeg', imageData), // Mengasumsikan format JPEG
    ]);

    // 3. Hasilkan konten
    final response = await model.generateContent([content]);

    // 4. Kembalikan teks
    return response.text ?? 'No response from model.';
  } catch (e) {
    return 'Error analyzing image: $e';
  }
}
```

### **Pembuatan Gambar (Imagen)**

Untuk menghasilkan gambar berkualitas tinggi dari perintah teks, AI akan menggunakan model Imagen.

* **Implementasi**:

```dart
import 'package:firebase_ai/firebase_ai.dart';

Future<List<ImageData>> generateImage(String prompt) async {
  try {
    // 1. Dapatkan model Imagen
    final imagenModel = FirebaseVertexAI.instance.imagenModel();

    // 2. Hasilkan gambar
    final result = await imagenModel.generateImages(
      prompt: prompt,
      numberOfImages: 1, // Default untuk menghasilkan satu gambar
    );

    return result;
  } catch (e) {
    // Tangani kesalahan
    return [];
  }
}
```

  AI kemudian akan bertanggung jawab untuk memproses `ImageData` yang dikembalikan, yang berisi byte gambar, dan menampilkannya di UI (misalnya, menggunakan `Image.memory`).

### **Penyematan Teks (Gecko)**

Untuk fitur yang memerlukan pencarian semantik, klasifikasi, atau pengelompokan, AI akan menghasilkan penyematan teks.

* **Pemilihan Model**: AI akan menggunakan model penyematan teks seperti `text-embedding-004`.
* **Implementasi**:

```dart
import 'package:firebase_ai/firebase_ai.dart';

Future<List<double>?> generateEmbedding(String text) async {
  try {
    // 1. Dapatkan model penyematan
    final embeddingModel = FirebaseVertexAI.instance.embeddingModel(model: 'text-embedding-004');

    // 2. Hasilkan penyematan
    final result = await embeddingModel.embedContent([Content.text(text)]);

    // 3. Kembalikan vektor penyematan
    return result.embeddings.first.values;
  } catch (e) {
    // Tangani kesalahan
    return null;
  }
}
```

AI akan menggunakan penyematan ini sebagai vektor untuk tugas hilir, seperti menyimpannya di basis data vektor (misalnya, Firestore dengan ekstensi vektor) untuk pencarian kesamaan.

## **Pembuatan & Pelaksanaan Tes**

Saat diminta, AI akan memfasilitasi pembuatan dan pelaksanaan tes, memastikan keandalan kode dan memvalidasi fungsionalitas.

* **Penulisan Tes:**
  * Atas permintaan pengguna untuk tes (misalnya, "Tulis tes untuk fitur baru ini"), AI akan menghasilkan file tes yang sesuai (misalnya, test/\<nama_file\>_test.dart).
  * Untuk fungsi, metode, atau kelas baru, terutama yang berisi logika bisnis, AI akan memprioritaskan penulisan tes unit komprehensif menggunakan kerangka kerja package:test/test.dart.
  * AI akan secara otomatis mengatur mocking (misalnya, menggunakan mockito) untuk mengisolasi unit yang diuji dari dependensinya.
  * Tes akan dirancang untuk mencakup berbagai nilai input, kasus tepi, dan skenario kesalahan.
* **Pelaksanaan Tes Otomatis:**
  * Setelah membuat atau memodifikasi tes, dan setelah perubahan kode yang signifikan, AI akan secara otomatis menjalankan tes yang relevan menggunakan `flutter test` di terminal.
  * AI akan melaporkan hasil tes (lulus/gagal, dengan detail kegagalan) kepada pengguna.
  * Untuk validasi aplikasi yang lebih luas, AI dapat menyarankan atau menjalankan tes integrasi (`flutter test integration_test/app_test.dart`) jika sesuai.
* **Iterasi Berbasis Tes:** AI mendukung pendekatan berbasis tes berulang, di mana fitur baru atau perbaikan bug disertai dengan tes yang relevan, yang kemudian dijalankan untuk memvalidasi perubahan dan memberikan umpan balik segera.

## **Desain Visual**

**Estetika:** AI selalu memberikan kesan pertama yang hebat dengan menciptakan pengalaman pengguna yang unik yang menggabungkan komponen modern, tata letak yang seimbang secara visual dengan spasi yang bersih, dan gaya yang dipoles yang mudah dipahami.

1. Bangun antarmuka pengguna yang indah dan intuitif yang mengikuti pedoman desain modern.
2. Pastikan aplikasi Anda responsif seluler dan beradaptasi dengan ukuran layar yang berbeda, berfungsi sempurna di seluler dan web.
3. Usulkan warna, font, tipografi, ikonografi, animasi, efek, tata letak, tekstur, bayangan jatuh, gradien, dll.
4. Jika gambar diperlukan, buatlah relevan dan bermakna, dengan ukuran, tata letak, dan lisensi yang sesuai (misalnya, tersedia secara gratis). Jika gambar asli tidak tersedia, sediakan gambar placeholder.
5. Jika ada beberapa halaman untuk berinteraksi dengan pengguna, sediakan bilah navigasi atau kontrol yang intuitif dan mudah.

**Definisi Tebal:** AI menggunakan ikonografi, gambar, dan komponen UI modern dan interaktif seperti tombol, bidang teks, animasi, efek, gerakan, bilah geser, korsel, navigasi, dll.

1. Font - Pilih tipografi yang ekspresif dan relevan. Tekankan dan tekankan ukuran font untuk memudahkan pemahaman, misalnya, teks pahlawan, tajuk bagian, tajuk daftar, kata kunci dalam paragraf, dll.
2. Warna - Sertakan berbagai konsentrasi warna dan rona dalam palet untuk menciptakan tampilan dan nuansa yang cerah dan energik.
3. Tekstur - Terapkan tekstur noise halus ke latar belakang utama untuk menambahkan nuansa premium dan taktil.
4. Efek visual - Bayangan jatuh berlapis-lapis menciptakan kesan kedalaman yang kuat. Kartu memiliki bayangan lembut dan dalam agar terlihat \"terangkat\".
5. Ikonografi - Gabungkan ikon untuk meningkatkan pemahaman pengguna dan navigasi logis aplikasi.
6. Interaktivitas - Tombol, kotak centang, bilah geser, daftar, bagan, grafik, dan elemen interaktif lainnya memiliki bayangan dengan penggunaan warna yang elegan untuk menciptakan efek \"bersinar\".

## **Standar Aksesibilitas atau A11Y:** Terapkan fitur aksesibilitas untuk memberdayakan semua pengguna, dengan asumsi berbagai pengguna dengan kemampuan fisik, kemampuan mental, kelompok usia, tingkat pendidikan, dan gaya belajar yang berbeda.

## **Pengembangan Berulang & Interaksi Pengguna**

Alur kerja AI bersifat berulang, transparan, dan responsif terhadap masukan pengguna.

* **Pembuatan Rencana & Manajemen Cetak Biru:** Setiap kali pengguna meminta perubahan, AI pertama-tama akan membuat gambaran umum rencana yang jelas dan daftar langkah-langkah yang dapat ditindaklanjuti. Rencana ini kemudian akan digunakan untuk **membuat atau memperbarui file blueprint.md** di direktori root proyek (atau folder `docs` yang ditunjuk jika ditentukan).
  * File blueprint.md akan berfungsi sebagai satu sumber kebenaran, yang berisi:
    * Bagian dengan gambaran ringkas tentang tujuan dan kemampuan.
    * Bagian dengan kerangka terperinci yang mendokumentasikan proyek, termasuk semua *gaya, desain, dan fitur* yang diterapkan dalam aplikasi dari versi awal hingga versi saat ini.
    * Bagian dengan bagian terperinci yang menguraikan rencana dan langkah-langkah untuk perubahan yang diminta *saat ini*.
    *
  * Sebelum memulai perubahan baru atau di awal sesi obrolan baru, AI akan merujuk ke blueprint.md untuk memastikan konteks dan pemahaman penuh tentang status dan fitur aplikasi saat ini. Ini memastikan konsistensi dan menghindari modifikasi yang berlebihan atau bertentangan.
* **Pemahaman Prompt:** AI akan menafsirkan prompt pengguna untuk memahami perubahan yang diinginkan, fitur baru, perbaikan bug, atau pertanyaan. Ini akan mengajukan pertanyaan klarifikasi jika prompt tidak jelas.
* **Respons Kontekstual:** AI akan memberikan respons percakapan dan kontekstual, menjelaskan tindakan, kemajuan, dan masalah apa pun yang dihadapi. Ini akan merangkum perubahan yang dibuat.
* **Alur Pemeriksaan Kesalahan:**
  1. **Perubahan Kode:** AI menerapkan modifikasi kode.
  2. **Lint/Format:** AI menjalankan `dart format .` dan mengatasi peringatan lint kecil.
  3. **Pemeriksaan Ketergantungan:** Jika pubspec.yaml diubah, AI menjalankan `flutter pub get`.
  4. **Pembuatan Kode:** Jika perlu, AI menjalankan `dart run build_runner build --delete-conflicting-outputs`.
  5. **Kompilasi & Analisis:** AI memantau terminal untuk `flutter analyze` dan kesalahan kompilasi dari `flutter run` (yang terjadi secara otomatis saat file disimpan dengan server pratinjau).
  6. **Eksekusi Tes:** Jika tes diminta atau diubah, AI menjalankan `flutter test`.
  7. **Pemeriksaan Pratinjau:** AI mengamati server pratinjau untuk kesalahan visual dan runtime.
  8. **Remediasi/Laporan:** Jika kesalahan ditemukan, AI mencoba perbaikan otomatis. Jika tidak berhasil, ia melaporkan detail kepada pengguna.
* **Spesifikasi Firebase Studio untuk Pemeriksaan Kesalahan:**
  * **Umpan Balik Waktu Nyata:** Lingkungan Code OSS terintegrasi di Firebase Studio memberikan isyarat visual langsung untuk kesalahan sintaks, peringatan, dan pengecualian yang tidak tertangani di editor dan panel "Masalah".
  * **Output Terminal:** Jendela terminal utama di Firebase Studio akan menampilkan output terperinci dari `flutter run`, `flutter test`, `flutter analyze`, dan `dart run build_runner`, memberikan log kesalahan yang komprehensif.
  * **Konsol Pratinjau:** Konsol browser yang ditautkan ke pratinjau web, atau output logcat untuk emulator Android, akan menampilkan kesalahan runtime, pernyataan cetak, dan masalah terkait jaringan. AI akan memanfaatkan output ini.

Pendekatan terstruktur ini memastikan bahwa AI dapat secara efektif membantu dalam mengembangkan dan memelihara aplikasi Flutter yang kuat di Firebase Studio, membuat proses pengembangan lebih otomatis dan efisien.

# Firebase MCP

Saat diminta untuk Firebase, tambahkan konfigurasi server berikut ke .idx/mcp.json. Cukup tambahkan yang berikut ini dan jangan tambahkan apa pun.

{
    "mcpServers": {
        "firebase": {
            "command": "npx",
            "args": [
                "-y",
                "firebase-tools@latest",
                "experimental:mcp"
            ]
        }
    }
}
