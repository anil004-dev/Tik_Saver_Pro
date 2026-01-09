//
//  CountdownStatusGeneratorView.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import SwiftUI

struct CountdownStatusGeneratorView: View {
    
    @StateObject var viewModel = CountdownStatusGeneratorViewModel()
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                Color.lightGreenBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    countdownSection
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
        .navigationTitle("Countdown Status Generator")
    }
    
    private var countdownSection: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    WTText(title: "🗓️ Countdown Status Generator", color: .black, font: .system(size: 18, weight: .bold, design: .default), alignment: .leading)
                    
                    WTText(title: "Create a countdown based caption for\nspecial events!", color: .black, font: .system(size: 16, weight: .regular, design: .default), alignment: .leading)
                }
                .padding(.horizontal, 16)
                
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            WTText(title: "What's your occassion?", color: .black, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                                .padding(.bottom, 10)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center, spacing: 15) {
                                    TextField("Enter event title", text: $viewModel.eventTitle)
                                        .preferredColorScheme(.light)
                                        .foregroundStyle(.black)
                                        .tint(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack(alignment: .center, spacing: 10) {
                                        Text("🎉")
                                            .font(.system(size: 16, weight: .semibold, design: .default))
                                            .onTapGesture {
                                                viewModel.selectedEmoji = "🎉"
                                            }
                                        
                                        Text("✈️")
                                            .font(.system(size: 16, weight: .semibold, design: .default))
                                            .onTapGesture {
                                                viewModel.selectedEmoji = "✈️"
                                            }
                                        Text("🎁")
                                            .font(.system(size: 16, weight: .semibold, design: .default))
                                            .onTapGesture {
                                                viewModel.selectedEmoji = "🎁"
                                            }
                                    }
                                    .padding(.horizontal, 10)
                                    .frame(height: 35, alignment: .trailing)
                                    .background(Color.black.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                
                            }
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .leading)
                            .background {
                                RoundedRectangle(cornerRadius: 17)
                                    .fill(Color.lightGreenTextfield)
                                    .stroke(Color.lightBorderGrey, lineWidth: 1)
                                    .padding(1)
                                    .frame(maxHeight: .infinity)
                            }
                            .padding(.bottom, 20)
                            
                            WTText(title: "Select date of the event", color: .black, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                            
                            HStack {
                                DatePicker(
                                    "",
                                    selection: $viewModel.selectedEventDate,
                                    in: Date.now...,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                
                                Spacer()
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 20)
                            
                            if !viewModel.eventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                VStack(alignment: .leading, spacing: 0) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        (
                                            Text("\(viewModel.selectedEmoji.isEmpty ? "" : "\(viewModel.selectedEmoji) ")")
                                            +
                                            Text("\(viewModel.getDaysLeft()) ").foregroundStyle(.blue)
                                            +
                                            Text("days left untill my \(viewModel.eventTitle)")
                                        )
                                        .multilineTextAlignment(.leading)
                                        .font(.system(size: 22, weight: .bold, design: .default))
                                        .foregroundStyle(Color(hex: "282A2F"))
                                    }
                                    .padding(20)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(hex: "FFF9E0"))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.bottom, 20)
                                
                                WTButton(
                                    title: "Copy Caption",
                                    onTap: {
                                        viewModel.btnCopyAction()
                                    }
                                )
                            }
                        }
                    }
                    .padding(16)
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(16)
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 20)
        }
        .scrollIndicators(.hidden)
        .padding(.bottom, paddingFromBannerAd())
    }
}
#Preview {
    CountdownStatusGeneratorView()
}
