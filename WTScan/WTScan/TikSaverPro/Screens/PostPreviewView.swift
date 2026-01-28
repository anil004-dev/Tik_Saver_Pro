//
//  PostPreviewView.swift
//  Tik_Saver_pro
//
//  Created by Anil Jadav on 08/01/26.
//

import SwiftUI
import AVFoundation
import AVKit
import PhotosUI
import StoreKit

struct PostPreviewView: View {
    let downloadedVideoURL: DownloadedVideo
    let post: TikTokPost
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var showPhotoPermissionAlert = false
    @State private var showPurchase: Bool = false
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    func saveVideoToPhotos(from fileURL: URL) {
        AppState.shared.isRequestingPermission = true
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                AppState.shared.isRequestingPermission = false
            }
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    self.showPhotoPermissionAlert = true
                }
                return
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        WTToastManager.shared.show("Video saved to Photos.")
                        if entitlementManager.hasPro {
                            self.requestAppStoreReview()
                        }
                        else {
                            self.showPurchase = true
                        }
                    } else {
                        WTToastManager.shared.show("Couldn’t save the video. Please try again.")
                    }
                }
            }
        }
    }
    
    func requestAppStoreReview() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else {
            return
          }
          AppStore.requestReview(in: windowScene)
        }
      }
    
    func downloadVideoButtonAction() {
        if entitlementManager.hasPro {
            DispatchQueue.main.async {
                self.saveVideoToPhotos(from: downloadedVideoURL.videoURL)
            }
        }
        else {
            InterstitialAdManager.shared.didFinishedAd = {
                InterstitialAdManager.shared.didFinishedAd = nil
                DispatchQueue.main.async {
                    self.saveVideoToPhotos(from: downloadedVideoURL.videoURL)
                }
            }
            InterstitialAdManager.shared.showAd()
        }
    }
    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    @ViewBuilder func SideView(icon: String, text: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .foregroundStyle(Color(red: 209/255, green: 211/255, blue: 212/255))
                .shadow(
                    color: .black.opacity(0.25),
                    radius: 8,
                    x: 0,
                    y: 0
                )
            Text(text)
                .font(.custom(AppFont.Poppins_Medium, size: 13.0))
                .foregroundStyle(.white)
        }
        
    }
    
    var body: some View {
        ScreenContainer {
            ZStack {
                if !entitlementManager.hasPro {
                    VStack {
                        BannerAdContentView()
                            .frame(height: 75)
                        Spacer()
                    }
                }
                if let player {
                    AppVideoPlayer(player: player, showControls: false)
                        .ignoresSafeArea()
                        .padding(.top, entitlementManager.hasPro ? 0 : 75)
                    Color.clear
                        .contentShape(Rectangle()) // 👈 important
                        .onTapGesture {
                            if player.timeControlStatus == .playing {
                                player.pause()
                                isPlaying = false
                            } else {
                                player.play()
                                isPlaying = true
                            }
                        }
                        .padding(.top, entitlementManager.hasPro ? 0 : 75)
                    if !isPlaying {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
                else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(2.0)
                }
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 21) {
                            AsyncImage(
                                url: URL(string: post.author.avatarLarger)
                            ) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 45, height: 45)

                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 45, height: 45)
                                case .failure:
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 45, height: 45)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            SideView(icon: "heart.fill", text: post.stats.diggCount.abbreviated())
                            SideView(icon: "ellipsis.message.fill", text: post.stats.commentCount.abbreviated())
                            SideView(icon: "arrowshape.turn.up.right.fill", text: post.stats.shareCount.abbreviated())
                        }
                        .padding([.trailing, .bottom])
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("@\(post.author.uniqueId)")
                            .font(.custom(AppFont.Poppins_SemiBold, size: 18.0))
                            .foregroundStyle(.white)
                        Text(post.desc)
                            .lineLimit(2)
                            .font(.custom(AppFont.Poppins_Regular, size: 16.0))
                            .foregroundStyle(.white)
                        Button(action: downloadVideoButtonAction) {
                            HStack {
                                Spacer()
                                Text("Download Video")
                                    .font(.custom(AppFont.Poppins_SemiBold, size: 16.0))
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding()
                            .background(AppColor.Pink)
                            .clipShape(.capsule)
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.black.opacity(0.58)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                }
                //.padding()
                WTToastView()
                    .zIndex(9999)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Preview")
                        .foregroundColor(.white)
                        .font(.custom(AppFont.Poppins_SemiBold, size: 16.0))
                }
            }
            .task {
                player = AVPlayer(url: downloadedVideoURL.videoURL)
                player?.play()
                isPlaying = true
                NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: player!.currentItem,
                        queue: .main
                    ) { _ in
                        player!.seek(to: .zero)
                        player!.play()
                        isPlaying = true
                    }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self)
                if player != nil {
                    player!.pause()
                }
                
            }
            .alert("Photos Access Required", isPresented: $showPhotoPermissionAlert) {
                Button("Settings") {
                    openAppSettings()
                }
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please allow Photos access to save videos to your library.")
            }
        }
        .fullScreenCover(isPresented: $showPurchase) {
            self.requestAppStoreReview()
        } content: {
            NavigationStack {
                TikSavePurchaseView()
            }
        }
    }
}
