//
//  Invoice+Extensions.swift
//  Fatura Okuma ve Harcama Takip
//
//  Invoice Model Extension'ları
//  Formatlama ve yardımcı metodlar
//

import Foundation

// MARK: - Formatting

extension Invoice {
    
    /// Fatura tarihini formatlanmış string olarak döndürür
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    /// Toplam tutarı formatlanmış string olarak döndürür
    var formattedTotalAmount: String {
        formatCurrency(totalAmount)
    }
    
    /// KDV tutarını formatlanmış string olarak döndürür
    var formattedTaxAmount: String {
        formatCurrency(taxAmount)
    }
    
    /// Vergi hariç tutarı formatlanmış string olarak döndürür
    var formattedAmountWithoutTax: String {
        formatCurrency(amountWithoutTax)
    }
    
    /// Para birimi formatı
    /// - Parameter amount: Formatlanacak tutar
    /// - Returns: Formatlanmış string
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount) TL"
    }
}

// MARK: - Computed Properties

extension Invoice {
    
    /// Faturanın bugün veya dün oluşturulup oluşturulmadığını kontrol eder
    var isRecent: Bool {
        Calendar.current.isDateInToday(date) ||
        Calendar.current.isDateInYesterday(date)
    }
    
    /// Faturanın bu ay içinde olup olmadığını kontrol eder
    var isThisMonth: Bool {
        Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
    }
    
    /// Faturanın bu yıl içinde olup olmadığını kontrol eder
    var isThisYear: Bool {
        Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year)
    }
    
    /// Faturanın kaç gün önce oluşturulduğunu döndürür
    var daysAgo: Int {
        Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
    
    /// Kategori atanmış mı?
    var hasCategory: Bool {
        category != nil && !(category?.isEmpty ?? true)
    }
    
    /// Not eklenmiş mi?
    var hasNotes: Bool {
        notes != nil && !(notes?.isEmpty ?? true)
    }
    
    /// Fatura görseli var mı?
    var hasImage: Bool {
        imageData != nil
    }
}

// MARK: - Validation

extension Invoice {
    
    /// Fatura verilerinin geçerli olup olmadığını kontrol eder
    var isValid: Bool {
        !invoiceNumber.isEmpty &&
        !companyName.isEmpty &&
        totalAmount > 0 &&
        taxAmount >= 0
    }
    
    /// Fatura numarasının geçerli formatta olup olmadığını kontrol eder
    var hasValidInvoiceNumber: Bool {
        // E-arşiv fatura numarası genellikle 16 karakter uzunluğundadır
        invoiceNumber.count >= 10 && invoiceNumber.count <= 20
    }
}

// MARK: - Comparison

extension Invoice {
    
    /// İki faturayı tarihe göre karşılaştırır
    static func compareByDate(_ lhs: Invoice, _ rhs: Invoice) -> Bool {
        lhs.date > rhs.date
    }
    
    /// İki faturayı tutara göre karşılaştırır
    static func compareByAmount(_ lhs: Invoice, _ rhs: Invoice) -> Bool {
        lhs.totalAmount > rhs.totalAmount
    }
}

// MARK: - Helper Methods

extension Invoice {
    
    /// Faturanın göreli tarih açıklamasını döndürür (örn: "2 gün önce")
    var relativeDateDescription: String {
        if Calendar.current.isDateInToday(date) {
            return "Bugün"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Dün"
        } else if daysAgo < 7 {
            return "\(daysAgo) gün önce"
        } else {
            return formattedDate
        }
    }
    
    /// Fatura için özet açıklama oluşturur
    var summaryDescription: String {
        "\(companyName) - \(formattedTotalAmount)"
    }
}
