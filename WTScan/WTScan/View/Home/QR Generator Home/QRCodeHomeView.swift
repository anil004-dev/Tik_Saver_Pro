//
//  QRCodeHomeView.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import SwiftUI

struct QRCodeHomeView: View {
    
    @StateObject var viewModel = QRCodeHomeViewModel()
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
                    qrCodeListSection
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
        .navigationTitle("QR Code Generator")
    }
    
    private var qrCodeListSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        let arrQROptions = viewModel.arrQROptions
                        
                        ForEach(0..<arrQROptions.count, id: \.self) { index in
                            let optionModel = arrQROptions[index]
                            
                            qrOptionCell(
                                optionModel: optionModel,
                                onTap: {
                                    viewModel.btnQROptionAction(optionModel: optionModel)
                                }
                            )
                        }
                    }
                }.padding(16)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 11))
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .padding(.bottom, paddingFromBannerAd())
        }
    }
    
    private func qrOptionCell(optionModel: WTQROptionModel, onTap: @escaping (() -> Void)) -> some View {
        VStack(spacing: 10) {
            VStack(alignment: .center, spacing: 5) {
                Image(systemName: optionModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.btnDarkGreen)
                    .frame(width: optionModel.imageSize.width, height: optionModel.imageSize.height)
                
                WTText(
                    title: optionModel.title,
                    color: .black,
                    font: .system(size: 18, weight: .regular, design: .default),
                    alignment: .center
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(height: 75)
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
