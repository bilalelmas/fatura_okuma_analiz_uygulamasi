# E-Arşiv Fatura Okuma ve Harcama Takip iOS Uygulaması

## 📱 Proje Hakkında

Bu proje, **Bilgisayar Mühendisliği Bitirme Tezi** kapsamında geliştirilen bir iOS uygulamasıdır. Uygulama, Vision Framework kullanarak e-arşiv faturalarından otomatik olarak veri çıkarır ve kullanıcının harcamalarını takip etmesini sağlar.

## 🛠 Teknolojiler

- **Platform:** iOS 17+
- **Framework:** SwiftUI
- **Veri Tabanı:** SwiftData
- **OCR:** Vision Framework
- **PDF İşleme:** PDFKit
- **Grafikler:** SwiftCharts

## 📁 Proje Yapısı

```
fatura_okuma_analiz_uygulamasi/
├── Models/          # Veri modelleri (Invoice, vb.)
├── Views/           # SwiftUI görünümleri
├── ViewModels/      # MVVM ViewModel'leri
├── Services/        # İş mantığı servisleri (OCR, Parser)
├── Resources/       # Assets, Localization
└── Utilities/       # Yardımcı fonksiyonlar
```

## 🚀 Geliştirme Planı

1. ✅ **Kurulum:** Proje yapısı ve klasörler
2. ✅ **Model:** Invoice veri modeli (SwiftData)
3. ✅ **Servis 1:** OCRService (Vision Framework)
4. ✅ **Servis 2:** InvoiceParser (Regex & Pattern Matching)
5. ✅ **UI - Kamera:** VNDocumentCameraViewController entegrasyonu
6. ✅ **UI - Liste & Detay:** Fatura listesi ve düzenleme ekranları
7. ⏳ **Grafikler:** SwiftCharts ile harcama analizi

## 🧪 Test Etme

Uygulamayı test etmek için detaylı rehbere bakın: **[TEST_REHBERI.md](./TEST_REHBERI.md)**

### Hızlı Başlangıç

1. Xcode'da yeni bir iOS App projesi oluşturun (SwiftUI + SwiftData)
2. Bu repository'deki dosyaları Xcode projesine ekleyin
3. Kamera izinlerini Info.plist'e ekleyin
4. Gerçek bir iOS cihazında çalıştırın (VisionKit simülatörde çalışmaz)


