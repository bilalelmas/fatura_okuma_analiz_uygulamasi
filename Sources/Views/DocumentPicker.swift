//
//  DocumentPicker.swift
//  Fatura Okuma ve Harcama Takip
//
//  Dosya Seçici
//  UIDocumentPickerViewController'ı SwiftUI'ye entegre eder
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    // MARK: - Properties
    
    /// Dosya seçildiğinde çağrılacak callback
    var onDocumentPicked: (URL) -> Void
    
    // MARK: - UIViewControllerRepresentable Methods
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // Desteklenen dosya türleri: PDF ve Görseller
        let supportedTypes: [UTType] = [.pdf, .image]
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onDocumentPicked: onDocumentPicked)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onDocumentPicked: (URL) -> Void
        
        init(onDocumentPicked: @escaping (URL) -> Void) {
            self.onDocumentPicked = onDocumentPicked
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onDocumentPicked(url)
        }
    }
}
