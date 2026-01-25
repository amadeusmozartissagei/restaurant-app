# Restaurant App - Dicoding Submission

Aplikasi Flutter untuk menampilkan daftar restoran dan detail restoran menggunakan API Dicoding.

## Fitur

### ✅ Halaman Daftar Restoran

- Menampilkan daftar restoran dari API Dicoding
- Informasi yang ditampilkan: nama, gambar, kota, dan rating
- Pull-to-refresh untuk memperbarui data
- Navigasi ke halaman detail

### ✅ Halaman Detail Restoran

- Menampilkan detail lengkap restoran
- Informasi: nama, gambar, deskripsi, kota, alamat, rating
- Menu makanan dan minuman
- Ulasan pelanggan

### ✅ Tema Terang dan Gelap

- Light theme dan Dark theme
- Tombol toggle untuk berganti tema
- Custom font menggunakan Google Fonts (Poppins)
- Warna kustom (bukan warna default Flutter)

### ✅ Indikator Loading

- Loading indicator kustom dengan animasi
- Ditampilkan saat memanggil API

### ✅ State Management dengan Provider

- Menggunakan library Provider
- Sealed class untuk handling state (Loading, Success, Error, NoData)

## Struktur Proyek

```
lib/
├── common/
│   ├── result_state.dart      # Sealed class untuk state management
│   └── theme.dart             # Konfigurasi tema terang & gelap
├── data/
│   ├── api/
│   │   └── api_service.dart   # Service untuk API calls
│   └── models/
│       ├── restaurant.dart        # Model untuk daftar restoran
│       └── restaurant_detail.dart # Model untuk detail restoran
├── provider/
│   ├── restaurant_provider.dart   # Provider untuk restoran
│   └── theme_provider.dart        # Provider untuk tema
├── ui/
│   ├── pages/
│   │   ├── restaurant_list_page.dart   # Halaman daftar restoran
│   │   └── restaurant_detail_page.dart # Halaman detail restoran
│   └── widgets/
│       ├── error_widget.dart      # Widget untuk tampilan error
│       ├── loading_indicator.dart # Widget loading indicator
│       └── restaurant_card.dart   # Widget kartu restoran
└── main.dart                      # Entry point aplikasi
```

## Dependencies

- **provider**: State management
- **http**: HTTP client untuk API calls
- **google_fonts**: Custom fonts (Poppins)

## API

Menggunakan Dicoding Restaurant API:

- Base URL: `https://restaurant-api.dicoding.dev`
- Endpoints:
  - `/list` - Daftar restoran
  - `/detail/{id}` - Detail restoran
  - `/search?q={query}` - Pencarian restoran

## Cara Menjalankan

1. Pastikan Flutter SDK terinstall
2. Clone repository ini
3. Jalankan `flutter pub get`
4. Jalankan `flutter run`

## Screenshots

Aplikasi memiliki tampilan modern dengan:

- SliverAppBar yang dinamis
- Hero animation untuk transisi
- Gradient backgrounds
- Rating chips dengan warna kuning
- Card design dengan shadow
- Animasi loading yang menarik

## Kriteria Submission

| Kriteria                  | Status |
| ------------------------- | ------ |
| Halaman Daftar Restoran   | ✅     |
| Halaman Detail Restoran   | ✅     |
| Tema Terang & Gelap       | ✅     |
| Custom Font               | ✅     |
| Warna Non-Default         | ✅     |
| Indikator Loading         | ✅     |
| State Management Provider | ✅     |
| Sealed Class untuk API    | ✅     |
