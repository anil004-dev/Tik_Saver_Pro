//
//  ContentView.swift
//  Tik_Saver_pro
//
//  Created by Anil Jadav on 08/01/26.
//

import SwiftUI

struct TikSaveRootView: View {
    
    @State private var postURL: String = ""
    @State private var downloadedVideoURL: DownloadedVideo?
    @State private var isPresentPreview: Bool = false
    @State private var isLoading: Bool = false
    @State private var post: TikTokPost?
    @State private var isShowsubscriptionAlert: Bool = false
    @State private var showPurchase: Bool = false
    @State private var isPremium: Bool = UserDefaultManager.isPremium
    func navigationMessageButtonAction() {
        
    }
    
    func navigationMoreButtonAction() {
        
    }
    
    func pasteButtonAction() {
        AppOpenAdManager.shared.isAdsDisabled = true
        if let pasted = UIPasteboard.general.string {
            postURL = pasted
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                AppOpenAdManager.shared.isAdsDisabled = false
            }
            findVideoButtonAction()
        }
        else {
            AppOpenAdManager.shared.isAdsDisabled = false
        }
    }
    
    func findVideoButtonAction() {
        if self.isPremium {
            startFindVideo()
        }
        else {
            InterstitialAdManager.shared.didFinishedAd = {
                InterstitialAdManager.shared.didFinishedAd = nil
                startFindVideo()
            }
            InterstitialAdManager.shared.showAd()
        }
    }
    
    func startFindVideo() {
        guard let url = URL(string: postURL) else {
            WTToastManager.shared.show("Please enter valid url.")
            return
        }
        let isTiktockURL = url.host?.contains("tiktok") ?? false
        if isTiktockURL {
            Task {
                do {
                    withAnimation {
                        isLoading = true
                    }
                    let postData = try await TikTokScraper.shared.scrapePost(from: url)
                    print(postData.prettyPrintedJSON())
                    let videoData = try await VideoDownloader.shared.downloadVideo(from: postData.video)
                    post = postData
                    downloadedVideoURL = videoData
                    print("✅ Video downloaded:", videoData.videoURL)
                    isPresentPreview = true
                    postURL = ""
                    withAnimation {
                        isLoading = false
                    }
                } catch {
                    isLoading = false
                    WTToastManager.shared.show("We couldn’t fetch this video. It may be private, deleted, or the link is invalid. Please check the URL and try again.")
                }
            }
        }
        else {
            WTToastManager.shared.show("Please enter valid tiktok url.")
        }
    }
    
    @ViewBuilder func navigationButton(action: @escaping () -> Void, icon: String) -> some View {
        if #available(iOS 26.0, *) {
            Button(action: action) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 18)
            }
            .disabled(isLoading)
            .padding(5)
            .glassEffect()
        } else {
            Button(action: action) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 18)
            }
            .disabled(isLoading)
        }
    }
    
    @ViewBuilder func bulletsView(text: String) -> some View {
        HStack {
            Image(systemName: "checkmark.seal")
                .resizable()
                .scaledToFit()
                .foregroundStyle(AppColor.Cyan)
                .frame(width: 20, height: 20)
            Text(text)
                .font(.custom(AppFont.Poppins_Regular, size: 14.0))
                .foregroundStyle(.white)
        }
    }
    
    var body: some View {
        ScreenContainer {
            ZStack {
                ScrollView {
                    VStack(spacing: 14.0) {
                        HStack {
                            Text("Video")
                                .font(.custom(AppFont.Poppins_SemiBold, size: 33.0))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 16.0) {
                            bulletsView(text: "Open TikTok App")
                            bulletsView(text: "Find the video you want to download, press share button and copy the link")
                            bulletsView(text: "Return to the application and press \"Paste\" button")
                            
                            VStack(alignment: .leading, spacing: 10.0) {
                                Text("Paste TikTok Video link you want to download")
                                    .font(.custom(AppFont.Poppins_Regular, size: 14.0))
                                    .foregroundStyle(.white)
                                    .padding(.leading, 10.0)
                                HStack {
                                    TextField("", text: $postURL, prompt: Text("Enter or Paste URL.").foregroundStyle(.gray))
                                        .font(.custom(AppFont.Poppins_Regular, size: 14.0))
                                        .foregroundStyle(.black)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .textContentType(.URL)
                                        .tint(.black)
                                    if !postURL.isEmpty {
                                        Button {
                                            postURL = ""
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(AppColor.Gray)
                                        }
                                    }
                                    Button(action: pasteButtonAction) {
                                        Text("Paste")
                                            .font(.custom(AppFont.Poppins_Medium, size: 14.0))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 8)
                                            .background(.black)
                                            .cornerRadius(11.0)
                                    }
                                }
                                .padding(5)
                                .padding(.leading, 15.0)
                                .background(.white)
                                .cornerRadius(14.0)
                            }
                            .padding(.top, 30)
                            
                            Button(action: findVideoButtonAction) {
                                HStack {
                                    Spacer()
                                    Text("Find Video")
                                        .font(.custom(AppFont.Poppins_SemiBold, size: 16.0))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(AppColor.Pink)
                                .cornerRadius(14.0)
                            }
                            .padding(.top, 15)
                        }
                        .padding()
                        .background(AppColor.Gray.opacity(0.12))
                        .cornerRadius(20.0)
                        Spacer()
                    }
                }
                .padding()
                .scrollIndicators(.hidden)

                if isLoading {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.black)
                                .scaleEffect(2.0)
                                .padding(40)
                                .background(.white)
                                .cornerRadius(20.0)
                            Spacer()
                        }
                        Spacer()
                    }
                    .ignoresSafeArea()
                    .background(.black.opacity(0.5))
                }
                WTToastView()
                    .zIndex(9999)
            }
            .hideKeyboardOnTap()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("splash_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 97, height: 39, alignment: .center)
            }
            if #available(iOS 26.0, *) {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {showPurchase = true}) {
                        Image("img_subscribe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 69, height: 33)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            } else {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {showPurchase = true}) {
                        Image("img_subscribe")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
        .navigationDestination(isPresented: $isPresentPreview) {
            if let videoItem = self.downloadedVideoURL, let post = self.post {
                PostPreviewView(downloadedVideoURL: videoItem, post: post)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
        .alert(
            "Your subscription has expired",
            isPresented: $isShowsubscriptionAlert
        ) {
            Button("Subscribe") {
                showPurchase = true
            }
            Button("Not now", role: .cancel) { }
        } message: {
            Text("Renew or upgrade your subscription to use interruption free app.")
        }
        .onAppear {
            if AppState.shared.isSubscriptionExpired == true {
                self.isShowsubscriptionAlert = true
            }
            isPremium = UserDefaultManager.isPremium
        }
        .fullScreenCover(isPresented: $showPurchase) {
            
        } content: {
            NavigationStack {
                TikSavePurchaseView(isPremium: $isPremium)
            }
        }
    }
}

