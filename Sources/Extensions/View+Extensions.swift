//
//  View+Extensions.swift
//  Fatura Okuma ve Harcama Takip
//
//  SwiftUI View Extension'ları
//  Ortak stil ve modifier'lar
//

import SwiftUI

// MARK: - Card Style

extension View {
    
    /// Kart görünümü stili uygular
    func cardStyle() -> some View {
        self
            .padding()
            .background(Constants.Colors.background)
            .cornerRadius(Constants.Layout.cornerRadius)
    }
    
    /// Gölgeli kart görünümü stili uygular
    func shadowCardStyle() -> some View {
        self
            .cardStyle()
            .shadow(radius: Constants.Layout.shadowRadius)
    }
}

// MARK: - Button Styles

extension View {
    
    /// Birincil buton stili (Mavi, dolgu)
    func primaryButtonStyle() -> some View {
        self
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Constants.Colors.primaryBlue)
            .cornerRadius(Constants.Layout.cornerRadius)
    }
    
    /// İkincil buton stili (Mavi, saydam arka plan)
    func secondaryButtonStyle() -> some View {
        self
            .foregroundColor(Constants.Colors.primaryBlue)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Constants.Colors.primaryBlue.opacity(0.1))
            .cornerRadius(Constants.Layout.cornerRadius)
    }
    
    /// Tehlikeli işlem butonu stili (Kırmızı)
    func destructiveButtonStyle() -> some View {
        self
            .foregroundColor(Constants.Colors.errorRed)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Constants.Colors.errorRed.opacity(0.1))
            .cornerRadius(Constants.Layout.cornerRadius)
    }
}

// MARK: - Loading State

extension View {
    
    /// Loading overlay ekler
    /// - Parameter isLoading: Loading durumu
    func loadingOverlay(isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        }
    }
}

// MARK: - Conditional Modifiers

extension View {
    
    /// Koşullu modifier uygular
    /// - Parameters:
    ///   - condition: Koşul
    ///   - transform: Uygulanacak modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Haptic Feedback

extension View {
    
    /// Dokunma ile birlikte haptic feedback ekler
    func withHapticFeedback(_ style: HapticStyle = .light) -> some View {
        self.simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    switch style {
                    case .light:
                        HapticManager.shared.light()
                    case .medium:
                        HapticManager.shared.medium()
                    case .heavy:
                        HapticManager.shared.heavy()
                    case .success:
                        HapticManager.shared.success()
                    case .error:
                        HapticManager.shared.error()
                    case .warning:
                        HapticManager.shared.warning()
                    }
                }
        )
    }
}

/// Haptic feedback stilleri
enum HapticStyle {
    case light
    case medium
    case heavy
    case success
    case error
    case warning
}

// MARK: - Accessibility

extension View {
    
    /// Accessibility label ve hint ekler
    /// - Parameters:
    ///   - label: Accessibility label
    ///   - hint: Accessibility hint
    func accessible(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .if(hint != nil) { view in
                view.accessibilityHint(hint!)
            }
    }
}
