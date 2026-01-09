//
//  EmojiTextView.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import SwiftUI
import Combine

struct EmojiTextView: View {
    
    @StateObject var viewModel = EmojiTextViewModel()
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack {
                Color.lightGreenBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    textToEmojiSection
                }
                .background(Color.lightGreenBg.opacity(0.1))
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
        .navigationTitle("Text to Emoji")
        .sheet(isPresented: $viewModel.showShareSheetView) {
            WTShareSheetView(
                items: [viewModel.resultText]
            )
            .presentationDetents([.medium, .large])
        }
    }
    
    private var textToEmojiSection: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 5) {
                        WTText(title: "Enter text", color: .black, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        WTTextField(placeHolder: "Enter text", text: $viewModel.enteredText)
                            .frame(height: 51)
                    }
                    .padding(.bottom, 10)
                    
                    HStack(alignment: .center, spacing: 17) {
                        VStack(alignment: .leading, spacing: 5) {
                            WTText(title: "Enter Emoji", color: .black, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                                .padding(.leading, 8)
                            
                            WTTextField(placeHolder: "", text: $viewModel.emojiText, keyboardType: .default)
                                .frame(height: 51)
                                .onChange(of: viewModel.emojiText) { oldValue, newValue in
                                    // Allow only emoji characters
                                    let filtered = newValue.filter { $0.isEmoji }
                                    
                                    // Keep only the last emoji entered (if multiple)
                                    if let lastEmoji = filtered.last {
                                        viewModel.emojiText = String(lastEmoji)
                                    } else {
                                        viewModel.emojiText = ""
                                    }
                                }
                        }
                        .frame(width: 161)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.bottom, 20)
                    
                    WTButton(
                        title: "Convert",
                        onTap: {
                            viewModel.btnConvertAction()
                        }
                    )
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack(alignment: .top, spacing: 0) {
                            Spacer(minLength: 0)
                            
                            HStack(alignment: .top, spacing: 5) {
                                VStack {
                                    Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .scaledToFit()
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.black)
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
                                        .foregroundStyle(.black)
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
                                    .fill(Color.greenBg)
                                    .stroke(.black, lineWidth: 1)
                                    .padding(1)
                                    .frame(maxHeight: .infinity)
                            }
                            .padding(10)
                        }
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(viewModel.resultText)
                                    .textSelection(.enabled)
                                    .font(.system(size: 18, weight: .semibold, design: .default))
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.leading)
                                    .padding(15)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .scrollIndicators(.hidden)
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.355)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                    .background {
                        RoundedRectangle(cornerRadius: 17)
                            .fill(Color.lightGreenTextfield)
                            .stroke(Color.lightBorderGrey, lineWidth: 1)
                            .padding(1)
                            .frame(maxHeight: .infinity)
                    }
                }
                .padding(16)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 11))
            .padding(16)
        }
        .scrollIndicators(.hidden)
        .padding(.bottom, paddingFromBannerAd())
    }
}
