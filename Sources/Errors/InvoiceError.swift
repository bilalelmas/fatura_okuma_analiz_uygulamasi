//
//  InvoiceError.swift
//  Fatura Okuma ve Harcama Takip
//
//  Merkezi Hata Yönetimi
//  Tüm uygulama genelinde kullanılacak hata tipleri
//

import Foundation

/// Uygulama genelinde kullanılan hata tipleri
/// Kullanıcı dostu mesajlar ve detaylı hata açıklamaları içerir
enum InvoiceError: LocalizedError {
    // MARK: - OCR Hataları
    
    /// Geçersiz görsel dosyası
    case invalidImage
    
    /// Geçersiz PDF dosyası
    case invalidPDF
    
    /// OCR işlemi başarısız oldu
    case ocrFailed(String)
    
    /// Görselde metin bulunamadı
    case noTextFound
    
    // MARK: - Parser Hataları
    
    /// Fatura bilgileri çıkarılamadı
    case parsingFailed
    
    /// Fatura numarası bulunamadı
    case invoiceNumberNotFound
    
    /// Fatura tarihi bulunamadı
    case dateNotFound
    
    /// Tutar bilgisi bulunamadı
    case amountNotFound
    
    /// Firma adı bulunamadı
    case companyNameNotFound
    
    // MARK: - Veri Hataları
    
    /// Geçersiz veri formatı
    case invalidData
    
    /// Dosya okuma hatası
    case fileReadError(String)
    
    /// Dosya yazma hatası
    case fileWriteError(String)
    
    // MARK: - Veritabanı Hataları
    
    /// Veritabanı kayıt hatası
    case databaseSaveError(String)
    
    /// Veritabanı okuma hatası
    case databaseFetchError(String)
    
    /// Veritabanı silme hatası
    case databaseDeleteError(String)
    
    // MARK: - Genel Hataları
    
    /// Bilinmeyen hata
    case unknown(String)
    
    // MARK: - LocalizedError Implementation
    
    /// Kullanıcıya gösterilecek hata açıklaması
    var errorDescription: String? {
        switch self {
        // OCR Hataları
        case .invalidImage:
            return "Geçersiz görsel dosyası"
        case .invalidPDF:
            return "Geçersiz PDF dosyası"
        case .ocrFailed(let detail):
            return "Metin okuma hatası: \(detail)"
        case .noTextFound:
            return "Görselde metin bulunamadı"
            
        // Parser Hataları
        case .parsingFailed:
            return "Fatura bilgileri çıkarılamadı"
        case .invoiceNumberNotFound:
            return "Fatura numarası bulunamadı"
        case .dateNotFound:
            return "Fatura tarihi bulunamadı"
        case .amountNotFound:
            return "Tutar bilgisi bulunamadı"
        case .companyNameNotFound:
            return "Firma adı bulunamadı"
            
        // Veri Hataları
        case .invalidData:
            return "Geçersiz veri formatı"
        case .fileReadError(let detail):
            return "Dosya okuma hatası: \(detail)"
        case .fileWriteError(let detail):
            return "Dosya yazma hatası: \(detail)"
            
        // Veritabanı Hataları
        case .databaseSaveError(let detail):
            return "Kayıt hatası: \(detail)"
        case .databaseFetchError(let detail):
            return "Veri okuma hatası: \(detail)"
        case .databaseDeleteError(let detail):
            return "Silme hatası: \(detail)"
            
        // Genel
        case .unknown(let detail):
            return "Beklenmeyen hata: \(detail)"
        }
    }
    
    /// Hatanın nedeni (opsiyonel detay)
    var failureReason: String? {
        switch self {
        case .noTextFound:
            return "Fatura görseli net olmayabilir veya metin içermiyor olabilir."
        case .parsingFailed:
            return "Fatura formatı desteklenmiyor olabilir."
        case .invalidImage, .invalidPDF:
            return "Dosya bozuk veya desteklenmeyen formatta olabilir."
        default:
            return nil
        }
    }
    
    /// Kullanıcıya önerilen çözüm
    var recoverySuggestion: String? {
        switch self {
        case .invalidImage, .invalidPDF:
            return "Lütfen farklı bir dosya deneyin."
        case .noTextFound:
            return "Faturayı daha iyi ışıklandırılmış bir ortamda tekrar çekin."
        case .parsingFailed, .invoiceNumberNotFound, .dateNotFound, .amountNotFound, .companyNameNotFound:
            return "Fatura bilgilerini manuel olarak düzenleyebilirsiniz."
        case .ocrFailed:
            return "Lütfen tekrar deneyin veya farklı bir fatura görseli kullanın."
        default:
            return "Lütfen tekrar deneyin."
        }
    }
}
