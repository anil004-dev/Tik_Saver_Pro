//
//  StatusCaptionView.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import SwiftUI

struct StatusCaptionView: View {
    
    @StateObject var viewModel = StatusCaptionViewModel()
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                Color.lightGreenBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    statusCaptionSection
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
        .navigationTitle("Status Caption Ideas")
    }
    
    @ViewBuilder
    private var statusCaptionSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        let arrCaptionsCategory = viewModel.arrCaptionCategory
                        
                        ForEach(0..<arrCaptionsCategory.count, id: \.self) { index in
                            let category = arrCaptionsCategory[index]
                            
                            captionsCategoryCell(
                                category: category,
                                onTap: {
                                    viewModel.btnCaptionCategoryAction(category: category)
                                }
                            )
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(16)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .padding(.bottom, paddingFromBannerAd())
    }
    
    private func captionsCategoryCell(category: WTCaptionCategory, onTap: @escaping (() -> Void)) -> some View {
        VStack(spacing: 10) {
            Spacer(minLength: 0)
            
            VStack(alignment: .center, spacing: 20) {
                Image(systemName: category.imageName)
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.btnDarkGreen)
                    .frame(width: 35, height: 35)
                
                WTText(
                    title: category.name,
                    color: .black,
                    font: .system(size: 14, weight: .semibold, design: .default),
                    alignment: .center
                )
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 10)
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: 17)
                .fill(Color.lightGreenTextfield)
                .stroke(Color.lightBorderGrey, lineWidth: 1)
                .padding(1)
                .frame(maxHeight: .infinity)
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    StatusCaptionView()
}
