//
//  DocumentCameraView.swift
//  Fatura Okuma ve Harcama Takip
//
//  Doküman Kamera Görünümü
//  VNDocumentCameraViewController'ı SwiftUI'ye entegre eder
//

import SwiftUI
import VisionKit

/// VNDocumentCameraViewController'ı SwiftUI'ye entegre eden UIViewControllerRepresentable
/// Bu sayede UIKit tabanlı kamera görünümünü SwiftUI içinde kullanabiliyoruz
struct DocumentCameraView: UIViewControllerRepresentable {
    // MARK: - Properties
    
    /// Kamera işlemi tamamlandığında çağrılacak callback
    /// Çekilen görseli parametre olarak alır
    var onDocumentScanned: (UIImage) -> Void
    
    /// Kamera iptal edildiğinde çağrılacak callback
    var onCancel: () -> Void
    
    // MARK: - UIViewControllerRepresentable Methods
    
    /// UIKit view controller'ı oluşturur
    /// - Parameter context: Context bilgisi
    /// - Returns: VNDocumentCameraViewController instance'ı
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    /// View controller güncellendiğinde çağrılır (genellikle kullanılmaz)
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        // VNDocumentCameraViewController güncelleme gerektirmez
    }
    
    // MARK: - Coordinator
    
    /// Coordinator oluşturur (delegate pattern için)
    func makeCoordinator() -> Coordinator {
        Coordinator(onDocumentScanned: onDocumentScanned, onCancel: onCancel)
    }
    
    /// Coordinator sınıfı - VNDocumentCameraViewControllerDelegate protokolünü implement eder
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var onDocumentScanned: (UIImage) -> Void
        var onCancel: () -> Void
        
        init(onDocumentScanned: @escaping (UIImage) -> Void, onCancel: @escaping () -> Void) {
            self.onDocumentScanned = onDocumentScanned
            self.onCancel = onCancel
        }
        
        /// Kullanıcı doküman taradığında çağrılır
        /// - Parameters:
        ///   - controller: Kamera view controller'ı
        ///   - scan: Taranan doküman bilgisi
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            // Taranan sayfa sayısını kontrol ediyoruz
            guard scan.pageCount > 0 else {
                controller.dismiss(animated: true)
                onCancel()
                return
            }
            
            // İlk sayfayı alıyoruz (çok sayfalı dokümanlar için ileride geliştirilebilir)
            let pageImage = scan.imageOfPage(at: 0)
            
            // Kamera görünümünü kapatıyoruz
            controller.dismiss(animated: true) {
                // Görseli callback ile gönderiyoruz
                self.onDocumentScanned(pageImage)
            }
        }
        
        /// Kullanıcı kamerayı iptal ettiğinde çağrılır
        /// - Parameter controller: Kamera view controller'ı
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
            onCancel()
        }
        
        /// Kamera kullanımı sırasında hata oluştuğunda çağrılır
        /// - Parameters:
        ///   - controller: Kamera view controller'ı
        ///   - error: Oluşan hata
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true)
            onCancel()
        }
    }
}

