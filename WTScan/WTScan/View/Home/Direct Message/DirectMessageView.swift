//
//  DirectMessageView.swift
//  WTScan
//
//  Created by iMac on 12/11/25.
//

import SwiftUI

struct DirectMessageView: View {
    
    @StateObject var viewModel = DirectMessageViewModel()
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                Color.lightGreenBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    directMessageSection
                }
                .background(Color.lightGreenBg)
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
        .navigationTitle("Direct Message")
        .sheet(isPresented: $viewModel.showCountryPickerView) {
            CountryPickerView(selectedCountry: $viewModel.selectedCountry)
        }
    }
    
    private var directMessageSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 11) {
                WTText(title: "We don’t store any mobile number", color: .black, font: .system(size: 17, weight: .regular, design: .default), alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 11) {
                            HStack(alignment: .center, spacing: 15) {
                                Image(uiImage: viewModel.selectedCountry?.flag ?? .init())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 36, height: 24)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .padding(.leading, 12)
                                
                                WTText(title: viewModel.selectedCountry?.dialingCode ?? "+91", color: .black, font: .system(size: 18, weight: .semibold, design: .default), alignment: .trailing)
                                    .padding(.trailing, 12)
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 17)
                                    .fill(Color.lightGreenTextfield)
                                    .stroke(Color.lightBorderGrey, lineWidth: 1)
                                    .padding(1)
                                    .frame(height: 51)
                            }
                            .frame(height: 51)
                            .onTapGesture {
                                viewModel.btnCountryPickerAction()
                            }
                            
                            
                            WTTextField(placeHolder: "Enter phone number", text: $viewModel.phoneNumber, keyboardType: .numberPad)
                                .frame(height: 51)
                        }
                        .padding(.bottom, 15)
                        
                        WTTextView(placeHolder: "Enter your message", text: $viewModel.message)
                            .frame(height: 174)
                            .padding(.bottom, 15)
                        
                        Menu {
                            ForEach(DirectMessageTextCase.allCases) { textCase in
                                Button {
                                    viewModel.btnTextCaseAction(selectedCase: textCase)
                                } label: {
                                    Text(textCase.rawValue)
                                }
                            }
                        } label: {
                            HStack(alignment: .center, spacing: 0) {
                                HStack(alignment: .center, spacing: 8) {
                                    WTText(title: viewModel.selectedCase?.rawValue ?? "Options", color: .black, font: .system(size: 15, weight: .regular, design: .default), alignment: .leading)
                                    
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(Color.black)
                                        .frame(width: 9, height: 12)
                                }
                                .padding(.horizontal, 11)
                            }
                            .background {
                                Capsule()
                                    .fill(Color.greenBg)
                                    .stroke(Color.black, lineWidth: 1)
                                    .padding(1)
                                    .frame(height: 36)
                            }
                            .frame(alignment: .leading)
                            .frame(height: 36)
                        }
                        .padding(.bottom, 40)
                        
                        WTButton(
                            title: "Send",
                            onTap: {
                                viewModel.btnSendAction()
                            }
                        )
                    }
                    .padding(16)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 11))
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    DirectMessageView()
}
