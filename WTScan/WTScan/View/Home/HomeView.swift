//
//  HomeView.swift
//  WTScan
//
//  Created by iMac on 11/11/25.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var alertManager: WTAlertManager
    @StateObject var appState = AppState.shared
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
                
            VStack(alignment: .leading, spacing: 0) {
                homeOptionSection
            }
            .background(Color.greenBg.opacity(0.1))
            .clipShape(Rectangle())
            .onTapGesture {
                Utility.hideKeyboard()
            }
            
            WTToastView()
                .zIndex(9999)
                .padding(.bottom, 50)
        }
        .id(appState.isLive)
        .ignoresSafeArea(edges: [.top, .bottom])
        .ignoresSafeArea(.keyboard)
        .toolbar(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    viewModel.btnSettingAction()
                } label: {
                    WTNavHomeButton(
                        imageName: "gearshape.fill",
                        fontWeight: .bold,
                        iconColor: .navIcon,
                        iconSize: CGSize(width: 18, height: 18),
                        backgroundColor: Color.white
                    )
                }
                
                Button {
                    viewModel.btnShareAction()
                } label: {
                    WTNavHomeButton(
                        imageName: "square.and.arrow.up",
                        fontWeight: .bold,
                        iconColor: .navIcon,
                        iconSize: CGSize(width: 14, height: 20),
                        backgroundColor: Color.white
                    )
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .sheet(isPresented: $viewModel.showShareSheetView.sheet) {
            if let url = viewModel.showShareSheetView.url {
                WTShareSheetView(
                    items: [url]
                )
                .presentationDetents([.medium, .large])
            }
        }
    }
    
    private var homeOptionSection: some View {
        ZStack {
            LinearGradient.wtGreen.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .center, spacing: 17) {
                    Image(.icAppIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                    
                    WTText(title: "Smart Tools to Enhance Your Messaging Experience", color: .white, font: .system(size: 15, weight: .bold, design: .default), alignment: .center)
                }
                .padding(.horizontal, 30)
                .padding(.top, 80)
                .padding(.bottom, 25)
                
                ZStack {
                    LinearGradient.optionBg.ignoresSafeArea()
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        ScrollView(.vertical) {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(viewModel.arrSections, id: \.id) { section in
                                    sectionRow(section: section)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            VStack{}.frame(height: 40)
                        }
                    }
                }
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
            }
        }
    }
    
    @ViewBuilder
    private func sectionRow(section: WTOptionSection) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            WTText(title: section.title, color: .white, font: .system(size: 20, weight: .bold, design: .default), alignment: .leading)
                .padding(.top, 20)
                .padding(.bottom, 15)
            
            VStack(alignment: .leading, spacing: 0) {
                let arrOptions = section.rows
                ForEach(0..<arrOptions.count, id: \.self) { index in
                    let option = arrOptions[index]
                    optionRow(
                        option: option,
                        showSeparator: arrOptions.count != index+1,
                        onTap: {
                            viewModel.btnOptionAction(optionModel: option)
                        }
                    )
                }
            }
            .background(AppColor.Gray.opacity(0.12))
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.07), radius: 2, x: 0, y: 0)
        }
    }
    
    @ViewBuilder
    private func optionRow(option: WTOptionModel, showSeparator: Bool, onTap: @escaping (() -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 16) {
                    Image(option.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColor.Pink)
                                .frame(width: 40, height: 40)
                        }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        WTText(title: option.title, color: .white, font: .system(size: 16, weight: .bold, design: .default), alignment: .leading)
                        if !option.subTitle.isEmpty {
                            WTText(title: option.subTitle, color: .white, font: .system(size: 14, weight: .regular, design: .default), alignment: .leading)
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color(hex: "D8D8D8"))
                        .frame(width: 10, height: 17)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            
            if showSeparator {
                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
            }
        }
        //.background(.white)
        .onTapGesture {
            onTap()
        }
    }
}
