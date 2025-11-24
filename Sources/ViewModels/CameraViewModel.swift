//
//  CameraViewModel.swift
//  Fatura Okuma ve Harcama Takip
//
//  Kamera ViewModel'i
//  MVVM mimarisine uygun olarak kamera işlemlerini ve OCR sürecini yönetir
//

import Foundation
import SwiftUI
import SwiftData
import Combine

/// Kamera işlemlerinin durumları
enum CameraProcessingState {
    case idle           // Beklemede
    case processing     // OCR işlemi devam ediyor
    case success        // Başarılı
    case error(String)  // Hata durumu
}

/// Kamera ViewModel - Kamera ve OCR işlemlerini yönetir
@MainActor
class CameraViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// İşlem durumu
    @Published var state: CameraProcessingState = .idle
    
    /// Çekilen görsel (preview için)
    @Published var capturedImage: UIImage?
    
    // MARK: - Dependencies
    
    private let ocrService = OCRService.shared
    private let parser = InvoiceParser.shared
    
    // MARK: - Methods
    
    /// Çekilen görseli işler (OCR + Parse + Save)
    /// - Parameters:
    ///   - image: Çekilen görsel
    ///   - modelContext: SwiftData model context'i (Invoice kaydetmek için)
    func processImage(_ image: UIImage, modelContext: ModelContext) async {
        // İşlem başladı
        state = .processing
        capturedImage = image
        
        do {
            // 1. OCR ile metni okuyoruz
            let ocrText = try await ocrService.recognizeText(from: image)
            
            // OCR metnini debug için yazdırıyoruz (geliştirme aşamasında)
            print("OCR Metni: \(ocrText)")
            
            // 2. Parser ile anlamlı verileri çıkarıyoruz
            let parsedData = parser.parse(ocrText)
            
            // 3. Eğer yeterli veri bulunduysa Invoice oluşturuyoruz
            guard parsedData.isValid else {
                state = .error("Fatura bilgileri yeterince çıkarılamadı. Lütfen daha net bir görsel çekin.")
                return
            }
            
            // 4. Görseli Data'ya dönüştürüyoruz
            let imageData = image.jpegData(compressionQuality: 0.8)
            
            // 5. Invoice modelini oluşturuyoruz
            let invoice = Invoice(
                invoiceNumber: parsedData.invoiceNumber ?? "Bilinmeyen",
                date: parsedData.date ?? Date(),
                totalAmount: parsedData.totalAmount ?? 0.0,
                taxAmount: parsedData.taxAmount ?? 0.0,
                companyName: parsedData.companyName ?? "Bilinmeyen Firma",
                imageData: imageData,
                fileType: "JPEG"
            )
            
            // 6. SwiftData'ya kaydediyoruz
            modelContext.insert(invoice)
            
            // Başarılı
            state = .success
            
        } catch {
            // Hata durumunda kullanıcıya bilgi veriyoruz
            state = .error("Metin okuma hatası: \(error.localizedDescription)")
        }
    }
    
    /// Dosyadan (PDF/Resim) fatura işler
    /// - Parameters:
    ///   - url: Dosya URL'i
    ///   - modelContext: SwiftData model context'i
    func processFile(_ url: URL, modelContext: ModelContext) async {
        // İşlem başladı
        state = .processing
        
        // Dosya erişim izni alıyoruz (Security Scoped Resource)
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        do {
            // Dosya verisini okuyoruz
            let data = try Data(contentsOf: url)
            
            // Önizleme için görsel oluşturmaya çalışıyoruz
            if let image = UIImage(data: data) {
                capturedImage = image
            } else {
                // PDF ise ilk sayfasını önizleme yapabiliriz (opsiyonel)
                // Şimdilik sadece ikon gösteriyoruz
                capturedImage = UIImage(systemName: "doc.text.fill")
            }
            
            // 1. OCR ile metni okuyoruz
            let ocrText = try await ocrService.recognizeText(from: data)
            print("OCR Metni (Dosya): \(ocrText)")
            
            // 2. Parser ile anlamlı verileri çıkarıyoruz
            let parsedData = parser.parse(ocrText)
            
            // 3. Kontrol
            guard parsedData.isValid else {
                state = .error("Dosyadan fatura bilgileri çıkarılamadı.")
                return
            }
            
            // 4. Invoice oluşturuyoruz
            let invoice = Invoice(
                invoiceNumber: parsedData.invoiceNumber ?? "Bilinmeyen",
                date: parsedData.date ?? Date(),
                totalAmount: parsedData.totalAmount ?? 0.0,
                taxAmount: parsedData.taxAmount ?? 0.0,
                companyName: parsedData.companyName ?? "Bilinmeyen Firma",
                imageData: data, // Orijinal dosya verisini saklıyoruz
                fileType: url.pathExtension.uppercased()
            )
            
            // 5. Kayıt
            modelContext.insert(invoice)
            state = .success
            
        } catch {
            state = .error("Dosya işleme hatası: \(error.localizedDescription)")
        }
    }
    
    /// Durumu sıfırlar (yeni çekim için)
    func reset() {
        state = .idle
        capturedImage = nil
    }
}

