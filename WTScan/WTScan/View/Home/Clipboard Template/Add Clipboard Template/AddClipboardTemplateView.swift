//
//  AddClipboardTemplateView.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import SwiftUI

struct AddClipboardTemplateView: View {
    @ObservedObject var viewModel: AddClipboardTemplateViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                WTSwipeToBackGesture()
                LinearGradient.wtGreen.ignoresSafeArea()
                
                ZStack(alignment: .top) {
                    Color.lightGreenBg.ignoresSafeArea()
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        addClipboardTextSection
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add Template")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.btnBackAction()
                    } label: {
                        WTNavButton(
                            imageName: "xmark",
                            fontWeight: .bold,
                            iconColor: .white,
                            iconSize: CGSize(width: 12, height: 19),
                            backgroundColor: .black.opacity(0.2),
                        )
                    }
                }
            }
        }
    }
    
    private var addClipboardTextSection: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            WTText(title: "Clipboard text", color: .black, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                                .padding(.leading, 8)
                            
                            Spacer(minLength: 0)
                            
                            WTText(title: "Paste", color: .black, font: .system(size: 16, weight: .bold, design: .default), alignment: .trailing)
                                .padding(.trailing, 8)
                                .onTapGesture {
                                    viewModel.btnPasteAction()
                                }
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 10)
                        
                        WTTextView(placeHolder: "Clipboard text", text:  $viewModel.cliboardText)
                            .padding(.bottom, 22)
                            .frame(height: 128)
                        
                        WTButton(
                            title: "Save Template",
                            onTap: {
                                viewModel.btnSaveTemplate()
                            }
                        )
                        .padding(.top, 15)
                    }
                }
                .padding(16)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 11))
            .padding(16)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }
}
