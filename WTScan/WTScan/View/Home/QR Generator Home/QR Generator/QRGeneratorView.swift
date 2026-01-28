//
//  QRGeneratorView.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import SwiftUI


struct QRGeneratorView: View {
    
    @StateObject private var viewModel: QRGeneratorViewModel
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    init(qrOption: WTQROption) {
        _viewModel = StateObject(wrappedValue: QRGeneratorViewModel(qrOption: qrOption))
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                LinearGradient.optionBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    qrGenerationSection
                }
                //.background(Color.lightGreenBg.opacity(0.1))
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
        .navigationTitle(viewModel.qrOption.rawValue)
        .sheet(isPresented: $viewModel.showShareSheetView.sheet) {
            if let qr = viewModel.showShareSheetView.qrImage {
                WTShareSheetView(items: [qr])
                    .presentationDetents([.medium, .large])
            } else {
                Text("QR code not available")
                    .presentationDetents([.medium])
            }
        }
    }
    
    private var qrGenerationSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            
                            switch viewModel.qrOption {
                            case .url:
                                urlSection
                            case .contactCard:
                                contactCardSection
                            case .phoneNumber:
                                phoneNumberSection
                            case .wifiAddress:
                                wifiAddressSection
                            case .email:
                                emailSection
                            case .plainText:
                                plainTextSection
                            case .smsMessage:
                                smsMessageSection
                            case .geoLocation:
                                geoLocationSection
                            case .upiPayment:
                                upiPaymentSection
                            }
                            
                            WTButton(
                                title: "Generate QR Code",
                                onTap: {
                                    viewModel.btnGenerateQRCodeAction()
                                }
                            )
                            .padding(.top, 20)
                            
                            
                        }.padding(16)
                    }
                    .background(AppColor.Gray.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 11))
                    .padding(16)
                    .padding(.bottom, 100)
                }
                
                VStack { }.frame(height: 200)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private var urlSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            qrTextField(title: "Enter URL", text: $viewModel.urlStr)
        }
    }
    
    private var contactCardSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            qrTextField(title: "Name", text: $viewModel.name)
            qrTextField(title: "Mobile", text: $viewModel.mobile, keyboardType: .numberPad)
            qrTextField(title: "Email", text: $viewModel.email, keyboardType: .emailAddress)
            qrTextField(title: "Address", text: $viewModel.address)
            qrTextField(title: "Organization", text: $viewModel.organization)
        }
    }
    
    private var phoneNumberSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            qrTextField(title: "Phone Number", text: $viewModel.phoneNumberStr, keyboardType: .numberPad)
        }
    }
    
    private var wifiAddressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            qrTextField(title: "Network/SSID", text: $viewModel.ssid, keyboardType: .default)
            qrTextField(title: "Password", text: $viewModel.password, keyboardType: .emailAddress)
            qrTextField(title: "Security Type", text: $viewModel.securityType, keyboardType: .decimalPad)
        }
    }
    
    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            qrTextField(title: "Email", text: $viewModel.email, keyboardType: .emailAddress)
        }
    }
    
    private var plainTextSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            qrTextView(title: "Enter Text", text: $viewModel.plainText)
        }
    }
    
    private var smsMessageSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            qrTextField(title: "Phone Number", text: $viewModel.phoneNumberStr, keyboardType: .numberPad)
            qrTextView(title: "Message", text: $viewModel.message)
        }
    }
    
    private var geoLocationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            qrTextField(title: "Latitude", text: $viewModel.latitude, keyboardType: .decimalPad)
            qrTextField(title: "Longitude", text: $viewModel.longitude, keyboardType: .decimalPad)
        }
    }
    
    private var upiPaymentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            qrTextField(title: "Merchat name", text: $viewModel.merchatName, keyboardType: .default)
            qrTextField(title: "UPI ID", text: $viewModel.upiID, keyboardType: .emailAddress)
            qrTextField(title: "Amount", text: $viewModel.amount, keyboardType: .decimalPad)
            qrTextField(title: "Note", text: $viewModel.note, keyboardType: .default)
        }
    }
}

extension QRGeneratorView {
    @ViewBuilder
    private func qrTextField(title: String, placeHolder: String = "", text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            WTText(title: title, color: .white, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                .padding(.leading, 8)
            
            WTTextField(placeHolder: placeHolder, text: text, keyboardType: keyboardType)
                .frame(height: 51)
        }
    }
    
    @ViewBuilder
    private func qrTextView(title: String, placeHolder: String = "", text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            WTText(title: title, color: .white, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                .padding(.leading, 8)
            
            WTTextView(placeHolder: placeHolder, text: text, keyboardType: keyboardType)
                .frame(height: 200)
        }
    }
}
