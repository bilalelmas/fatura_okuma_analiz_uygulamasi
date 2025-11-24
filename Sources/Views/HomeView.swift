//
//  HomeView.swift
//  ExpenseTrackerOCR
//
//  Ana içerik görünümü
//  TabView ile ana ekran ve fatura listesi arasında geçiş sağlar
//

import SwiftUI
import SwiftData
import VisionKit

struct HomeView: View {
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
                    Label(Constants.Strings.homeTab, systemImage: Constants.Icons.house)
                }
            
            // Fatura Listesi Tab
            NavigationStack {
                InvoiceListView()
            }
            .tabItem {
                Label(Constants.Strings.invoicesTab, systemImage: Constants.Icons.list)
            }
            
            // Analiz Tab
            InvoiceAnalysisView()
                .tabItem {
                    Label(Constants.Strings.analysisTab, systemImage: Constants.Icons.chart)
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
                    Image(systemName: Constants.Icons.document)
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .font(.system(size: 60))
                    
                    Text(Constants.Strings.appTitle)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(Constants.Strings.appSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Kamera butonu
                Button(action: {
                    HapticManager.shared.light()
                    // VNDocumentCameraViewController'ın kullanılabilir olup olmadığını kontrol ediyoruz
                    if VNDocumentCameraViewController.isSupported {
                        showCamera = true
                    } else {
                        // Cihaz kamera desteklemiyorsa kullanıcıya bilgi veriyoruz
                        HapticManager.shared.error()
                        cameraViewModel.state = .error("Bu cihaz doküman tarama özelliğini desteklemiyor.")
                    }
                }) {
                    HStack {
                        Image(systemName: Constants.Icons.camera)
                            .font(.title2)
                        Text(Constants.Strings.scanInvoiceButton)
                            .font(.headline)
                    }
                    .primaryButtonStyle()
                }

                .padding(.horizontal, Constants.Layout.horizontalPadding)
                
                // Dosya Yükle butonu
                Button(action: {
                    HapticManager.shared.light()
                    showDocumentPicker = true
                }) {
                    HStack {
                        Image(systemName: Constants.Icons.folder)
                            .font(.title2)
                        Text(Constants.Strings.uploadFileButton)
                            .font(.headline)
                    }
                    .secondaryButtonStyle()
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
                .padding(.bottom, Constants.Layout.horizontalPadding)
                
                // İşlem durumu gösterimi
                if case .processing = cameraViewModel.state {
                    ProgressView(Constants.Strings.processingMessage)
                        .padding()
                } else if case .success = cameraViewModel.state {
                    Label(Constants.Strings.successMessage, systemImage: Constants.Icons.checkmark)
                        .foregroundColor(Constants.Colors.successGreen)
                        .padding()
                        .onAppear {
                            HapticManager.shared.success()
                            // Başarı mesajı gösterim süresi sonra durumu sıfırlıyoruz
                            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Time.successMessageDuration) {
                                cameraViewModel.reset()
                            }
                        }
                } else if case .error(let message) = cameraViewModel.state {
                    Label(message, systemImage: Constants.Icons.error)
                        .foregroundColor(Constants.Colors.errorRed)
                        .padding()
                        .multilineTextAlignment(.center)
                        .onAppear {
                            HapticManager.shared.error()
                        }
                }
            }
            .navigationTitle("Fatura Takip")
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Invoice.self, inMemory: true)
}

