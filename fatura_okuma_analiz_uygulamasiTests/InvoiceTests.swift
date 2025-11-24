//
//  InvoiceTests.swift
//  fatura_okuma_analiz_uygulamasiTests
//
//  Invoice Model Unit Testleri
//  Model validasyonu ve computed properties testleri
//

import XCTest
@testable import ExpenseTrackerOCR

final class InvoiceTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInvoiceInitialization_ValidData() {
        // Given & When
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // Then
        XCTAssertEqual(invoice.invoiceNumber, "ABC123")
        XCTAssertEqual(invoice.totalAmount, 100.0)
        XCTAssertEqual(invoice.taxAmount, 18.0)
        XCTAssertEqual(invoice.companyName, "Test Company")
        XCTAssertNil(invoice.category)
        XCTAssertNil(invoice.notes)
    }
    
    // MARK: - Computed Properties Tests
    
    func testAmountWithoutTax_Calculation() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 118.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When
        let amountWithoutTax = invoice.amountWithoutTax
        
        // Then
        XCTAssertEqual(amountWithoutTax, 100.0, accuracy: 0.01)
    }
    
    func testIsRecent_Today() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertTrue(invoice.isRecent)
    }
    
    func testIsRecent_Yesterday() {
        // Given
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: yesterday,
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertTrue(invoice.isRecent)
    }
    
    func testIsRecent_OldDate() {
        // Given
        let oldDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: oldDate,
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertFalse(invoice.isRecent)
    }
    
    func testIsThisMonth_CurrentMonth() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertTrue(invoice.isThisMonth)
    }
    
    func testIsThisYear_CurrentYear() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertTrue(invoice.isThisYear)
    }
    
    func testHasCategory_WithCategory() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        invoice.category = "Yemek"
        
        // When & Then
        XCTAssertTrue(invoice.hasCategory)
    }
    
    func testHasCategory_WithoutCategory() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertFalse(invoice.hasCategory)
    }
    
    // MARK: - Validation Tests
    
    func testIsValid_AllFieldsPresent() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertTrue(invoice.isValid)
    }
    
    func testIsValid_EmptyInvoiceNumber() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertFalse(invoice.isValid)
    }
    
    func testIsValid_EmptyCompanyName() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: ""
        )
        
        // When & Then
        XCTAssertFalse(invoice.isValid)
    }
    
    func testIsValid_ZeroAmount() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 0.0,
            taxAmount: 0.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertFalse(invoice.isValid)
    }
    
    func testIsValid_NegativeTax() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: -10.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertFalse(invoice.isValid)
    }
    
    func testHasValidInvoiceNumber_ValidLength() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC2023000123456", // 16 karakter
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertTrue(invoice.hasValidInvoiceNumber)
    }
    
    func testHasValidInvoiceNumber_TooShort() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123", // 6 karakter
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When & Then
        XCTAssertFalse(invoice.hasValidInvoiceNumber)
    }
    
    // MARK: - Formatting Tests
    
    func testFormattedTotalAmount() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 1234.56,
            taxAmount: 234.56,
            companyName: "Test Company"
        )
        
        // When
        let formatted = invoice.formattedTotalAmount
        
        // Then
        XCTAssertTrue(formatted.contains("1.234,56") || formatted.contains("1234,56"))
    }
    
    func testSummaryDescription() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        
        // When
        let summary = invoice.summaryDescription
        
        // Then
        XCTAssertTrue(summary.contains("Test Company"))
        XCTAssertTrue(summary.contains("100"))
    }
    
    // MARK: - Update Tests
    
    func testUpdate_InvoiceNumber() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        let oldUpdatedAt = invoice.updatedAt
        
        // When
        Thread.sleep(forTimeInterval: 0.1) // updatedAt farkını görmek için
        invoice.update(invoiceNumber: "XYZ789")
        
        // Then
        XCTAssertEqual(invoice.invoiceNumber, "XYZ789")
        XCTAssertGreaterThan(invoice.updatedAt, oldUpdatedAt)
    }
    
    func testUpdate_MultipleFields() {
        // Given
        let invoice = Invoice(
            invoiceNumber: "ABC123",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Test Company"
        )
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        // When
        invoice.update(
            invoiceNumber: "XYZ789",
            date: newDate,
            totalAmount: 200.0,
            taxAmount: 36.0,
            companyName: "New Company"
        )
        
        // Then
        XCTAssertEqual(invoice.invoiceNumber, "XYZ789")
        XCTAssertEqual(invoice.date, newDate)
        XCTAssertEqual(invoice.totalAmount, 200.0)
        XCTAssertEqual(invoice.taxAmount, 36.0)
        XCTAssertEqual(invoice.companyName, "New Company")
    }
}
