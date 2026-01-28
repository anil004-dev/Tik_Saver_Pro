//
//  FontStylingView.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import SwiftUI

struct FontStylingView: View {
    
    @StateObject var viewModel = FontStylingViewModel()
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                LinearGradient.optionBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    fontStylingSection
                }
                //.background(Color.lightGreenBg)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                .onTapGesture {
                    Utility.hideKeyboard()
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .padding(.top, 10)
            if !entitlementManager.hasPro {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    BannerAdContentView()
                }
            }
            WTToastView()
                .zIndex(9999)
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Font Styling")
        .onAppear {
            viewModel.onAppear()
        }
        .sheet(isPresented: $viewModel.showShareSheetView.sheet) {
            if let text = viewModel.showShareSheetView.text {
                WTShareSheetView(items: [text])
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    private var fontStylingSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading, spacing: 5) {
                WTText(title: "Enter text", color: .white, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
                
                WTTextField(placeHolder: "Enter text", text: $viewModel.enteredText)
                    .frame(height: 51)
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
            
            previewSection
        }
    }
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    WTText(title: "Previews", color: .white, font: .system(size: 18, weight: .semibold, design: .default), alignment: .leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 8)
                    
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 10) {
                            let arrFontStyles = viewModel.arrFontStyles
                            ForEach(0..<arrFontStyles.count, id: \.self) { index in
                                let style = arrFontStyles[index]
                                
                                fontStylePreviewRow(
                                    style: style,
                                    onShareAction: { text in
                                        viewModel.btnShareAction(text: text)
                                    },
                                    onCopyAction: { text in
                                        viewModel.btnCopyAction(text: text)
                                    }
                                )
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .padding(16)
        }
        .background(AppColor.Gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .padding(.bottom, paddingFromBannerAd())
    }
    
    @ViewBuilder
    private func fontStylePreviewRow(style: String, onShareAction: @escaping ((String) -> Void), onCopyAction: @escaping ((String) -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                let stylishFontText = viewModel.getFontStyleText(fontStyle: style)
                
                WTText(title: stylishFontText, color: .white, font: .system(size: 18, weight: .regular, design: .default), alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 16)
                
                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .center, spacing: 0) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.white)
                            .frame(width: 15, height: 19)
                    }
                    .frame(width: 36, height: 36, alignment: .center)
                    .background {
                        Circle()
                            .fill(AppColor.Pink)
                            .padding(1)
                            .frame(maxHeight: .infinity)
                    }
                    .onTapGesture {
                        onShareAction(stylishFontText)
                    }
                    
                    VStack(alignment: .center, spacing: 0) {
                        Image(systemName: "document.on.document")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.white)
                            .frame(width: 16, height: 19)
                    }
                    .frame(width: 36, height: 36, alignment: .center)
                    .background {
                        Circle()
                            .fill(AppColor.Pink)
                            .padding(1)
                            .frame(maxHeight: .infinity)
                    }
                    .onTapGesture {
                        onCopyAction(stylishFontText)
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 17)
                .fill(AppColor.Gray.opacity(0.12))
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                .padding(1)
                .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    FontStylingView()
}
