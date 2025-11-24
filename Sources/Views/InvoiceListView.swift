//
//  InvoiceListView.swift
//  Fatura Okuma ve Harcama Takip
//
//  Fatura Listesi Görünümü
//  SwiftData Query ile kaydedilmiş faturaları listeler
//

import SwiftUI
import SwiftData

struct InvoiceListView: View {
    // MARK: - Properties
    
    /// SwiftData Query - Faturaları otomatik olarak çeker
    @Query(sort: \Invoice.date, order: .reverse) private var invoices: [Invoice]
    
    /// SwiftData model context (silme işlemi için)
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if invoices.isEmpty {
                // Fatura yoksa boş durum gösterimi
                emptyStateView
            } else {
                // Fatura listesi
                invoiceList
            }
        }
        .navigationTitle("Faturalar")
    }
    
    // MARK: - Empty State
    
    /// Boş durum görünümü (henüz fatura yoksa)
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("Henüz fatura yok")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Fatura çekmek için ana ekrandaki butonu kullanın")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
    
    // MARK: - Invoice List
    
    /// Fatura listesi görünümü
    private var invoiceList: some View {
        List {
            ForEach(invoices) { invoice in
                // Her fatura için navigation link
                NavigationLink(destination: InvoiceDetailView(invoice: invoice)) {
                    InvoiceRowView(invoice: invoice)
                }
            }
            .onDelete(perform: deleteInvoices)
        }
        .listStyle(.insetGrouped)
    }
    
    // MARK: - Methods
    
    /// Faturaları siler
    /// - Parameter indexSet: Silinecek faturaların index'leri
    private func deleteInvoices(at offsets: IndexSet) {
        // Seçilen index'lere göre faturaları siliyoruz
        for index in offsets {
            modelContext.delete(invoices[index])
        }
    }
}

// MARK: - Invoice Row View

/// Fatura satır görünümü (liste içinde gösterilecek)
struct InvoiceRowView: View {
    let invoice: Invoice
    
    var body: some View {
        HStack(spacing: 12) {
            // Firma ikonu
            Image(systemName: "building.2.fill")
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            // Fatura bilgileri
            VStack(alignment: .leading, spacing: 4) {
                Text(invoice.companyName)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(invoice.invoiceNumber)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(invoice.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Tutar bilgisi
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatCurrency(invoice.totalAmount))
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                if invoice.taxAmount > 0 {
                    Text("KDV: \(formatCurrency(invoice.taxAmount))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    /// Para birimi formatı
    /// - Parameter amount: Formatlanacak tutar
    /// - Returns: Formatlanmış string (örn: "100,00 TL")
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount) TL"
    }
}

#Preview {
    NavigationStack {
        InvoiceListView()
            .modelContainer(for: Invoice.self, inMemory: true)
    }
}

