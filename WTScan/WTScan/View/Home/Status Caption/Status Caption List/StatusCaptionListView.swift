//
//  StatusCaptionListView.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import SwiftUI

struct StatusCaptionListView: View {
    
    @StateObject private var viewModel: StatusCaptionListViewModel
    @EnvironmentObject var alertManager: WTAlertManager
    
    init(captionCategory: WTCaptionCategory) {
        _viewModel = StateObject(wrappedValue: StatusCaptionListViewModel(captionCategory: captionCategory))
    }
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                LinearGradient.optionBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    statusCaptionListSection
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
        .navigationTitle(viewModel.captionCategory.name)
    }
    
    private var statusCaptionListSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        let arrCaptions = viewModel.captionCategory.quotes
                        
                        ForEach(0..<arrCaptions.count, id: \.self) { index in
                            let caption = arrCaptions[index]
                            captionRow(
                                caption: caption,
                                onTap: {
                                    viewModel.btnCopyAction(caption: caption)
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
    
    @ViewBuilder func captionRow(caption: WTCaptionItem, onTap: @escaping (() -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 23) {
                WTText(title: caption.text, color: .white, font: .system(size: 18, weight: .regular, design: .default), alignment: .leading)
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
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                .padding(1)
                .frame(maxHeight: .infinity)
        }
        .onTapGesture {
            onTap()
        }
    }
}
