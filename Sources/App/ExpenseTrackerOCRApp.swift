//
//  ExpenseTrackerOCRApp.swift
//  ExpenseTrackerOCR
//
//  Uygulamanın giriş noktası ve SwiftData container kurulumu
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerOCRApp: App {
    // SwiftData container'ı uygulama yaşadığı sürece tek noktadan yönetiyoruz
    private let modelContainer: ModelContainer
    
    init() {
        // Şema gelecekte büyüyebileceği için Schema nesnesi üzerinden ilerliyoruz
        let schema = Schema([
            Invoice.self // Adım 2'de ayrıntılandıracağımız tekil model
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("SwiftData model container oluşturulamadı: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(modelContainer)
    }
}
