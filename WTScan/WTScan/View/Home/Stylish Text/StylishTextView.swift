//
//  StylishTextView.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import SwiftUI

struct StylishTextView: View {
    
    @StateObject var viewModel = StylishTextViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack {
                LinearGradient.optionBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    stylishTextSection
                }
                //.background(Color.lightGreenBg)
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
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Stylish Text")
        .sheet(isPresented: $viewModel.showShareSheetView) {
            WTShareSheetView(
                items: [viewModel.getTextToCopy()]
            )
            .presentationDetents([.medium, .large])
        }
    }
    
    private var stylishTextSection: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack(alignment: .top, spacing: 0) {
                Spacer(minLength: 0)
                
                HStack(alignment: .top, spacing: 5) {
                    VStack {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 17, height: 22)
                    }
                    .frame(width: 36, height: 36)
                    .padding(.leading, 10)
                    .onTapGesture {
                        viewModel.btnShareAction()
                    }
                    
                    VStack {
                        Image(systemName: "document.on.document.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 21, height: 25)
                    }
                    .frame(width: 36, height: 36)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        viewModel.btnCopyAction()
                    }
                }
                .frame(height: 40)
                .background {
                    Capsule()
                        .fill(AppColor.Gray.opacity(0.12))
                        .padding(1)
                        .frame(maxHeight: .infinity)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                WTText(title: "Enter text", color: .white, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                    .padding(.leading, 8)
                
                WTTextField(placeHolder: "Hello", text: $viewModel.enteredText)
                    .frame(height: 50)
            }
            .padding(.top, -10)
            .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            let arrStyles = viewModel.arrStyles
                            
                            ForEach(0..<arrStyles.count, id: \.self) { index in
                                let style = arrStyles[index]
                                
                                textStyleCell(
                                    style: style,
                                    onTap: {
                                        viewModel.btnSelectTexStyle(style: style)
                                    }
                                )
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .padding(16)
            }
            .background(AppColor.Gray.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 11))
        }
        .padding(.horizontal, 16)
        .padding(.top, 15)
        .padding(.bottom, paddingFromBannerAd())
    }
    
    @ViewBuilder
    private func textStyleCell(style: TextStyle, onTap: @escaping (() -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 11) {
                HStack(alignment: .center, spacing: 0) {
                    WTText(
                        title: style.name,
                        color: .white,
                        font: .system(size: 14, weight: .regular, design: .default),
                        alignment: .leading
                    )
                    
                    
                    Spacer(minLength: 0)
                }
                
                WTText(
                    title: style.transform(viewModel.enteredText.isEmpty ? "Hello" : viewModel.enteredText) ,
                    color: Color.white,
                    font: .system(size: 22, weight: .bold, design: .default),
                    alignment: .leading,
                    lineLimit: 1
                )
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColor.Gray.opacity(0.12))
                .stroke(Color.white, lineWidth: viewModel.selectedStyle?.id == style.id ? 2 : 0)
                .padding(1)
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    StylishTextView()
}
