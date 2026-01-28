//
//  QRScanResultView.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import SwiftUI

struct QRScanResultView: View {
    
    @StateObject private var viewModel: QRScanResultViewModel
    @EnvironmentObject var alertManager: WTAlertManager
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    init(qrText: String) {
        _viewModel = StateObject(wrappedValue: QRScanResultViewModel(qrText: qrText))
    }
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                Color.lightGreenBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    qrScanResultSection
                }
                .background(Color.lightGreenBg.opacity(0.1))
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
        .navigationTitle("QR Scan Result")
        .sheet(isPresented: $viewModel.showShareSheetView) {
            WTShareSheetView(
                items: [viewModel.qrText]
            )
            .presentationDetents([.medium, .large])
        }
    }
    
    private var qrScanResultSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(viewModel.qrText)
                            .textSelection(.enabled)
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.leading)
                            .padding(15)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .scrollIndicators(.hidden)
                .frame(height: 200)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 17))
                .background {
                    RoundedRectangle(cornerRadius: 17)
                        .fill(Color.lightGreenTextfield)
                        .stroke(Color.lightBorderGrey, lineWidth: 1)
                        .padding(1)
                        .frame(maxHeight: .infinity)
                }
                
                WTButton(
                    title: "Share",
                    onTap: {
                        viewModel.openShareSheetView()
                    }
                )
            }
            
            .padding(16)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding(16)
        .padding(.bottom, 100)
    }
}
