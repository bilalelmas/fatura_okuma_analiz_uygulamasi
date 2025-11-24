//
//  InvoiceParser.swift
//  Fatura Okuma ve Harcama Takip
//
//  Fatura Parser Servisi
//  OCR'dan gelen ham metinden anlamlı verileri çıkarır (Regex ve Pattern Matching)
//  Python tabanlı "Hibrit Çıkarım" ve "Anchor-based Regex" yaklaşımının Swift uyarlaması
//

import Foundation

/// Parser'dan dönen sonuç yapısı
/// Tüm alanlar opsiyonel çünkü OCR her zaman tüm bilgileri bulamayabilir
struct ParsedInvoiceData {
    var invoiceNumber: String?
    var date: Date?
    var totalAmount: Double?
    var taxAmount: Double?
    var companyName: String?
    
    /// Çıkarılan verilerin Invoice modeline dönüştürülebilir olup olmadığını kontrol eder
    var isValid: Bool {
        // En azından fatura numarası ve tutar olmalı
        return invoiceNumber != nil && totalAmount != nil
    }
}

/// Fatura Parser Servisi
/// OCR'dan gelen ham metinden fatura bilgilerini çıkarır
class InvoiceParser {
    
    // MARK: - Singleton
    
    static let shared = InvoiceParser()
    private init() {}
    
    // MARK: - Main Parse Method
    
    /// Ham metinden fatura bilgilerini çıkarır
    /// - Parameter text: OCR'dan gelen ham metin
    /// - Returns: Çıkarılan fatura bilgileri
    func parse(_ text: String) -> ParsedInvoiceData {
        var parsedData = ParsedInvoiceData()
        
        // Metni temizliyoruz (gereksiz boşlukları kaldırıyoruz)
        let cleanedText = cleanText(text)
        
        // Her bilgiyi sırayla çıkarıyoruz
        parsedData.invoiceNumber = extractInvoiceNumber(from: cleanedText)
        parsedData.date = extractDate(from: cleanedText)
        parsedData.totalAmount = extractTotalAmount(from: cleanedText)
        parsedData.taxAmount = extractTaxAmount(from: cleanedText)
        parsedData.companyName = extractCompanyName(from: cleanedText)
        
        return parsedData
    }
    
    // MARK: - Text Cleaning
    
    /// Metni temizler - gereksiz boşlukları ve karakterleri kaldırır
    /// - Parameter text: Temizlenecek metin
    /// - Returns: Temizlenmiş metin
    private func cleanText(_ text: String) -> String {
        var cleaned = text
        
        // Çoklu boşlukları tek boşluğa çeviriyoruz
        cleaned = cleaned.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        // Satır sonlarını koruyoruz ama çoklu satır sonlarını tek satır sonuna çeviriyoruz
        cleaned = cleaned.replacingOccurrences(of: "\\n\\s*\\n", with: "\n", options: .regularExpression)
        
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Invoice Number Extraction
    
    /// Fatura numarasını çıkarır
    /// E-arşiv faturalarda fatura numarası genellikle "Fatura No:", "Fatura Numarası:" gibi etiketlerden sonra gelir
    /// - Parameter text: Aranacak metin
    /// - Returns: Bulunan fatura numarası (opsiyonel)
    private func extractInvoiceNumber(from text: String) -> String? {
        // Anchor-based yaklaşım: "Fatura No:" gibi anahtar kelimelerden sonraki değeri arıyoruz
        let patterns = [
            // "Fatura No: 1234567890" formatı
            "(?i)(?:fatura\\s*(?:no|numarası?)[:：]?\\s*)([A-Z0-9\\-]+)",
            // "Invoice No: 1234567890" formatı
            "(?i)(?:invoice\\s*(?:no|number)[:：]?\\s*)([A-Z0-9\\-]+)",
            // "No: 1234567890" formatı
            "(?i)(?:^|\\s)(?:no|numara)[:：]?\\s*([A-Z0-9\\-]{8,})",
            // Sadece uzun alfanumerik diziler (e-arşiv fatura numaraları genellikle 8+ karakter)
            "(?i)(?:^|\\s)([A-Z0-9]{8,})(?:\\s|$)"
        ]
        
        for pattern in patterns {
            if let match = text.range(of: pattern, options: .regularExpression) {
                let matchedText = String(text[match])
                // İlk capture group'u alıyoruz
                if let numberRange = matchedText.range(of: "([A-Z0-9\\-]+)", options: .regularExpression) {
                    let invoiceNumber = String(matchedText[numberRange])
                    // Çok kısa veya çok uzun değerleri filtreliyoruz
                    if invoiceNumber.count >= 6 && invoiceNumber.count <= 50 {
                        return invoiceNumber
                    }
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Date Extraction
    
    /// Tarihi çıkarır
    /// Türkçe tarih formatlarını destekler (DD.MM.YYYY, DD/MM/YYYY, vb.)
    /// - Parameter text: Aranacak metin
    /// - Returns: Bulunan tarih (opsiyonel)
    private func extractDate(from text: String) -> Date? {
        // Tarih pattern'leri - Türkçe formatlar
        let datePatterns = [
            // "Tarih: 01.01.2024" formatı
            "(?i)(?:tarih|date)[:：]?\\s*(\\d{1,2})[./](\\d{1,2})[./](\\d{4})",
            // "01.01.2024" formatı (anchor olmadan)
            "(\\d{1,2})[./](\\d{1,2})[./](\\d{4})",
            // "2024-01-01" formatı
            "(\\d{4})[./-](\\d{1,2})[./-](\\d{1,2})"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr_TR")
        
        for pattern in datePatterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(text.startIndex..., in: text)
                let matches = regex.matches(in: text, options: [], range: range)
                
                for match in matches {
                    if match.numberOfRanges >= 4 {
                        // Gün, ay, yıl değerlerini alıyoruz
                        let dayRange = Range(match.range(at: 1), in: text)!
                        let monthRange = Range(match.range(at: 2), in: text)!
                        let yearRange = Range(match.range(at: 3), in: text)!
                        
                        let day = String(text[dayRange])
                        let month = String(text[monthRange])
                        let year = String(text[yearRange])
                        
                        // Tarih string'ini oluşturuyoruz
                        let dateString = "\(day).\(month).\(year)"
                        dateFormatter.dateFormat = "dd.MM.yyyy"
                        
                        if let date = dateFormatter.date(from: dateString) {
                            // Geçerli bir tarih aralığında mı kontrol ediyoruz (2000-2100)
                            let calendar = Calendar.current
                            let yearComponent = calendar.component(.year, from: date)
                            if yearComponent >= 2000 && yearComponent <= 2100 {
                                return date
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Amount Extraction
    
    /// Toplam tutarı çıkarır
    /// "Toplam:", "Genel Toplam:", "TOPLAM:" gibi etiketlerden sonraki değeri arar
    /// - Parameter text: Aranacak metin
    /// - Returns: Bulunan toplam tutar (opsiyonel)
    private func extractTotalAmount(from text: String) -> Double? {
        // Anchor-based yaklaşım: "Toplam" kelimesinden sonraki tutarı arıyoruz
        let patterns = [
            // "Toplam: 123,45 TL" formatı
            "(?i)(?:toplam|genel\\s+toplam|tutar|total)[:：]?\\s*([\\d.,]+)\\s*(?:tl|₺)?",
            // "123,45 TL" formatı (anchor olmadan, büyük tutarlar)
            "([\\d.,]{4,})\\s*(?:tl|₺)",
            // "123.45" formatı (nokta ile ayrılmış)
            "([\\d.]+,\\d{2})\\s*(?:tl|₺)?"
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(text.startIndex..., in: text)
                let matches = regex.matches(in: text, options: [], range: range)
                
                // En büyük tutarı alıyoruz (genellikle toplam tutar en büyüktür)
                var maxAmount: Double = 0.0
                
                for match in matches {
                    if match.numberOfRanges >= 2 {
                        let amountRange = Range(match.range(at: 1), in: text)!
                        let amountString = String(text[amountRange])
                        
                        // Türkçe sayı formatını (virgül) İngilizce formatına (nokta) çeviriyoruz
                        let normalizedAmount = amountString
                            .replacingOccurrences(of: ".", with: "")  // Binlik ayırıcıyı kaldır
                            .replacingOccurrences(of: ",", with: ".")  // Virgülü noktaya çevir
                        
                        if let amount = Double(normalizedAmount), amount > maxAmount {
                            maxAmount = amount
                        }
                    }
                }
                
                if maxAmount > 0 {
                    return maxAmount
                }
            }
        }
        
        return nil
    }
    
    /// KDV tutarını çıkarır
    /// "KDV:", "Vergi:" gibi etiketlerden sonraki değeri arar
    /// - Parameter text: Aranacak metin
    /// - Returns: Bulunan KDV tutarı (opsiyonel)
    private func extractTaxAmount(from text: String) -> Double? {
        let patterns = [
            // "KDV: 18,00 TL" formatı
            "(?i)(?:kdv|vergi|tax)[:：]?\\s*([\\d.,]+)\\s*(?:tl|₺)?",
            // "%18 KDV: 123,45 TL" formatı
            "(?i)(?:%\\d+\\s*)?(?:kdv|vergi)[:：]?\\s*([\\d.,]+)\\s*(?:tl|₺)?"
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(text.startIndex..., in: text)
                let matches = regex.matches(in: text, options: [], range: range)
                
                for match in matches {
                    if match.numberOfRanges >= 2 {
                        let amountRange = Range(match.range(at: 1), in: text)!
                        let amountString = String(text[amountRange])
                        
                        // Türkçe sayı formatını normalize ediyoruz
                        let normalizedAmount = amountString
                            .replacingOccurrences(of: ".", with: "")
                            .replacingOccurrences(of: ",", with: ".")
                        
                        if let amount = Double(normalizedAmount), amount > 0 {
                            return amount
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Company Name Extraction
    
    /// Firma adını çıkarır
    /// "Firma:", "Şirket:", "Satıcı:" gibi etiketlerden sonraki değeri arar
    /// - Parameter text: Aranacak metin
    /// - Returns: Bulunan firma adı (opsiyonel)
    private func extractCompanyName(from text: String) -> String? {
        // Anchor-based yaklaşım: Firma adı genellikle belirli etiketlerden sonra gelir
        let patterns = [
            // "Firma: ABC Şirketi" formatı
            "(?i)(?:firma|şirket|satıcı|vendor|company)[:：]?\\s*([A-ZÇĞİÖŞÜa-zçğıöşü\\s&.,]+?)(?:\\n|Fatura|Tarih|Toplam)",
            // "ABC Şirketi Ltd. Şti." formatı (satır başında)
            "^([A-ZÇĞİÖŞÜ][A-ZÇĞİÖŞÜa-zçğıöşü\\s&.,]{3,50})(?:\\n|$)"
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(text.startIndex..., in: text)
                let matches = regex.matches(in: text, options: [], range: range)
                
                for match in matches {
                    if match.numberOfRanges >= 2 {
                        let companyRange = Range(match.range(at: 1), in: text)!
                        var companyName = String(text[companyRange])
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        // Çok kısa veya çok uzun değerleri filtreliyoruz
                        if companyName.count >= 3 && companyName.count <= 100 {
                            // Gereksiz karakterleri temizliyoruz
                            companyName = companyName.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                            return companyName
                        }
                    }
                }
            }
        }
        
        return nil
    }
}

