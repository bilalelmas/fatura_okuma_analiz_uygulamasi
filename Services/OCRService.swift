//
//  OCRService.swift
//  Fatura Okuma ve Harcama Takip
//
//  OCR (Optical Character Recognition) Servisi
//  Vision Framework kullanarak resim ve PDF'den metin okuma işlemini yapar
//

import Foundation
import UIKit
import Vision
import PDFKit

/// OCR işlemleri sırasında oluşabilecek hatalar
enum OCRServiceError: LocalizedError {
    case invalidImage
    case invalidPDF
    case recognitionFailed
    case noTextFound
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Geçersiz görsel dosyası"
        case .invalidPDF:
            return "Geçersiz PDF dosyası"
        case .recognitionFailed:
            return "Metin tanıma işlemi başarısız oldu"
        case .noTextFound:
            return "Görselde metin bulunamadı"
        }
    }
}

/// OCR Servisi - Vision Framework kullanarak metin okuma
/// Singleton pattern kullanılarak oluşturulmuştur
class OCRService {
    
    // MARK: - Singleton
    
    /// Paylaşılan OCR servis instance'ı
    static let shared = OCRService()
    
    // Private initializer - Singleton pattern için
    private init() {}
    
    // MARK: - OCR Methods
    
    /// UIImage'den metin okur
    /// - Parameter image: Metin okunacak görsel
    /// - Returns: Okunan metin (String)
    /// - Throws: OCRServiceError
    func recognizeText(from image: UIImage) async throws -> String {
        // UIImage'i CIImage'e dönüştürüyoruz
        guard let cgImage = image.cgImage else {
            throw OCRServiceError.invalidImage
        }
        
        // Vision Framework'ün metin tanıma request'ini oluşturuyoruz
        let request = VNRecognizeTextRequest { request, error in
            // Bu closure, Vision Framework'ün callback'i için kullanılır
            // Ancak async/await kullandığımız için burada işlem yapmıyoruz
        }
        
        // Türkçe ve İngilizce dil desteği ekliyoruz
        // E-arşiv faturalar genellikle Türkçe olduğu için Türkçe öncelikli
        request.recognitionLanguages = ["tr-TR", "en-US"]
        
        // Metin tanıma doğruluğunu artırmak için accuracy seviyesini yüksek yapıyoruz
        request.recognitionLevel = .accurate
        
        // Vision request handler oluşturuyoruz
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Async/await ile metin tanıma işlemini gerçekleştiriyoruz
        return try await withCheckedThrowingContinuation { continuation in
            do {
                // Vision Framework'e görseli işlemesi için gönderiyoruz
                try handler.perform([request])
                
                // Sonuçları alıyoruz
                guard let observations = request.results else {
                    continuation.resume(throwing: OCRServiceError.recognitionFailed)
                    return
                }
                
                // Eğer hiç metin bulunamadıysa hata fırlatıyoruz
                guard !observations.isEmpty else {
                    continuation.resume(throwing: OCRServiceError.noTextFound)
                    return
                }
                
                // Bulunan tüm metinleri birleştiriyoruz
                let recognizedStrings = observations.compactMap { observation in
                    // Her observation'dan en yüksek güvenilirlik skoruna sahip metni alıyoruz
                    observation.topCandidates(1).first?.string
                }
                
                // Tüm metinleri yeni satırlarla birleştirip döndürüyoruz
                let fullText = recognizedStrings.joined(separator: "\n")
                continuation.resume(returning: fullText)
                
            } catch {
                // Hata durumunda hatayı fırlatıyoruz
                continuation.resume(throwing: OCRServiceError.recognitionFailed)
            }
        }
    }
    
    /// Data'dan (PDF veya resim) metin okur
    /// - Parameter data: PDF veya resim dosyasının verisi
    /// - Returns: Okunan metin (String)
    /// - Throws: OCRServiceError
    func recognizeText(from data: Data) async throws -> String {
        // Önce PDF olup olmadığını kontrol ediyoruz
        if let pdfDocument = PDFDocument(data: data) {
            return try await recognizeText(from: pdfDocument)
        }
        
        // PDF değilse UIImage olarak deniyoruz
        guard let image = UIImage(data: data) else {
            throw OCRServiceError.invalidImage
        }
        
        return try await recognizeText(from: image)
    }
    
    /// PDFDocument'ten metin okur
    /// - Parameter pdfDocument: PDF dokümanı
    /// - Returns: Okunan metin (String)
    /// - Throws: OCRServiceError
    func recognizeText(from pdfDocument: PDFDocument) async throws -> String {
        // PDF'in sayfa sayısını kontrol ediyoruz
        guard pdfDocument.pageCount > 0 else {
            throw OCRServiceError.invalidPDF
        }
        
        var allText: [String] = []
        
        // PDF'in her sayfasını tek tek işliyoruz
        for pageIndex in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: pageIndex) else {
                continue
            }
            
            // PDF sayfasını UIImage'e dönüştürüyoruz
            let pageRect = page.bounds(for: .mediaBox)
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            
            let pageImage = renderer.image { context in
                // PDF sayfasını çiziyoruz
                context.cgContext.translateBy(x: 0, y: pageRect.size.height)
                context.cgContext.scaleBy(x: 1.0, y: -1.0)
                page.draw(with: .mediaBox, to: context.cgContext)
            }
            
            // Her sayfadan metin okuyoruz
            do {
                let pageText = try await recognizeText(from: pageImage)
                allText.append(pageText)
            } catch {
                // Bir sayfada hata olsa bile diğer sayfaları okumaya devam ediyoruz
                continue
            }
        }
        
        // Eğer hiç metin bulunamadıysa hata fırlatıyoruz
        guard !allText.isEmpty else {
            throw OCRServiceError.noTextFound
        }
        
        // Tüm sayfalardan okunan metinleri birleştirip döndürüyoruz
        return allText.joined(separator: "\n\n--- Sayfa Ayırıcı ---\n\n")
    }
    
    // MARK: - Helper Methods
    
    /// Görselin kalitesini kontrol eder ve gerekirse iyileştirir
    /// - Parameter image: Kontrol edilecek görsel
    /// - Returns: İyileştirilmiş görsel
    func enhanceImage(_ image: UIImage) -> UIImage {
        // Bu metod ileride görsel iyileştirme algoritmaları eklenebilir
        // Şimdilik orijinal görseli döndürüyoruz
        return image
    }
}

