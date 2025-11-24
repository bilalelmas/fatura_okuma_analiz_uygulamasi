//
//  Constants.swift
//  Fatura Okuma ve Harcama Takip
//
//  Uygulama Sabitleri
//  Magic numbers ve tekrarlanan değerleri merkezi bir yerden yönetir
//

import SwiftUI

/// Uygulama genelinde kullanılan sabitler
enum Constants {
    
    // MARK: - Layout
    
    /// Layout ile ilgili sabitler
    enum Layout {
        /// Yatay padding değeri
        static let horizontalPadding: CGFloat = 40
        
        /// Dikey padding değeri
        static let verticalPadding: CGFloat = 20
        
        /// Küçük padding değeri
        static let smallPadding: CGFloat = 8
        
        /// Orta padding değeri
        static let mediumPadding: CGFloat = 16
        
        /// Büyük padding değeri
        static let largePadding: CGFloat = 24
        
        /// Köşe yuvarlatma yarıçapı
        static let cornerRadius: CGFloat = 12
        
        /// Küçük köşe yuvarlatma yarıçapı
        static let smallCornerRadius: CGFloat = 8
        
        /// Gölge yarıçapı
        static let shadowRadius: CGFloat = 5
        
        /// Minimum dokunma alanı (Accessibility)
        static let minimumTapArea: CGFloat = 44
    }
    
    // MARK: - Colors
    
    /// Renk sabitleri
    enum Colors {
        /// Ana mavi renk
        static let primaryBlue = Color.blue
        
        /// Başarı yeşili
        static let successGreen = Color.green
        
        /// Hata kırmızısı
        static let errorRed = Color.red
        
        /// Uyarı turuncusu
        static let warningOrange = Color.orange
        
        /// Arka plan rengi
        static let background = Color(.systemGray6)
        
        /// İkincil arka plan rengi
        static let secondaryBackground = Color(.systemGray5)
        
        /// Metin rengi
        static let text = Color.primary
        
        /// İkincil metin rengi
        static let secondaryText = Color.secondary
    }
    
    // MARK: - Typography
    
    /// Tipografi sabitleri
    enum Typography {
        /// Başlık font boyutu
        static let titleSize: CGFloat = 28
        
        /// Alt başlık font boyutu
        static let subtitleSize: CGFloat = 20
        
        /// Gövde font boyutu
        static let bodySize: CGFloat = 17
        
        /// Küçük font boyutu
        static let captionSize: CGFloat = 14
    }
    
    // MARK: - Animation
    
    /// Animasyon sabitleri
    enum Animation {
        /// Kısa animasyon süresi
        static let shortDuration: Double = 0.2
        
        /// Orta animasyon süresi
        static let mediumDuration: Double = 0.3
        
        /// Uzun animasyon süresi
        static let longDuration: Double = 0.5
        
        /// Spring animasyon response
        static let springResponse: Double = 0.3
        
        /// Spring animasyon damping
        static let springDamping: Double = 0.7
    }
    
    // MARK: - Strings
    
    /// Metin sabitleri
    enum Strings {
        // Ana Ekran
        static let appTitle = "E-Arşiv Fatura Okuma"
        static let appSubtitle = "Faturanızı çekin, otomatik olarak analiz edelim"
        
        // Butonlar
        static let scanInvoiceButton = "Fatura Çek"
        static let uploadFileButton = "Dosya Yükle"
        static let saveButton = "Kaydet"
        static let cancelButton = "İptal"
        static let deleteButton = "Sil"
        static let editButton = "Düzenle"
        
        // Tab Bar
        static let homeTab = "Ana Sayfa"
        static let invoicesTab = "Faturalar"
        static let analysisTab = "Analiz"
        
        // Mesajlar
        static let processingMessage = "Fatura işleniyor..."
        static let successMessage = "Fatura başarıyla kaydedildi!"
        static let deleteConfirmation = "Bu faturayı silmek istediğinizden emin misiniz?"
        
        // Placeholder
        static let noInvoicesMessage = "Henüz fatura eklenmedi"
        static let noInvoicesDescription = "Fatura Çek butonuna basarak başlayın"
    }
    
    // MARK: - Icons
    
    /// SF Symbols ikon isimleri
    enum Icons {
        static let camera = "camera.fill"
        static let folder = "folder.fill"
        static let house = "house.fill"
        static let list = "list.bullet"
        static let chart = "chart.pie.fill"
        static let trash = "trash"
        static let checkmark = "checkmark.circle.fill"
        static let error = "exclamationmark.triangle.fill"
        static let document = "doc.text.magnifyingglass"
    }
    
    // MARK: - Time
    
    /// Zaman sabitleri
    enum Time {
        /// Başarı mesajı gösterim süresi (saniye)
        static let successMessageDuration: Double = 2.0
        
        /// Hata mesajı gösterim süresi (saniye)
        static let errorMessageDuration: Double = 3.0
        
        /// Otomatik kaydetme gecikmesi (saniye)
        static let autoSaveDelay: Double = 0.5
    }
    
    // MARK: - Limits
    
    /// Limit sabitleri
    enum Limits {
        /// Maksimum not uzunluğu
        static let maxNotesLength = 500
        
        /// Maksimum kategori uzunluğu
        static let maxCategoryLength = 50
        
        /// Maksimum firma adı uzunluğu
        static let maxCompanyNameLength = 100
    }
}
