//
//  TextCaseConverterView.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import SwiftUI

struct TextCaseConverterView: View {
    
    @StateObject var viewModel = TextCaseConverterViewModel()
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                LinearGradient.optionBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    textCaseConverterSection
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
        .navigationTitle("Text Case Converter")
        .sheet(isPresented: $viewModel.showShareSheetView) {
            WTShareSheetView(
                items: [viewModel.enteredText]
            )
            .presentationDetents([.medium, .large])
        }
    }
    
    private var textCaseConverterSection: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
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
                                    .fill(AppColor.Pink)
                                    .padding(1)
                                    .frame(maxHeight: .infinity)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            WTText(title: "Enter text", color: .white, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            WTTextView(placeHolder: "Hello", text: $viewModel.enteredText, keyboardType: .default)
                                .frame(height: 120)
                        }
                        .padding(.top, -10)
                        .onChange(of: viewModel.enteredText) { _, _ in
                            viewModel.selectedCase = nil
                        }
                        
                        Rectangle()
                            .fill(Color.lightBorderGrey)
                            .frame(height: 1)
                            .padding(.top, 20)
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            let arrCases = ConverterTextCase.allCases
                            
                            ForEach(0..<arrCases.count, id: \.self) { index in
                                let textCase = arrCases[index]
                                
                                convertTextCaseCell(
                                    textCase: textCase,
                                    onTap: {
                                        viewModel.btnConvertTextCaseAction(textCase: textCase)
                                    }
                                )
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(16)
            }
            .background(AppColor.Gray.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 11))
            .padding(16)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func convertTextCaseCell(textCase: ConverterTextCase, onTap: @escaping (() -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 11) {
                HStack(alignment: .center, spacing: 0) {
                    WTText(
                        title: textCase.rawValue,
                        color: .white,
                        font: .system(size: 16, weight: .regular, design: .default),
                        alignment: .leading
                    )
                    
                    Spacer(minLength: 0)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 17)
                .fill(AppColor.Gray.opacity(0.12))
                .stroke(viewModel.selectedCase == textCase ? AppColor.Pink : Color.white, lineWidth: 1)
                .padding(1)
                .frame(maxHeight: .infinity)
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    TextCaseConverterView()
}
