//
//  QRScannerView.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import SwiftUI

struct QRScannerView: View {
    
    @StateObject var viewModel = QRScannerViewModel()
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack {
                Color.lightGreenBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    cameraPreviewSection
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
        .navigationTitle("QR Code Scanner")
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
    
    private var cameraPreviewSection: some View {
        ZStack {
            WTCameraPreview(layer: viewModel.scanner.previewLayer)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            VStack(alignment: .center, spacing: 0) {
                Image(.icQrFrame)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.greenBg)
                    .padding(.horizontal, 40)
                    .padding(.bottom, paddingFromBannerAd())
            }
        }
    }
}
