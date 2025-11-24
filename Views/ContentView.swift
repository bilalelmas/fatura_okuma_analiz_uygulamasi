//
//  ContentView.swift
//  Fatura Okuma ve Harcama Takip
//
//  Ana içerik görünümü
//  TabView ile ana ekran ve fatura listesi arasında geçiş sağlar
//

import SwiftUI
import SwiftData
import VisionKit

struct ContentView: View {
    // MARK: - Properties
    
    /// SwiftData model context'i (Invoice kaydetmek için)
    @Environment(\.modelContext) private var modelContext
    
    /// Kamera ViewModel'i
    @StateObject private var cameraViewModel = CameraViewModel()
    
    /// Kamera görünümünün gösterilip gösterilmeyeceği
    @State private var showCamera = false
    
    /// Dosya seçicinin gösterilip gösterilmeyeceği
    @State private var showDocumentPicker = false
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            // Ana Ekran Tab
            homeTab
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
            
            // Fatura Listesi Tab
            NavigationStack {
                InvoiceListView()
            }
            .tabItem {
                Label("Faturalar", systemImage: "list.bullet")
            }
            
            // Analiz Tab
            InvoiceAnalysisView()
                .tabItem {
                    Label("Analiz", systemImage: "chart.pie.fill")
                }
        }
        .sheet(isPresented: $showCamera) {
            // Kamera görünümünü sheet olarak gösteriyoruz
            DocumentCameraView(
                onDocumentScanned: { image in
                    // Görsel çekildiğinde işleme gönderiyoruz
                    Task {
                        await cameraViewModel.processImage(image, modelContext: modelContext)
                    }
                },
                onCancel: {
                    // Kullanıcı kamerayı iptal ettiğinde
                    cameraViewModel.reset()
                }
            )
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                Task {
                    await cameraViewModel.processFile(url, modelContext: modelContext)
                }
            }
        }
    }
    
    // MARK: - Home Tab
    
    /// Ana ekran tab'ı
    private var homeTab: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Logo ve başlık
                VStack(spacing: 16) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .font(.system(size: 60))
                    
                    Text("E-Arşiv Fatura Okuma")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Faturanızı çekin, otomatik olarak analiz edelim")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Kamera butonu
                Button(action: {
                    // VNDocumentCameraViewController'ın kullanılabilir olup olmadığını kontrol ediyoruz
                    if VNDocumentCameraViewController.isSupported {
                        showCamera = true
                    } else {
                        // Cihaz kamera desteklemiyorsa kullanıcıya bilgi veriyoruz
                        cameraViewModel.state = .error("Bu cihaz doküman tarama özelliğini desteklemiyor.")
                    }
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                            .font(.title2)
                        Text("Fatura Çek")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }

                .padding(.horizontal, 40)
                
                // Dosya Yükle butonu
                Button(action: {
                    showDocumentPicker = true
                }) {
                    HStack {
                        Image(systemName: "folder.fill")
                            .font(.title2)
                        Text("Dosya Yükle")
                            .font(.headline)
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                
                // İşlem durumu gösterimi
                if case .processing = cameraViewModel.state {
                    ProgressView("Fatura işleniyor...")
                        .padding()
                } else if case .success = cameraViewModel.state {
                    Label("Fatura başarıyla kaydedildi!", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .padding()
                        .onAppear {
                            // 2 saniye sonra durumu sıfırlıyoruz
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                cameraViewModel.reset()
                            }
                        }
                } else if case .error(let message) = cameraViewModel.state {
                    Label(message, systemImage: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle("Fatura Takip")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Invoice.self, inMemory: true)
}

