//
//  SplashView.swift
//  WTScan
//
//  Created by iMac on 26/11/25.
//

import SwiftUI
import Combine
import AppTrackingTransparency

struct SplashView: View {
    
    @AppStorage(UserDefaultKeys.isAdsConsentGathered, store: UserDefaultManager.userDefault) var isAdsConsentGathered: Bool = false
    @StateObject var viewModel: SplashViewModel
    
    var body: some View {
        ZStack {
            LinearGradient.optionBg.ignoresSafeArea()
            
            if viewModel.showNoInternetView {
                noInternetSection
            } else {
                authenticationSection
            }
        }
        .ignoresSafeArea()
        .onAppear {
            if viewModel.showAllowATTPopup == false {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    viewModel.showATTPopup()
                }
            }
        }
    }
    
    var authenticationSection: some View {
        ZStack(alignment: .center) {
            appIconAndFaceIdSection
            
            if isAdsConsentGathered == false {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColor.Pink))
                        .scaleEffect(1.5)
                        .padding(.bottom, 40)
                }
            }
            
            if viewModel.showAllowATTPopup {
                allowATTPopup
            }
        }
    }
    
    @ViewBuilder
    private var appIconAndFaceIdSection: some View {
        VStack(alignment: .center, spacing: 0) {
            if !viewModel.showAllowATTPopup {
                VStack(alignment: .center, spacing: 0) {
                    Image(.icAppIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 106, height: 106)
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea()
        
        if WTBiometricManager.shared.isBiometricEnabled() && viewModel.showFaceIDButton {
            VStack(alignment: .center, spacing: 0) {
                Button {
                    viewModel.performAuthentication()
                } label: {
                    Image(systemName: "faceid")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(AppColor.Pink)
                        .frame(width: 30, height: 30)
                }
                .padding(.top, 180)
            }
        }
    }
    
    private var allowATTPopup: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.2)
            
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .center, spacing: 30) {
                    WTText(title: "Help Keep \(Utility.getAppName()) Free", color: .white, font: .system(size: 21, weight: .medium, design: .default), alignment: .center)
                    
                    WTText(title: "We use ads to keep the app free. Your choice will help us show more relevant ads or generic ads. You can change your decision anytime in Settings.", color: .white, font: .system(size: 17, weight: .regular, design: .default), alignment: .center)
                    
                    Button {
                        viewModel.showATTPopup()
                    } label: {
                        HStack(alignment: .center, spacing: 0) {
                            WTText(title: "Continue", color: .white, font: .system(size: 17, weight: .medium, design: .default), alignment: .center)
                        }
                        .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45, alignment: .center)
                        .background(AppColor.Pink)
                        .clipShape(Capsule())
                    }
                }
                .padding(.vertical, 35)
                .padding(.horizontal, 35)
            }
            .frame(maxWidth: .infinity)
            .background(AppColor.Gray.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)

        }
        .ignoresSafeArea()
    }
    
    private var noInternetSection: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 40))
                .foregroundColor(.white)
            
            Text("No Internet Connection")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Please connect to the internet to continue using the app.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 250)
                .padding(.horizontal, 32)
            
            WTButton(
                title: "Retry",
                onTap: {
                    viewModel.checkForInternet(attStatus: .authorized)
                }
            )
            .padding(.horizontal, 40)
            .padding(.top, 20)
            
            Spacer()
        }
    }
}
