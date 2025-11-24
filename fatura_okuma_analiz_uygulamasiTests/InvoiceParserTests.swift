//
//  InvoiceParserTests.swift
//  fatura_okuma_analiz_uygulamasiTests
//
//  InvoiceParser Unit Testleri
//  Regex ve parsing mantığını test eder
//

import XCTest
@testable import ExpenseTrackerOCR

final class InvoiceParserTests: XCTestCase {
    
    var parser: InvoiceParser!
    
    override func setUp() {
        super.setUp()
        parser = InvoiceParser()
    }
    
    override func tearDown() {
        parser = nil
        super.tearDown()
    }
    
    // MARK: - Invoice Number Tests
    
    func testParseInvoiceNumber_ValidFormat() {
        // Given
        let text = """
        E-ARŞIV FATURA
        Fatura No: ABC2023000123456
        Tarih: 15.11.2023
        """
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertEqual(result.invoiceNumber, "ABC2023000123456")
    }
    
    func testParseInvoiceNumber_AlternativeFormat() {
        // Given
        let text = """
        FATURA NUMARASI: XYZ2023999888
        Tarih: 20.10.2023
        """
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertEqual(result.invoiceNumber, "XYZ2023999888")
    }
    
    func testParseInvoiceNumber_NotFound() {
        // Given
        let text = "Sadece tarih var: 15.11.2023"
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertNil(result.invoiceNumber)
    }
    
    // MARK: - Date Tests
    
    func testParseDate_DDMMYYYYFormat() {
        // Given
        let text = """
        Fatura Tarihi: 15.11.2023
        Toplam: 100,00 TL
        """
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertNotNil(result.date)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: result.date!)
        XCTAssertEqual(components.day, 15)
        XCTAssertEqual(components.month, 11)
        XCTAssertEqual(components.year, 2023)
    }
    
    func testParseDate_AlternativeFormat() {
        // Given
        let text = "Tarih: 01/12/2023"
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertNotNil(result.date)
    }
    
    func testParseDate_NotFound() {
        // Given
        let text = "Fatura No: ABC123"
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertNil(result.date)
    }
    
    // MARK: - Amount Tests
    
    func testParseTotalAmount_TurkishFormat() {
        // Given
        let text = """
        Toplam Tutar: 1.234,56 TL
        KDV: 234,56 TL
        """
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertEqual(result.totalAmount, 1234.56, accuracy: 0.01)
    }
    
    func testParseTotalAmount_WithoutThousandsSeparator() {
        // Given
        let text = "Toplam: 500,75 TL"
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertEqual(result.totalAmount, 500.75, accuracy: 0.01)
    }
    
    func testParseTaxAmount_Valid() {
        // Given
        let text = """
        KDV Tutarı: 180,00 TL
        Toplam: 1.000,00 TL
        """
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertEqual(result.taxAmount, 180.00, accuracy: 0.01)
    }
    
    // MARK: - Company Name Tests
    
    func testParseCompanyName_Valid() {
        // Given
        let text = """
        Firma Adı: ÖRNEK TİCARET A.Ş.
        Fatura No: ABC123
        """
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertEqual(result.companyName, "ÖRNEK TİCARET A.Ş.")
    }
    
    func testParseCompanyName_AlternativeFormat() {
        // Given
        let text = """
        Satıcı: TEST MARKET LTD. ŞTİ.
        Tarih: 15.11.2023
        """
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertNotNil(result.companyName)
    }
    
    // MARK: - Integration Tests
    
    func testParseCompleteInvoice_AllFieldsPresent() {
        // Given
        let text = """
        E-ARŞIV FATURA
        
        Firma Adı: ÖRNEK TİCARET A.Ş.
        Fatura No: ABC2023000123456
        Fatura Tarihi: 15.11.2023
        
        Toplam Tutar: 1.234,56 TL
        KDV Tutarı: 234,56 TL
        """
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertTrue(result.isValid)
        XCTAssertNotNil(result.invoiceNumber)
        XCTAssertNotNil(result.date)
        XCTAssertNotNil(result.totalAmount)
        XCTAssertNotNil(result.taxAmount)
        XCTAssertNotNil(result.companyName)
    }
    
    func testParseInvoice_PartialData() {
        // Given
        let text = """
        Fatura No: ABC123
        Toplam: 100,00 TL
        """
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertFalse(result.isValid) // Eksik alanlar var
        XCTAssertNotNil(result.invoiceNumber)
        XCTAssertNotNil(result.totalAmount)
        XCTAssertNil(result.date)
    }
    
    func testParseInvoice_EmptyText() {
        // Given
        let text = ""
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertFalse(result.isValid)
        XCTAssertNil(result.invoiceNumber)
        XCTAssertNil(result.date)
        XCTAssertNil(result.totalAmount)
    }
    
    // MARK: - Edge Cases
    
    func testParseAmount_WithMultipleDecimals() {
        // Given
        let text = "Toplam: 1.234.567,89 TL"
        
        // When
        let result = parser.parse(text)
        
        // Then
        XCTAssertEqual(result.totalAmount, 1234567.89, accuracy: 0.01)
    }
    
    func testParseDate_InvalidFormat() {
        // Given
        let text = "Tarih: 2023-11-15" // ISO format
        
        // When
        let result = parser.parse(text)
        
        // Then
        // Parser şu an sadece DD.MM.YYYY formatını destekliyor
        // Gelecekte daha fazla format eklenebilir
        XCTAssertNil(result.date)
    }
}
