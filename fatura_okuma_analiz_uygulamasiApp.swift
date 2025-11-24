//
//  fatura_okuma_analiz_uygulamasiApp.swift
//  fatura_okuma_analiz_uygulamasi
//
//  Ana uygulama giriş noktası
//  SwiftUI App lifecycle kullanılarak oluşturulmuştur
//

import SwiftUI
import SwiftData

@main
struct fatura_okuma_analiz_uygulamasiApp: App {
    // SwiftData için model container'ı oluşturuyoruz
    // Bu container, uygulama boyunca veri modelimizi yönetecek
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Invoice.self  // Invoice modelini SwiftData schema'sına ekliyoruz
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
