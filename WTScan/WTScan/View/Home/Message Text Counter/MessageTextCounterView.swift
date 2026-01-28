//
//  MessageTextCounterView.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import SwiftUI

struct MessageTextCounterView: View {
    
    @StateObject var viewModel = MessageTextCounterViewModel()
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                LinearGradient.optionBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    messageTextCounterSection
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
        .navigationTitle("Message Text Counter")
    }
    
    private var messageTextCounterSection: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        WTTextView(placeHolder: "Hey!, I'm typing message...", text: $viewModel.messageText, keyboardType: .default)
                            .frame(height: 200)
                        
                        HStack(alignment: .center, spacing: 0) {
                            WTText(title: "Charecters:", color: .white, font: .system(size: 18, weight: .medium, design: .default), alignment: .leading)
                            
                            Spacer()
                            
                            WTText(title: "\(viewModel.messageText.count)", color: .white, font: .system(size: 18, weight: .semibold, design: .default), alignment: .trailing)
                        }
                        .padding(.vertical, 20)
                        
                        HStack(alignment: .center, spacing: 16) {
                            HStack(alignment: .center, spacing: 0) {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: "document.on.document.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    WTText(title: "Copy", color: .white, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                                }
                                .padding(.horizontal, 20)
                            }
                            .frame(height: 48)
                            .frame(maxWidth: .infinity)
                            .background(AppColor.Pink)
                            .clipShape(RoundedRectangle(cornerRadius: 17))
                            .padding(.top, 10)
                            .onTapGesture {
                                viewModel.btnCopyAction()
                            }
                            
                            HStack(alignment: .center, spacing: 0) {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.white)
                                        .frame(width: 18, height: 18)
                                    
                                    WTText(title: "Clear", color: .white, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                                }
                                .padding(.horizontal, 20)
                            }
                            .frame(height: 48)
                            .frame(maxWidth: .infinity)
                            .background(AppColor.Pink)
                            .clipShape(RoundedRectangle(cornerRadius: 17))
                            .padding(.top, 10)
                            .onTapGesture {
                                viewModel.btnClearAction()
                            }
                        }
                        .frame(height: 45)
                        .padding(.bottom, 10)
                    }
                }
                .padding(16)
            }
            .background(AppColor.Gray.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 11))
            .padding(16)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MessageTextCounterView()
}
