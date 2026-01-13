//
//  AboutAppView.swift
//  WTScan
//
//  Created by iMac on 01/12/25.
//

import SwiftUI

struct AboutAppView: View {
    @StateObject var viewModel = AboutAppViewModel()
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack {
                LinearGradient.optionBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    aboutAppSection
                }
                //.background(Color.lightGreenBg.opacity(0.1))
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                .onTapGesture {
                    Utility.hideKeyboard()
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .padding(.top, 10)
            
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                BannerAdContentView()
            }
            
            WTToastView()
                .zIndex(9999)
        }
        .navigationTitle("About App")
    }
    
    private var aboutAppSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 30) {
                    aboutRow(
                        title: "About WT Scan Pro",
                        description: "WT Scan Pro is an independent utility app that provides general messaging tools, text utilities, and QR features.\nIt does not integrate with or access any third-party messaging platforms."
                    )
                        
                    aboutRow(
                        title: "Privacy",
                        description: "All features run locally on your device.\nWe do not read, collect, or store your messages, contacts, or personal data."
                    )
                    
                    aboutRow(
                        title: "Legal",
                        description: "WT Scan Pro is not affiliated with, sponsored by, or endorsed by WhatsApp, Meta, or any other messaging service."
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    private func aboutRow(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            WTText(title: title, color: .white, font: .system(size: 18, weight: .bold, design: .default), alignment: .leading)
            
            WTText(title: description, color: .white, font: .system(size: 14, weight: .regular, design: .default), alignment: .leading)
        }
    }
}

#Preview {
    AboutAppView()
}
