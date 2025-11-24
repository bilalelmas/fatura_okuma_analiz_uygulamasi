//
//  InvoiceParser.swift
//  ExpenseTrackerOCR
//
//  OCR çıktılarından anlamlı fatura verileri üretir.
//  Regex desenlerini JSON üzerinden yöneterek farklı fatura formatlarına uyum sağlar.
//

import Foundation

// MARK: - Parsed Data DTO

struct ParsedInvoiceData {
    var invoiceNumber: String?
    var issuerName: String?
    var receiverName: String?
    var issueDate: Date?
    var dueDate: Date?
    var totalAmount: Decimal?
    var taxAmount: Decimal?
    var currencyCode: String?
    var rawTotalText: String?
    var rawTaxText: String?
    var confidence: Double?
    
    var isValid: Bool {
        invoiceNumber?.isEmpty == false && totalAmount != nil
    }
}

// MARK: - Pattern Config

struct InvoicePatternConfig: Decodable {
    let invoiceNumber: [String]
    let date: [String]
    let totalAmount: [String]
    let taxAmount: [String]
    let issuerName: [String]
    let currency: [String]
}

enum InvoicePatternLoader {
    static func load() -> InvoicePatternConfig {
        guard
            let url = Bundle.main.url(forResource: "patterns", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let config = try? JSONDecoder().decode(InvoicePatternConfig.self, from: data)
        else {
            fatalError("patterns.json yüklenemedi veya bozuk.")
        }
        return config
    }
}

// MARK: - Invoice Parser

class InvoiceParser {
    static let shared = InvoiceParser()
    
    private let patterns: InvoicePatternConfig
    
    private init() {
        patterns = InvoicePatternLoader.load()
    }
    
    func parse(_ text: String) -> ParsedInvoiceData {
        var parsedData = ParsedInvoiceData()
        let cleanedText = cleanText(text)
        
        parsedData.invoiceNumber = extractValue(from: cleanedText, patterns: patterns.invoiceNumber)
        parsedData.issueDate = extractDate(from: cleanedText, patterns: patterns.date)
        
        let total = extractAmount(from: cleanedText, patterns: patterns.totalAmount)
        parsedData.totalAmount = total.decimalValue
        parsedData.rawTotalText = total.matchedText
        
        let tax = extractAmount(from: cleanedText, patterns: patterns.taxAmount)
        parsedData.taxAmount = tax.decimalValue
        parsedData.rawTaxText = tax.matchedText
        
        parsedData.issuerName = extractValue(from: cleanedText, patterns: patterns.issuerName)
        parsedData.currencyCode = detectCurrency(from: cleanedText)
        
        return parsedData
    }
}

// MARK: - Helpers

private extension InvoiceParser {
    func cleanText(_ text: String) -> String {
        var cleaned = text
        cleaned = cleaned.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "\\n\\s*\\n", with: "\n", options: .regularExpression)
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func extractValue(from text: String, patterns: [String]) -> String? {
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else { continue }
            let range = NSRange(text.startIndex..., in: text)
            if let match = regex.firstMatch(in: text, options: [], range: range),
               match.numberOfRanges >= 2,
               let capture = Range(match.range(at: 1), in: text) {
                let value = text[capture].trimmingCharacters(in: .whitespacesAndNewlines)
                if !value.isEmpty { return value }
            }
        }
        return nil
    }
    
    func extractDate(from text: String, patterns: [String]) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else { continue }
            let range = NSRange(text.startIndex..., in: text)
            let matches = regex.matches(in: text, options: [], range: range)
            
            for match in matches where match.numberOfRanges >= 4 {
                guard
                    let dayRange = Range(match.range(at: 1), in: text),
                    let monthRange = Range(match.range(at: 2), in: text),
                    let yearRange = Range(match.range(at: 3), in: text)
                else { continue }
                
                let dateString = "\(text[dayRange]).\(text[monthRange]).\(text[yearRange])"
                formatter.dateFormat = "dd.MM.yyyy"
                
                if let date = formatter.date(from: dateString) {
                    let yearComponent = Calendar.current.component(.year, from: date)
                    if (2000...2100).contains(yearComponent) {
                        return date
                    }
                }
            }
        }
        return nil
    }
    
    func extractAmount(from text: String, patterns: [String]) -> (decimalValue: Decimal?, matchedText: String?) {
        var bestValue: Decimal = 0
        var matched: String?
        
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else { continue }
            let range = NSRange(text.startIndex..., in: text)
            let matches = regex.matches(in: text, options: [], range: range)
            
            for match in matches where match.numberOfRanges >= 2 {
                guard let capture = Range(match.range(at: 1), in: text) else { continue }
                let rawValue = String(text[capture])
                let normalized = rawValue
                    .replacingOccurrences(of: ".", with: "")
                    .replacingOccurrences(of: ",", with: ".")
                
                if let decimal = Decimal(string: normalized), decimal > bestValue {
                    bestValue = decimal
                    matched = rawValue
                }
            }
        }
        
        return bestValue > 0 ? (bestValue, matched) : (nil, nil)
    }
    
    func detectCurrency(from text: String) -> String {
        for pattern in patterns.currency {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else { continue }
            let range = NSRange(text.startIndex..., in: text)
            if let match = regex.firstMatch(in: text, options: [], range: range),
               match.numberOfRanges >= 2,
               let capture = Range(match.range(at: 1), in: text) {
                switch text[capture].lowercased() {
                case "tl", "₺", "try": return "TRY"
                case "usd": return "USD"
                case "eur": return "EUR"
                case "gbp": return "GBP"
                case "chf": return "CHF"
                default: continue
                }
            }
        }
        return "TRY"
    }
}

