//
//  WPGroupNameHomeView.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import SwiftUI

struct WPGroupNameHomeView: View {
    @StateObject var viewModel = WPGroupNameHomeViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                Color.lightGreenBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    groupCategorySection
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
        .navigationTitle("Group Name Generator")
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    @ViewBuilder
    private var groupCategorySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Button {
                            viewModel.btnGenerateRandomNameAction()
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center, spacing: 15) {
                                    Image(systemName: "shuffle")
                                        .resizable()
                                        .scaledToFit()
                                        .bold()
                                        .foregroundStyle(Color.btnDarkGreen)
                                        .frame(width: 23, height: 23)
                                    
                                    WTText(title: "Generate Random Name", color: .white, font: .system(size: 18, weight: .medium, design: .default), alignment: .leading)
                                }
                                .padding(.horizontal, 20)
                            }
                            .frame(height: 55)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.btnDarkGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 17))
                        }
                        
                        if let randomGroupName = viewModel.randomGroupName {
                            ZStack(alignment: .topTrailing) {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(alignment: .center, spacing: 23) {
                                        WTText(title: randomGroupName, color: .black, font: .system(size: 18, weight: .medium, design: .default), alignment: .leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Image(systemName: "document.on.document.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(Color.btnDarkGreen)
                                            .frame(width: 22, height: 28)
                                            .onTapGesture {
                                                viewModel.btnCopyAction(groupName: randomGroupName)
                                            }
                                        
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(Color.btnDarkGreen)
                                            .frame(width: 18, height: 18)
                                            .onTapGesture {
                                                viewModel.btnRemoveRandomNameAction()
                                            }
                                    }
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 20)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 17))
                                .background {
                                    RoundedRectangle(cornerRadius: 17)
                                        .fill(Color.lightGreenTextfield)
                                        .stroke(Color.lightBorderGrey, lineWidth: 1)
                                        .padding(1)
                                        .frame(maxHeight: .infinity)
                                }
                            }
                            .padding(.top, 15)
                        }
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            let arrWPGroupCategories = viewModel.arrWPGroupCategories
                            
                            ForEach(0..<arrWPGroupCategories.count, id: \.self) { index in
                                let category = arrWPGroupCategories[index]
                                
                                groupCategoryCell(
                                    category: category,
                                    onTap: {
                                        viewModel.btnCategoryAction(category: category)
                                    }
                                )
                            }
                        }
                        .padding(.top, 20)
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
    
    private func groupCategoryCell(category: WPGroupCategory, onTap: @escaping (() -> Void)) -> some View {
        VStack(alignment: .leading, spacing:  0) {
            HStack(alignment: .center, spacing: 8) {
                WTText(
                    title: category.emoji,
                    color: .black,
                    font: .system(size: 20, weight: .regular, design: .default),
                    alignment: .leading
                )
                
                WTText(
                    title: category.name,
                    color: .black,
                    font: .system(size: 20, weight: .regular, design: .default),
                    alignment: .leading,
                    minimumScale: 0.8,
                    lineLimit: 1
                )
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 18)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 17))
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
