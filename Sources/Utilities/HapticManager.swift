//
//  HapticManager.swift
//  Fatura Okuma ve Harcama Takip
//
//  Haptic Feedback Yönetimi
//  Kullanıcı etkileşimlerine dokunsal geri bildirim sağlar
//

import UIKit

/// Haptic feedback yönetimi için singleton servis
class HapticManager {
    
    // MARK: - Singleton
    
    /// Paylaşılan HapticManager instance'ı
    static let shared = HapticManager()
    
    // Private initializer - Singleton pattern için
    private init() {}
    
    // MARK: - Feedback Methods
    
    /// Başarılı işlem için hafif titreşim
    func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Hata durumu için titreşim
    func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    /// Uyarı için titreşim
    func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /// Hafif dokunma geri bildirimi
    func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// Orta şiddette dokunma geri bildirimi
    func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// Güçlü dokunma geri bildirimi
    func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    /// Seçim değişikliği için titreşim
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
