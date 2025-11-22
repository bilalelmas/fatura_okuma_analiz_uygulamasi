//
//  Invoice.swift
//  Fatura Okuma ve Harcama Takip
//
//  Fatura veri modeli
//  SwiftData kullanarak kalıcı veri saklama için oluşturulmuştur
//

import Foundation
import SwiftData

/// Fatura modeli - E-arşiv faturalardan çıkarılan bilgileri saklar
/// SwiftData ile kalıcı olarak veritabanında tutulur
@Model
final class Invoice {
    // MARK: - Temel Bilgiler
    
    /// Fatura numarası (e-arşiv fatura numarası)
    var invoiceNumber: String
    
    /// Fatura tarihi
    var date: Date
    
    /// Toplam tutar (KDV dahil)
    var totalAmount: Double
    
    /// Vergi tutarı (KDV)
    var taxAmount: Double
    
    /// Vergi hariç tutar (hesaplanmış değer)
    var amountWithoutTax: Double {
        totalAmount - taxAmount
    }
    
    // MARK: - Firma Bilgileri
    
    /// Firma/Şirket adı
    var companyName: String
    
    // MARK: - Dosya Bilgileri
    
    /// Fatura görselinin verisi (PDF veya resim)
    /// Data tipinde saklanır, SwiftData ile otomatik olarak yönetilir
    var imageData: Data?
    
    /// Dosya tipi (PDF, PNG, JPEG vb.)
    var fileType: String?
    
    // MARK: - Kullanıcı Bilgileri
    
    /// Kategori (Yemek, Ulaşım, Alışveriş vb.)
    var category: String?
    
    /// Kullanıcı notları
    var notes: String?
    
    // MARK: - Sistem Bilgileri
    
    /// Oluşturulma tarihi
    var createdAt: Date
    
    /// Son güncellenme tarihi
    var updatedAt: Date
    
    // MARK: - Initializer
    
    /// Yeni bir fatura oluşturur
    /// - Parameters:
    ///   - invoiceNumber: Fatura numarası
    ///   - date: Fatura tarihi
    ///   - totalAmount: Toplam tutar
    ///   - taxAmount: Vergi tutarı
    ///   - companyName: Firma adı
    ///   - imageData: Fatura görseli (opsiyonel)
    ///   - fileType: Dosya tipi (opsiyonel)
    init(
        invoiceNumber: String,
        date: Date,
        totalAmount: Double,
        taxAmount: Double,
        companyName: String,
        imageData: Data? = nil,
        fileType: String? = nil
    ) {
        self.invoiceNumber = invoiceNumber
        self.date = date
        self.totalAmount = totalAmount
        self.taxAmount = taxAmount
        self.companyName = companyName
        self.imageData = imageData
        self.fileType = fileType
        self.category = nil
        self.notes = nil
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // MARK: - Helper Methods
    
    /// Fatura bilgilerini günceller
    /// - Parameters:
    ///   - invoiceNumber: Yeni fatura numarası (opsiyonel)
    ///   - date: Yeni tarih (opsiyonel)
    ///   - totalAmount: Yeni toplam tutar (opsiyonel)
    ///   - taxAmount: Yeni vergi tutarı (opsiyonel)
    ///   - companyName: Yeni firma adı (opsiyonel)
    func update(
        invoiceNumber: String? = nil,
        date: Date? = nil,
        totalAmount: Double? = nil,
        taxAmount: Double? = nil,
        companyName: String? = nil
    ) {
        if let invoiceNumber = invoiceNumber {
            self.invoiceNumber = invoiceNumber
        }
        if let date = date {
            self.date = date
        }
        if let totalAmount = totalAmount {
            self.totalAmount = totalAmount
        }
        if let taxAmount = taxAmount {
            self.taxAmount = taxAmount
        }
        if let companyName = companyName {
            self.companyName = companyName
        }
        self.updatedAt = Date()
    }
}

