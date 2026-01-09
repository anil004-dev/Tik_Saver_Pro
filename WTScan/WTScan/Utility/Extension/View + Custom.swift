//
//  View + Custom.swift
//  WTScan
//
//  Created by iMac on 11/11/25.
//


import SwiftUI
import GoogleMobileAds

// MARK: - View Extension
extension View {
    
    func safeAreaInsets() -> UIEdgeInsets? {
        let safeAreaInsets = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first?.safeAreaInsets
        
        return safeAreaInsets
    }
    
    func paddingFromBannerAd() -> CGFloat {
        return currentOrientationAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width).size.height + 16.0 + (safeAreaInsets()?.bottom ?? 0)
    }
    
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifiOS26Available<Content: View>(
        @ViewBuilder _ transform: (Self) -> Content
    ) -> some View {
        if #available(iOS 26.0, *) {
            self//transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifiOS26Unavailable<Content: View>(
        @ViewBuilder _ transform: (Self) -> Content
    ) -> some View {
        if #available(iOS 26.0, *) {
            transform(self)  //self
        } else {
            transform(self)
        }
    }
}
