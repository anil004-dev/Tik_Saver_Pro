//
//  WPGroupNameListView.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import SwiftUI

struct WPGroupNameListView: View {
    
    @StateObject private var viewModel: WPGroupNameListViewModel
    @EnvironmentObject var alertManager: WTAlertManager
    
    init(groupCategory: WPGroupCategory) {
        _viewModel = StateObject(wrappedValue: WPGroupNameListViewModel(groupCategory: groupCategory))
    }
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                Color.lightGreenBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    statusCaptionListSection
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
        .navigationTitle(viewModel.groupCategory.name)
    }
    
    private var statusCaptionListSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        let arrGroupNames = viewModel.groupCategory.names
                        
                        ForEach(0..<arrGroupNames.count, id: \.self) { index in
                            let groupName = arrGroupNames[index]
                            
                            groupNameRow(
                                groupName: groupName,
                                onTap: {
                                    viewModel.btnCopyAction(groupName: groupName)
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
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .padding(.bottom, paddingFromBannerAd())
    }
    
    @ViewBuilder func groupNameRow(groupName: String, onTap: @escaping (() -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 23) {
                WTText(title: groupName, color: .black, font: .system(size: 18, weight: .regular, design: .default), alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "document.on.document.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.btnDarkGreen)
                    .frame(width: 22, height: 28)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
