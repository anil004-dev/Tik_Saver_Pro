//
//  DownloadedVideosView.swift
//  WTScan
//
//  Created by Anil Jadav on 10/01/26.
//

import SwiftUI

struct DownloadedVideosView: View {

    @State private var videos: [DownloadedVideo] = []
    @State private var selectedVideo: DownloadedVideo?
    @State private var showPlayer = false
    @State private var showDeleteAlert = false
    @State private var videoToDelete: DownloadedVideo?
    @State private var videoToAdd: DownloadedVideo?
    @State private var showAddView = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 44, weight: .light))
                .foregroundColor(.white)
            
            Text("No Downloaded Videos")
                .font(.custom(AppFont.Poppins_SemiBold, size: 18.0))
                .foregroundColor(.white)
            
            Text("You don’t have any downloaded videos yet.\nStart browsing videos and download them to see them here.")
                .font(.custom(AppFont.Poppins_Regular, size: 14.0))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func deleteVideo(_ video: DownloadedVideo) {
        DownloadStore.shared.delete(video)
        videos.removeAll { $0.id == video.id }
    }

    private func moveToCollection(_ video: DownloadedVideo) {
        videoToAdd = video
        showAddView = true
    }

    
    var body: some View {
        ScreenContainer {
            if videos.isEmpty {
                emptyStateView
            } else {
                GeometryReader { geo in
                    ScrollView {
                        let spacing: CGFloat = 15.0
                        let totalSpacing: CGFloat = spacing * CGFloat(columns.count - 1)
                        let leftAndRightSpacing: CGFloat = spacing * 2.0
                        let cellWidth = (geo.size.width - totalSpacing - leftAndRightSpacing) / CGFloat(columns.count)
                        LazyVGrid(columns: columns, spacing: spacing) {
                            ForEach(videos) { video in
                                ZStack {
                                    Image(uiImage: UIImage(contentsOfFile: video.thumbnailURL.path)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(
                                            width: cellWidth,
                                            height: cellWidth * 1.4   // vertical video ratio
                                        )
                                        .background(AppColor.Gray)
                                        .clipped()
                                        .cornerRadius(spacing)
                                    
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 36))
                                        .foregroundColor(.white)
                                        .shadow(radius: 4)
                                }
                                .overlay(alignment: .bottomTrailing) {
                                    // ⋯ Menu (BOTTOM RIGHT ONLY)
                                    Menu {
                                        Button {
                                            moveToCollection(video)
                                        } label: {
                                            Label("Add to Collection", systemImage: "folder")
                                        }

                                        Button(role: .destructive) {
                                            videoToDelete = video
                                            showDeleteAlert = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    } label: {
                                        Image(systemName: "chevron.forward.circle.fill")
                                            .resizable()
                                            .frame(width: 25.0, height: 25.0)
                                            .foregroundColor(.white)
                                            .padding(10)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedVideo = video
                                }
                                
                            }
                        }
                        .padding(spacing)
                    }
                }
            }
        }
        .onAppear {
            videos = DownloadStore.shared.load()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Saved Videos")
        .fullScreenCover(item: $selectedVideo) { video in
            VideoPlayerFullScreenView(videoURL: video.videoURL)
        }
        .sheet(item: $videoToAdd) { video in
            NavigationStack {
                MyVideoCollectionView(videoToAdd: video)
            }
        }
        .alert("Delete Video?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let video = videoToDelete {
                    deleteVideo(video)
                    videoToDelete = nil
                }
            }

            Button("Cancel", role: .cancel) {
                videoToDelete = nil
            }
        } message: {
            Text("This video will be permanently removed from your device.")
        }

    }
}

