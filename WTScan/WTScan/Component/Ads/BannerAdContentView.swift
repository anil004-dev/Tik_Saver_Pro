//
//  BannerAdContentView.swift
//  EasyPhotoToPDF
//
//  Created by IMac on 21/08/25.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdContentView: View {
    var body: some View {
        HStack {
            BannerAdRepresentableView().fixedSizeView
        }
        .frame(maxWidth: .infinity)
    }
}


struct BannerAdRepresentableView: UIViewRepresentable {
    var adSize: AdSize = currentOrientationAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width)
    
    func makeCoordinator() -> BannerCoordinator {
        return BannerCoordinator(self)
    }
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = AdUnitID.BannerAd
        banner.delegate = context.coordinator
        banner.load(Request())
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) { }
    
    class BannerCoordinator: NSObject, BannerViewDelegate {
        
        let parent: BannerAdRepresentableView
        
        init(_ parent: BannerAdRepresentableView) {
            self.parent = parent
        }
        
        // MARK: - GADBannerViewDelegate methods
        
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("DID RECEIVE AD.")
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
        }
    }
    
}

extension BannerAdRepresentableView {
    var fixedSizeView: some View {
        self.frame(width: adSize.size.width,
                   height: adSize.size.height)
    }
}
