//
//  InvoiceDetailView.swift
//  Fatura Okuma ve Harcama Takip
//
//  Fatura Detay Görünümü
//  Fatura bilgilerini gösterir ve düzenleme imkanı sağlar
//

import SwiftUI
import SwiftData

struct InvoiceDetailView: View {
    // MARK: - Properties
    
    /// Gösterilecek fatura
    let invoice: Invoice
    
    /// SwiftData model context (silme ve güncelleme için)
    @Environment(\.modelContext) private var modelContext
    
    /// Düzenleme modu
    @State private var isEditing = false
    
    /// Düzenlenebilir alanlar
    @State private var editedCompanyName: String = ""
    @State private var editedCategory: String = ""
    @State private var editedNotes: String = ""
    
    /// Silme onayı
    @State private var showDeleteAlert = false
    
    /// Navigation'dan geri dönme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Fatura görseli (varsa)
                if let imageData = invoice.imageData,
                   let uiImage = UIImage(data: imageData) {
                    invoiceImageView(uiImage)
                }
                
                // Fatura bilgileri
                invoiceInfoSection
                
                // Tutar bilgileri
                amountSection
                
                // Kullanıcı bilgileri (kategori, notlar)
                userInfoSection
                
                // Silme butonu
                deleteButton
            }
            .padding()
        }
        .navigationTitle("Fatura Detayı")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Kaydet" : "Düzenle") {
                    if isEditing {
                        saveChanges()
                    } else {
                        startEditing()
                    }
                }
            }
        }
        .alert("Faturayı Sil", isPresented: $showDeleteAlert) {
            Button("İptal", role: .cancel) { }
            Button("Sil", role: .destructive) {
                deleteInvoice()
            }
        } message: {
            Text("Bu faturayı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.")
        }
        .onAppear {
            loadInvoiceData()
        }
    }
    
    // MARK: - Invoice Image View
    
    /// Fatura görseli görünümü
    /// - Parameter image: Gösterilecek görsel
    /// - Returns: Görsel görünümü
    private func invoiceImageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 300)
            .cornerRadius(12)
            .shadow(radius: 5)
    }
    
    // MARK: - Invoice Info Section
    
    /// Fatura bilgileri bölümü
    private var invoiceInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fatura Bilgileri")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            InfoRow(label: "Fatura No", value: invoice.invoiceNumber)
            InfoRow(label: "Tarih", value: formatDate(invoice.date))
            InfoRow(label: "Firma", value: invoice.companyName, isEditable: isEditing, editedValue: $editedCompanyName)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Amount Section
    
    /// Tutar bilgileri bölümü
    private var amountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tutar Bilgileri")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            InfoRow(label: "Vergi Hariç", value: formatCurrency(invoice.amountWithoutTax))
            InfoRow(label: "KDV", value: formatCurrency(invoice.taxAmount))
            InfoRow(label: "Toplam", value: formatCurrency(invoice.totalAmount))
                .font(.headline)
                .foregroundStyle(.blue)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - User Info Section
    
    /// Kullanıcı bilgileri bölümü (kategori, notlar)
    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Kategoriler ve Notlar")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            if isEditing {
                TextField("Kategori (örn: Yemek, Ulaşım)", text: $editedCategory)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Notlar", text: $editedNotes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
            } else {
                if let category = invoice.category, !category.isEmpty {
                    InfoRow(label: "Kategori", value: category)
                }
                
                if let notes = invoice.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notlar")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(notes)
                            .font(.body)
                    }
                } else {
                    Text("Not eklenmemiş")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Delete Button
    
    /// Silme butonu
    private var deleteButton: some View {
        Button(action: {
            showDeleteAlert = true
        }) {
            HStack {
                Image(systemName: "trash")
                Text("Faturayı Sil")
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Methods
    
    /// Fatura verilerini yükler (düzenleme için)
    private func loadInvoiceData() {
        editedCompanyName = invoice.companyName
        editedCategory = invoice.category ?? ""
        editedNotes = invoice.notes ?? ""
    }
    
    /// Düzenleme modunu başlatır
    private func startEditing() {
        isEditing = true
    }
    
    /// Değişiklikleri kaydeder
    private func saveChanges() {
        invoice.companyName = editedCompanyName
        invoice.category = editedCategory.isEmpty ? nil : editedCategory
        invoice.notes = editedNotes.isEmpty ? nil : editedNotes
        invoice.updatedAt = Date()
        
        // SwiftData otomatik olarak değişiklikleri kaydeder
        isEditing = false
    }
    
    /// Faturayı siler
    private func deleteInvoice() {
        modelContext.delete(invoice)
        dismiss()
    }
    
    /// Tarih formatı
    /// - Parameter date: Formatlanacak tarih
    /// - Returns: Formatlanmış string
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    /// Para birimi formatı
    /// - Parameter amount: Formatlanacak tutar
    /// - Returns: Formatlanmış string
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount) TL"
    }
}

// MARK: - Info Row View

/// Bilgi satırı görünümü (label-value çifti)
struct InfoRow: View {
    let label: String
    let value: String
    var isEditable: Bool = false
    @Binding var editedValue: String
    
    init(label: String, value: String, isEditable: Bool = false, editedValue: Binding<String> = .constant("")) {
        self.label = label
        self.value = value
        self.isEditable = isEditable
        self._editedValue = editedValue
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            if isEditable {
                TextField("", text: $editedValue)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.trailing)
            } else {
                Text(value)
                    .font(.body)
            }
        }
    }
}

#Preview {
    NavigationStack {
        InvoiceDetailView(invoice: Invoice(
            invoiceNumber: "1234567890",
            date: Date(),
            totalAmount: 100.0,
            taxAmount: 18.0,
            companyName: "Örnek Firma A.Ş."
        ))
        .modelContainer(for: Invoice.self, inMemory: true)
    }
}

