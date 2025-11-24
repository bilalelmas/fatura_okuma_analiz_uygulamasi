# E-Arşiv Fatura Okuma ve Harcama Takip iOS Uygulaması

<div align="center">

![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)

**E-arşiv faturalarınızı otomatik okuyun, harcamalarınızı takip edin**

[Özellikler](#-özellikler) • [Kurulum](#-kurulum) • [Kullanım](#-kullanım) • [Teknolojiler](#-teknolojiler) • [Test](#-test)

</div>

---

## 📱 Proje Hakkında

Bu proje, **Bilgisayar Mühendisliği Bitirme Tezi** kapsamında geliştirilen bir iOS uygulamasıdır. Apple'ın Vision Framework'ünü kullanarak e-arşiv faturalarından otomatik olarak veri çıkarır ve kullanıcının harcamalarını takip etmesini sağlar.

### ✨ Özellikler

- 📸 **Kamera ile Fatura Tarama** - VNDocumentCameraViewController ile otomatik kenar algılama
- 📄 **PDF/Resim Yükleme** - Dosyalardan fatura yükleme desteği
- 🔍 **OCR ile Metin Okuma** - Vision Framework ile Türkçe karakter desteği
- 🎯 **Akıllı Veri Çıkarma** - Regex tabanlı anchor-based parsing
- 💾 **Otomatik Kaydetme** - SwiftData ile kalıcı veri saklama
- 📊 **Harcama Analizi** - SwiftCharts ile görselleştirme
- ✏️ **Manuel Düzenleme** - Fatura bilgilerini düzenleme ve kategori ekleme
- 🎨 **Modern UI** - SwiftUI ile native iOS deneyimi

## 🛠 Teknolojiler

| Kategori | Teknoloji |
|----------|-----------|
| **Platform** | iOS 17.0+ |
| **Dil** | Swift 5.9 |
| **UI Framework** | SwiftUI |
| **Veri Tabanı** | SwiftData |
| **OCR** | Vision Framework |
| **PDF İşleme** | PDFKit |
| **Grafikler** | SwiftCharts |
| **Mimari** | MVVM |
| **Concurrency** | Async/Await |

## 📁 Proje Yapısı

```
fatura_okuma_analiz_uygulamasi/
├── Sources/
│   ├── App/                    # Uygulama giriş noktası
│   ├── Models/                 # SwiftData modelleri
│   │   └── Invoice.swift
│   ├── ViewModels/             # MVVM ViewModel'leri
│   │   └── CameraViewModel.swift
│   ├── Views/                  # SwiftUI ekranları
│   │   ├── HomeView.swift
│   │   ├── InvoiceListView.swift
│   │   ├── InvoiceDetailView.swift
│   │   ├── InvoiceAnalysisView.swift
│   │   ├── DocumentCameraView.swift
│   │   └── DocumentPicker.swift
│   ├── Services/               # İş mantığı servisleri
│   │   ├── OCR/
│   │   │   └── OCRService.swift
│   │   └── Parser/
│   │       └── InvoiceParser.swift
│   ├── Errors/                 # Hata yönetimi
│   │   └── InvoiceError.swift
│   ├── Utilities/              # Yardımcı sınıflar
│   │   ├── Constants.swift
│   │   └── HapticManager.swift
│   └── Extensions/             # Swift extension'ları
│       ├── Invoice+Extensions.swift
│       └── View+Extensions.swift
└── Tests/                      # Unit testler
    ├── InvoiceTests.swift
    └── InvoiceParserTests.swift
```

## 🚀 Kurulum

### Gereksinimler

- macOS 14.0+
- Xcode 15.0+
- iOS 17.0+ cihaz (Kamera özelliği için)

### Adımlar

1. **Repository'yi klonlayın**
   ```bash
   git clone https://github.com/bilalelmas/fatura_okuma_analiz_uygulamasi.git
   cd fatura_okuma_analiz_uygulamasi
   ```

2. **Xcode'da açın**
   ```bash
   open fatura_okuma_analiz_uygulamasi.xcodeproj
   ```

3. **Kamera izni ekleyin** (Otomatik eklendi ✅)
   - Xcode'da proje ayarlarına gidin
   - **Info** sekmesine geçin
   - `Privacy - Camera Usage Description` anahtarını ekleyin
   - Değer: "Fatura taramak ve metin okumak için kamera izni gereklidir."

4. **Gerçek cihazda çalıştırın**
   - Simülatörde kamera çalışmaz
   - iPhone'unuzu Mac'e bağlayın
   - Xcode'da cihazınızı seçin
   - **Run** (⌘R) butonuna basın

## 📖 Kullanım

### Fatura Tarama

1. Ana ekranda **"Fatura Çek"** butonuna basın
2. Kamerayı faturaya tutun
3. Mavi çerçeve faturayı otomatik algılayacaktır
4. **"Save"** butonuna basın
5. Uygulama faturayı işleyip otomatik kaydedecektir

### Dosyadan Yükleme

1. Ana ekranda **"Dosya Yükle"** butonuna basın
2. Files uygulamasından PDF veya resim seçin
3. Uygulama dosyayı işleyip kaydedecektir

### Fatura Yönetimi

- **Liste:** "Faturalar" sekmesinden tüm faturaları görün
- **Detay:** Faturaya tıklayarak detayları görün
- **Düzenle:** "Düzenle" butonu ile bilgileri güncelleyin
- **Sil:** Kaydırarak silme seçeneğini kullanın

### Analiz

- **"Analiz"** sekmesine geçin
- Kategori bazlı pasta grafiği
- Zaman bazlı harcama trendi
- Toplam harcama özeti

## 🧪 Test

### Unit Testleri Çalıştırma

```bash
# Tüm testleri çalıştır
⌘ + U

# Tek bir test dosyası
⌘ + U (test dosyasında)
```

### Test Kapsamı

- ✅ **InvoiceTests** - Model validasyonu ve computed properties
- ✅ **InvoiceParserTests** - Regex pattern'leri ve parsing mantığı
- ⏳ **OCRServiceTests** - Mock OCR testleri (Gelecek)

### Manuel Test

Detaylı test senaryoları için: **[TEST_REHBERI.md](./TEST_REHBERI.md)**

## 🎯 Geliştirme Durumu

- [x] **Kurulum & Mimari** - Xcode projesi + MVVM
- [x] **Veri Modeli** - SwiftData `Invoice`
- [x] **OCR Servisi** - Vision Framework entegrasyonu
- [x] **Parser Servisi** - Regex tabanlı veri çıkarma
- [x] **Kamera Entegrasyonu** - VNDocumentCameraViewController
- [x] **Liste & Detay Ekranları** - Fatura yönetimi
- [x] **Analiz & Grafikler** - SwiftCharts harcama analizi
- [x] **Dosyadan Yükleme** - PDF/Resim desteği
- [x] **Hata Yönetimi** - Merkezi error handling
- [x] **Kod Kalitesi** - Constants, Extensions, Haptic feedback
- [x] **Unit Testler** - Parser ve Model testleri

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'feat: Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 👨‍💻 Geliştirici

**Bilal Elmas**
- GitHub: [@bilalelmas](https://github.com/bilalelmas)
- Proje: Bilgisayar Mühendisliği Bitirme Tezi

## 🙏 Teşekkürler

- Apple Vision Framework
- SwiftUI ve SwiftData ekosistemi
- Açık kaynak topluluğu

---

<div align="center">
Made with ❤️ for iOS
</div>
