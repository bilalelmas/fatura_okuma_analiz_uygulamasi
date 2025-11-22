//
//  ContentView.swift
//  Fatura Okuma ve Harcama Takip
//
//  Ana içerik görünümü
//  Şimdilik placeholder olarak kullanılıyor, ileride ana ekran buraya eklenecek
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "doc.text.magnifyingglass")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("E-Arşiv Fatura Okuma")
                .font(.title)
                .padding()
            Text("Uygulama hazırlanıyor...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

