//
//  ClipboardTemplateViewModel.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import Combine
import UIKit

class ClipboardTemplateViewModel: ObservableObject {
    
    @Published var arrClipboards: [WTClipboardModel] = []
    @Published var showAddTemplateView: (sheet: Bool, viewModel: AddClipboardTemplateViewModel?) = (false, nil)
    
    func onAppear() {
        let isFirstLaunch = UserDefaultManager.isFirsTimeAppLaunched
        
        if isFirstLaunch == false {
            UserDefaultManager.isFirsTimeAppLaunched = true
            
            let arrClipboardTexts: [String] = [
                "Hey! I'm currently busy. Will get back to you soon.",
                "Thank you for your order! We'll update you soon.",
                "Be right back, call you in 10 min.",
                "Thank you for reaching out 🙏",
                "Here’s our address 📍: ...",
                "Noted, thank you!",
                "I'll get back to you shortly. Thanks for your patience!",
                "Hey! Just checking in. Hope all is well.",
                "Thank you for reaching out. I'll update you soon!",
                "Can we talk later? I'm in a meeting right now.",
                "Follow us on Instagram 👉 @yourhandle",
                "Our office hours: Mon–Fri, 9 AM to 6 PM IST."
            ].reversed()

            arrClipboardTexts.forEach { clipboardText in
                ClipboardManager.shared.addClipboard(clipboardText: clipboardText) { _, _ in }
            }
        }
        
        fetchClipboards()
    }
    
    func fetchClipboards() {
        arrClipboards = ClipboardManager.shared.fetchAllClipboards()
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnAddTemplateAction() {
        let viewModel = AddClipboardTemplateViewModel()
        viewModel.dismiss = { [weak self] in
            self?.showAddTemplateView.viewModel = nil
            self?.showAddTemplateView.sheet = false
        }
        
        viewModel.didTempCreated = { [weak self] in
            self?.fetchClipboards()
            self?.showAddTemplateView.viewModel = nil
            self?.showAddTemplateView.sheet = false
        }
        
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.showAddTemplateView.viewModel = viewModel
            self.showAddTemplateView.sheet = true
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnCopyToClipboardAction(clipboard: WTClipboardModel) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let _ = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            UIPasteboard.general.string = clipboard.clipboardText
            WTToastManager.shared.show("Message copied to clipboard")
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}
