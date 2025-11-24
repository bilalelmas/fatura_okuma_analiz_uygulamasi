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
ExpenseTrackerOCR/
├── Sources/
│   ├── App/                 # ExpenseTrackerOCRApp giriş noktası
│   ├── Models/              # SwiftData modelleri (Invoice, vb.)
│   ├── ViewModels/          # MVVM ViewModel'leri
│   ├── Views/               # SwiftUI ekranları (Home, List, Detail...)
│   ├── Services/
│   │   ├── OCR/             # Vision tabanlı OCR servisleri
│   │   └── Parser/          # Regex + patterns.json ayrıştırıcıları
│   └── Utilities/           # Ortak yardımcılar
├── Resources/               # Assets, JSON pattern'ları
└── Tests/                   # Unit/UI test hedefleri
```

## 🚀 Geliştirme Planı

1. ✅ **Kurulum & Mimari:** Xcode projesi + MVVM klasörleri
2. ⏳ **Veri Modeli:** SwiftData `Invoice`
3. ⏳ **Servis (OCR):** `OCRService` + Vision
4. ⏳ **Servis (Parser):** `InvoiceParser` + Regex
5. ⏳ **UI - Tarama:** `VNDocumentCameraViewController`
6. ⏳ **UI - Liste & Detay:** Fatura yönetimi ekranları
7. ⏳ **Analiz & Grafikler:** SwiftCharts harcama analizi

## 🧪 Test Etme

Uygulamayı test etmek için detaylı rehbere bakın: **[TEST_REHBERI.md](./TEST_REHBERI.md)**

### Hızlı Başlangıç

1. Xcode'da yeni bir iOS App projesi oluşturun (SwiftUI + SwiftData)
2. Bu repository'deki dosyaları Xcode projesine ekleyin
3. Kamera izinlerini Info.plist'e ekleyin
4. Gerçek bir iOS cihazında çalıştırın (VisionKit simülatörde çalışmaz)


