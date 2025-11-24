//
//  InvoiceAnalysisView.swift
//  Fatura Okuma ve Harcama Takip
//
//  Harcama Analiz Görünümü
//  SwiftCharts kullanarak harcamaları görselleştirir
//

import SwiftUI
import SwiftData
import Charts

struct InvoiceAnalysisView: View {
    // MARK: - Properties
    
    /// SwiftData Query - Tüm faturaları çeker
    @Query private var invoices: [Invoice]
    
    /// Seçilen analiz periyodu
    @State private var selectedPeriod: AnalysisPeriod = .monthly
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Periyot seçici
                    periodPicker
                    
                    if invoices.isEmpty {
                        emptyStateView
                    } else {
                        // Toplam harcama kartı
                        totalSpendingCard
                        
                        // Kategori bazlı harcama grafiği (Pasta)
                        categoryChartSection
                        
                        // Zaman bazlı harcama grafiği (Çubuk)
                        timeBasedChartSection
                    }
                }
                .padding()
            }
            .navigationTitle("Harcama Analizi")
        }
    }
    
    // MARK: - Components
    
    /// Periyot seçici (Segmented Control)
    private var periodPicker: some View {
        Picker("Periyot", selection: $selectedPeriod) {
            ForEach(AnalysisPeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }
    
    /// Boş durum görünümü
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 40)
            Image(systemName: "chart.pie")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("Analiz için veri yok")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Grafikleri görmek için fatura ekleyin")
                .foregroundStyle(.secondary)
        }
    }
    
    /// Toplam harcama kartı
    private var totalSpendingCard: some View {
        VStack(spacing: 8) {
            Text("Toplam Harcama")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(formatCurrency(totalAmount))
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.primary)
            
            Text("\(invoices.count) adet fatura")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    /// Kategori bazlı harcama grafiği
    private var categoryChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Kategorilere Göre")
                .font(.headline)
            
            Chart(categoryData) { item in
                SectorMark(
                    angle: .value("Tutar", item.amount),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Kategori", item.category))
            }
            .frame(height: 250)
            
            // Kategori lejantı (Chart otomatik gösteriyor ama özel tasarım istersek buraya ekleyebiliriz)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    /// Zaman bazlı harcama grafiği
    private var timeBasedChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Zamana Göre")
                .font(.headline)
            
            Chart(timeData) { item in
                BarMark(
                    x: .value("Tarih", item.date, unit: .day),
                    y: .value("Tutar", item.amount)
                )
                .foregroundStyle(.blue.gradient)
            }
            .frame(height: 250)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    // MARK: - Helpers & Logic
    
    /// Toplam tutar
    private var totalAmount: Double {
        invoices.reduce(0) { $0 + $1.totalAmount }
    }
    
    /// Kategori verisi (Grafik için)
    private var categoryData: [CategoryChartData] {
        let grouped = Dictionary(grouping: invoices) { $0.category ?? "Diğer" }
        return grouped.map { category, invoices in
            CategoryChartData(
                category: category,
                amount: invoices.reduce(0) { $0 + $1.totalAmount }
            )
        }.sorted { $0.amount > $1.amount }
    }
    
    /// Zaman verisi (Grafik için)
    private var timeData: [TimeChartData] {
        // Basitçe son faturaları gösteriyoruz
        // Gerçek uygulamada seçilen periyoda göre filtreleme yapılmalı
        return invoices.map { invoice in
            TimeChartData(date: invoice.date, amount: invoice.totalAmount)
        }.sorted { $0.date < $1.date }
    }
    
    /// Para birimi formatı
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount) TL"
    }
}

// MARK: - Models

enum AnalysisPeriod: String, CaseIterable {
    case weekly = "Haftalık"
    case monthly = "Aylık"
    case yearly = "Yıllık"
}

struct CategoryChartData: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
}

struct TimeChartData: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}

#Preview {
    InvoiceAnalysisView()
        .modelContainer(for: Invoice.self, inMemory: true)
}
