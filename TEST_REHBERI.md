# E-Arşiv Fatura Okuma Uygulaması - Test Rehberi

Bu rehber, uygulamanın farklı özelliklerini nasıl test edebileceğinizi adım adım açıklar.

## 1. Hazırlık
- Projeyi Xcode'da açın (`InvoiceApp.xcodeproj` veya `.xcworkspace`).
- Hedef cihaz olarak **iOS 17.0+** yüklü bir simülatör veya gerçek cihaz seçin.

## 2. Test Senaryoları

### Senaryo A: Gerçek Cihaz ile Tam Test (Önerilen)
Kamera özelliği sadece gerçek cihazlarda tam performanslı çalışır.

1.  **Uygulamayı Başlatın:** iPhone'unuzu bağlayın ve "Run" (Cmd+R) butonuna basın.
2.  **Kamera İzni:** "Fatura Çek" butonuna bastığınızda kamera izni isteyecektir. "Tamam" deyin.
3.  **Fatura Tarama:**
    - Önünüzdeki bir faturayı düz bir zemine koyun.
    - Kamerayı faturaya tutun.
    - Mavi bir kutucuk faturayı otomatik algılayacaktır.
    - "Save" (Kaydet) butonuna basın.
4.  **Sonuç Kontrolü:**
    - Uygulama faturayı işleyip "Başarılı" mesajı verecektir.
    - "Faturalar" sekmesine gidip yeni eklenen faturayı görün.
    - Detayına girip Tarih, Tutar ve Firma Adı'nın doğru okunup okunmadığını kontrol edin.

### Senaryo B: Simülatör ile Test
Simülatörde kamera çalışmaz, ancak diğer özellikleri test edebilirsiniz.

1.  **Uygulamayı Başlatın:** Bir iPhone simülatörü seçip çalıştırın.
2.  **Kamera Uyarısı:** "Fatura Çek" butonuna bastığınızda "Kamera desteklenmiyor" veya benzeri bir uyarı alabilirsiniz (veya simülatörün varsayılan siyah ekranı gelir).
3.  **Preview (Önizleme) Testi:**
    - Xcode'da `InvoiceDetailView.swift` dosyasını açın.
    - Sağ taraftaki "Canvas" (Önizleme) alanında örnek verilerle oluşturulmuş faturayı görebilirsiniz.
    - "Düzenle" butonuna basıp değişiklik yapmayı deneyin.

### Senaryo C: Analiz Ekranı Testi
1.  Uygulamaya birkaç farklı fatura ekleyin (Gerçek cihazda tarayarak).
2.  "Analiz" sekmesine geçin.
3.  **Pasta Grafiği:** Kategorilerin (Yemek, Ulaşım vb.) doğru dağıldığını kontrol edin.
4.  **Toplam Tutar:** En üstteki kartta yazan tutarın, faturaların toplamıyla eşleştiğini doğrulayın.

## 3. Karşılaşabileceğiniz Sorunlar ve Çözümleri

- **Sorun:** "Metin bulunamadı" hatası alıyorum.
  - **Çözüm:** Faturanın fotoğrafını daha aydınlık bir ortamda ve net bir şekilde çekin. Yazıların okunaklı olduğundan emin olun.

- **Sorun:** Tarih veya Tutar yanlış çıkıyor.
  - **Çözüm:** Fatura formatı desteklenmiyor olabilir. "Düzenle" butonu ile manuel düzeltebilirsiniz.

- **Sorun:** Uygulama çöküyor.
  - **Çözüm:** Xcode konsolundaki hata mesajını (kırmızı yazılar) geliştiriciye iletin.
