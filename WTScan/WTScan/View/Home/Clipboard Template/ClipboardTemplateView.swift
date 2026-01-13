//
//  ClipboardTemplateView.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import SwiftUI

struct ClipboardTemplateView: View {
    
    @StateObject var viewModel = ClipboardTemplateViewModel()
    @Environment(\.modelContext) var context
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack {
                LinearGradient.optionBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    clipboardTemplateSection
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
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Clipboard Template")
        .onAppear {
            ClipboardManager.shared.context = context
            viewModel.onAppear()
        }
        .sheet(isPresented: $viewModel.showAddTemplateView.sheet) {
            if let viewModel = viewModel.showAddTemplateView.viewModel {
                AddClipboardTemplateView(viewModel: viewModel)
                    .presentationDetents([.large])
            }
        }
    }
    
    private var clipboardTemplateSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                viewModel.btnAddTemplateAction()
            } label: {
                HStack(alignment: .center, spacing: 20) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                    
                    WTText(title: "Add New Template", color: .white, font: .system(size: 18, weight: .semibold, design: .default), alignment: .center)
                }
                .frame(maxWidth: .infinity, minHeight: 51, maxHeight: 51, alignment: .center)
                .background(AppColor.Pink)
                .clipShape(RoundedRectangle(cornerRadius: 17))
            }
            .padding(.horizontal, 16)
            .padding(.top, 25)
            .padding(.bottom, 5)
            
            savedTemplateSection
        }
    }
    
    private var savedTemplateSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        WTText(title: "Saved Template", color: .white, font: .system(size: 18, weight: .semibold, design: .default), alignment: .leading)
                            .padding(.bottom, 14)
                            .padding(.horizontal, 4)
                        
                        let arrClipboards = viewModel.arrClipboards
                        
                        ForEach(0..<arrClipboards.count, id: \.self) { index in
                            let clipboard = arrClipboards[index]
                            clipboardRow(
                                clipboard: clipboard,
                                onTap: {
                                    viewModel.btnCopyToClipboardAction(clipboard: clipboard)
                                }
                            )
                            .padding(.bottom, 10)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(16)
        }
        .background(AppColor.Gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .padding(.bottom, paddingFromBannerAd())
    }
    
    @ViewBuilder func clipboardRow(clipboard: WTClipboardModel, onTap: @escaping (() -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 23) {
                WTText(title: clipboard.clipboardText, color: .white, font: .system(size: 18, weight: .regular, design: .default), alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "document.on.document.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(AppColor.Pink)
                    .frame(width: 22, height: 28)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .clipShape(RoundedRectangle(cornerRadius: 17))
        .background {
            RoundedRectangle(cornerRadius: 17)
                .fill(AppColor.Gray.opacity(0.12))
                .padding(1)
                .frame(maxHeight: .infinity)
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    ClipboardTemplateView()
}
