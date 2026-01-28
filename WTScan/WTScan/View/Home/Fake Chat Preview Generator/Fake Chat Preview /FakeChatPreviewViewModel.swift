//
//  FakeChatPreviewViewModel.swift
//  WTScan
//
//  Created by iMac on 21/11/25.
//

import SwiftUI
import Combine

class FakeChatPreviewViewModel: ObservableObject {
    
    @Published var messagePreview: MessagePreviewModel
    
    @Published var profileImage: UIImage?
    @Published var profileName: String
    @Published var arrMessage: [Message]
    @Published var showShareSheetView: (sheet: Bool, chatPreviewImage: UIImage?) = (false, nil)
    
    init(messagePreview: MessagePreviewModel) {
        _messagePreview = Published(initialValue: messagePreview)
        _profileImage = Published(initialValue: messagePreview.profileImage)
        _profileName = Published(initialValue: messagePreview.profileName)
        _arrMessage = Published(initialValue: messagePreview.arrMessage)
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnSaveAction() {
        let renderView = FakeChatPreviewView(isForRender: true, messagePreview: self.messagePreview).environmentObject(WTAlertManager.shared)
        var fullSize = renderView.intrinsicContentSize()
        
        // Force minimum screen height
        let deviceHeight = UIScreen.main.bounds.height
        
        if fullSize.height < deviceHeight {
            fullSize.height = deviceHeight
        }
        
        let image = renderView.renderImage(size: fullSize)
        if EntitlementManager.shared.hasPro {
            self.showShareSheetView.chatPreviewImage = image
            self.showShareSheetView.sheet = true
        }
        else {
            InterstitialAdManager.shared.didFinishedAd = { [weak self] in
                guard let self = self else { return }
                InterstitialAdManager.shared.didFinishedAd = nil
                
                self.showShareSheetView.chatPreviewImage = image
                self.showShareSheetView.sheet = true
            }
            
            InterstitialAdManager.shared.showAd()
        }
    }
}

import SwiftUI

extension View {
    /// Render SwiftUI View as UIImage with specific size
    func renderImage(size: CGSize) -> UIImage {
        let renderer = ImageRenderer(content: self)

        renderer.proposedSize = .init(size)
        renderer.scale = UIScreen.main.scale

        return renderer.uiImage ?? UIImage()
    }

    /// Compute the actual required size of a SwiftUI view
    func intrinsicContentSize() -> CGSize {
        let controller = UIHostingController(rootView: self)
        let size = controller.sizeThatFits(
            in: CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        )
        return size
    }
}
