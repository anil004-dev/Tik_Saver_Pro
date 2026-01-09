//
//  SettingsViewModel.swift
//  WTScan
//
//  Created by iMac on 25/11/25.
//

import Combine
import SwiftUI

enum SettingOption {
    case aboutApp
    case feedback
    case rateUs
    case termsAndCondition
    case privacyPolicy
}

struct SettingRow {
    let id = UUID()
    let image: ImageResource
    let option: SettingOption
    let title: String
    let subTitle: String
}

class SettingsViewModel: ObservableObject {
    
    var arrSettings: [SettingRow] = [
        SettingRow(
            image: .icAboutApp,
            option: .aboutApp,
            title: "About App",
            subTitle: "Want to know about our app?\nRead it here."
        ),
        SettingRow(
            image: .icFeedbackMail,
            option: .feedback,
            title: "Feedback or Contact Us",
            subTitle: "Need help? Contact us via\nemail"
        ),
        SettingRow(
            image: .icRateUs,
            option: .rateUs,
            title: "Rate Us",
            subTitle: "Support us by rating our app on\nthe App Store"
        ),
        SettingRow(
            image: .icTermsAndCondition,
            option: .termsAndCondition,
            title: "Terms and Conditions",
            subTitle: "Read the terms and conditions that\ngovern the use of this app"
        ),
        SettingRow(
            image: .icPrivacyPolicy,
            option: .privacyPolicy,
            title: "Privacy Policy",
            subTitle: "Learn how we collect, use and\nProtect your data"
        )
    ]
    
    @Published var showSafariView: (sheet: Bool, url: URL?) = (false, nil)
    @Published var isFaceIdOn: Bool = WTBiometricManager.shared.isFaceIdOn {
        didSet {
            WTBiometricManager.shared.isFaceIdOn = isFaceIdOn
        }
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnSettingRowAction(settingRow: SettingRow) {
        let option = settingRow.option
        
        switch option {
        case .aboutApp:
            openAboutAppView()
        case .feedback:
            openMailForFeedback()
        case .rateUs:
            openRateApp()
        case .termsAndCondition:
            openTermsAndCondition()
        case .privacyPolicy:
            openPrivacyPolicy()
        }
    }
    
    func openAboutAppView() {
        NavigationManager.shared.push(to: .aboutApp)
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
    
    func openRateApp() {
        if let appReviewURL = URL(string: WTConstant.appReviewURL), UIApplication.shared.canOpenURL(appReviewURL) {
            UIApplication.shared.open(appReviewURL)
        }
    }
    
    func openTermsAndCondition() {
        if let url = URL(string: WTConstant.termsConditionURL) {
            UIApplication.shared.open(url)
        }
//        if let termsConditionURL = URL(string: WTConstant.termsConditionURL) {
//            showSafariView.url = termsConditionURL
//            showSafariView.sheet = true
//        }
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: WTConstant.privacyPolicyURL) {
            UIApplication.shared.open(url)
        }
//        if let privacyPolicyURL = URL(string: WTConstant.privacyPolicyURL) {
//            showSafariView.url = privacyPolicyURL
//            showSafariView.sheet = true
//        }
    }
}
