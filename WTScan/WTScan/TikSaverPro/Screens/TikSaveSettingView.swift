//
//  TikSaveSettingView.swift
//  WTScan
//
//  Created by Anil Jadav on 10/01/26.
//

import SwiftUI

struct WebItem: Identifiable {
    let id = UUID()
    let url: URL
    let title: String
}

struct TikSaveSettingView: View {
    
    // MARK: - States
    @State private var showShare = false
    @State private var webItem: WebItem?
    // MARK: - Constants
    
    private let appStoreReviewURL = URL(string: WTConstant.appReviewURL)!
    private let appStoreURL = URL(string: WTConstant.appURL)!
    private let termsURL = URL(string: WTConstant.termsConditionURL)!
    private let privacyURL = URL(string: WTConstant.privacyPolicyURL)!
    
    // MARK: - UI Components
    
    @ViewBuilder
    func Cell(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(AppColor.Gray)
            
            Text(title)
                .font(.custom(AppFont.Poppins_Regular, size: 16))
                .foregroundColor(.primary)
                .contentShape(Rectangle())
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(AppColor.Gray)
        }
    }
    
    @ViewBuilder
    func Header(title: String) -> some View {
        Text(title)
            .font(.custom(AppFont.Poppins_SemiBold, size: 16))
            .foregroundStyle(AppColor.Pink)
    }
    
    func openMailForFeedback() {
        let email = "narendrasorathiya004@gmail.com"
        let subject = "\(Utility.getAppName()) Contact Us"
        let body = "Hello, I need help with..."
    
        let emailString = "mailto:\(email)?subject=\(subject)&body=\(body)"
        if let emailURL = emailString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: emailURL),UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    var body: some View {
        ScreenContainer {
            List {
                // MARK: App Section
                Section(header: Header(title: "App")) {
                    Button {
                        UIApplication.shared.open(appStoreReviewURL)
                    } label: {
                        Cell(title: "Rate Us", icon: "star.fill")
                    }
                    
                    Button {
                        self.openMailForFeedback()
                    } label: {
                        Cell(title: "Leave Feedback", icon: "bubble.left.and.bubble.right.fill")
                    }
                    
                    Button {
                        showShare = true
                    } label: {
                        Cell(title: "Share App", icon: "square.and.arrow.up")
                    }
                }
                .listRowBackground(Color(UIColor.secondarySystemBackground))
                
                // MARK: Privacy Section
                Section(header: Header(title: "Privacy settings")) {
                    Button {
                        webItem = WebItem(url: termsURL, title: "Terms of Use")
                    } label: {
                        Cell(title: "Terms of Use", icon: "doc.text.fill")
                    }
                    Button {
                        webItem = WebItem(url: privacyURL, title: "Privacy Policy")
                    } label: {
                        Cell(title: "Privacy Policy", icon: "lock.shield.fill")
                    }
                }
                .listRowBackground(Color(UIColor.secondarySystemBackground))
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShare) {
            TikSaveShareSheet(items: [appStoreURL])
        }
        .sheet(item: $webItem) { item in
            TikSaveWebViewContainer(url: item.url, title: item.title)
        }
    }
}

#Preview {
    TikSaveSettingView()
}
