//
//  SettingsView.swift
//  WTScan
//
//  Created by iMac on 25/11/25.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack {
                Color.lightGreenBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    settingSection
                }
            }
            .padding(.top, 10)
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $viewModel.showSafariView.sheet) {
            if let url = viewModel.showSafariView.url {
                WTSafariView(url: url)
            }
        }
    }
    
    private var faceIdSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                Image(.icFaceId)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient.optionBg)
                            .frame(width: 40, height: 40)
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    WTText(title: "Enable Face ID", color: .black, font: .system(size: 16, weight: .bold, design: .default), alignment: .leading)
                    
                    WTText(title: "Secure app opening by enableing Face ID", color: .black, font: .system(size: 14, weight: .regular, design: .default), alignment: .leading)
                }
                
                Spacer(minLength: 0)
                
                Toggle(isOn: Binding(
                    get: { viewModel.isFaceIdOn },
                    set: { newValue in
                        guard AppState.shared.isSplashViewOpen == false else {
                            return
                        }
                        
                        viewModel.isFaceIdOn = newValue
                        
                        if newValue == true {
                            AppState.shared.isSplashViewOpen = true
                            viewModel.isFaceIdOn = false
                            
                            WTBiometricManager.shared.authenticate { isFaceIdOn, error in
                                if WTBiometricManager.shared.isFaceIDAvailable {
                                    viewModel.isFaceIdOn = isFaceIdOn
                                } else {
                                    viewModel.isFaceIdOn = false
                                }
                                
                                if let error = error {
                                    WTAlertManager.shared.showAlert(title: error)
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    AppState.shared.isSplashViewOpen = false
                                }
                            }
                        }
                    }
                )) {  Text("") }
                    .labelsHidden()
                    .ifiOS26Unavailable { view in
                        view.shadow(radius: 1.0)
                    }
                    .tint(Color.btnDarkGreen)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .background(Color.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.07), radius: 2, x: 0, y: 0)
        .padding(.horizontal, 20)
        .padding(.top, 23)
    }
    
    private var settingSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    faceIdSection
                    
                    VStack(alignment: .leading, spacing: 0) {
                        let arrSettings = viewModel.arrSettings
                        ForEach(0..<arrSettings.count, id: \.self) { index in
                            let setting = arrSettings[index]
                            settingRow(
                                setting: setting,
                                showSeparator: arrSettings.count != index+1,
                                onTap: {
                                    viewModel.btnSettingRowAction(settingRow: setting)
                                }
                            )
                        }
                    }
                    .background(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.07), radius: 2, x: 0, y: 0)
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    
                    WTText(title: Utility.getAppVersion(), color: .black, font: .system(size: 14, weight: .regular, design: .default), alignment: .center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 12)

                }
            }
        }
    }
    
    @ViewBuilder
    private func settingRow(setting: SettingRow, showSeparator: Bool, onTap: @escaping (() -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 16) {
                    Image(setting.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient.optionBg)
                                .frame(width: 40, height: 40)
                        }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        WTText(title: setting.title, color: .black, font: .system(size: 16, weight: .bold, design: .default), alignment: .leading)
                        if !setting.subTitle.isEmpty {
                            WTText(title: setting.subTitle, color: .black, font: .system(size: 14, weight: .regular, design: .default), alignment: .leading)
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
                    .fill(Color(hex: "E8E8E8"))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
            }
        }
        .background(.white)
        .onTapGesture {
            onTap()
        }
    }
}
