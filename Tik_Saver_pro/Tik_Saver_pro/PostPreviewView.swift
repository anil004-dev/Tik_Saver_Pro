//
//  PostPreviewView.swift
//  Tik_Saver_pro
//
//  Created by Anil Jadav on 08/01/26.
//

import SwiftUI
import AVFoundation
import AVKit

struct PostPreviewView: View {
    let downloadedVideoURL: DownloadVideoItem
    let post: TikTokPost
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    
    func downloadVideoButtonAction() {
        
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
                VStack {
                    Rectangle()
                        .fill(AppColor.Gray)
                        .frame(height: 61)
                    Spacer()
                }
                if let player {
                    AppVideoPlayer(player: player)
                        .ignoresSafeArea()
                        .padding(.top, 61)
                    Button {
                        if player.timeControlStatus == .playing {
                            player.pause()
                            isPlaying = false
                        } else {
                            player.play()
                            isPlaying = true
                        }
                    } label: {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
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
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Preview")
                        .foregroundColor(.white)
                        .font(.custom(AppFont.Poppins_SemiBold, size: 16.0))
                }
            }
            .task {
                player = AVPlayer(url: downloadedVideoURL.url)
                player?.play()
                isPlaying = true
            }
        }
    }
}
