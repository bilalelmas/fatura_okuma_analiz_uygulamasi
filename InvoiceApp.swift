//
//  InvoiceApp.swift
//  Fatura Okuma ve Harcama Takip
//
//  Ana uygulama giriş noktası
//  SwiftUI App lifecycle kullanılarak oluşturulmuştur
//

import SwiftUI
import SwiftData

@main
struct InvoiceApp: App {
    // SwiftData için model container'ı oluşturuyoruz
    // Bu container, uygulama boyunca veri modelimizi yönetecek
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            // Buraya Invoice modeli eklenecek (Adım 2'de)
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("SwiftData model container oluşturulamadı: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            // Ana görünüm buraya eklenecek
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

