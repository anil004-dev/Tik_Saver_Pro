//
//  DownloadedVideosView.swift
//  WTScan
//
//  Created by Anil Jadav on 10/01/26.
//

import SwiftUI

struct DownloadedVideosView: View {

    enum Mode {
        case all
        case collection(VideoCollection)
    }

    let mode: Mode

    @State private var videos: [DownloadedVideo] = []
    @State private var selectedVideo: DownloadedVideo?
    @State private var showDeleteAlert = false
    @State private var videoToDelete: DownloadedVideo?
    @State private var videoToAdd: DownloadedVideo?

    private let spacing: CGFloat = 15

    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing)
        ]
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 44))
                .foregroundColor(.white)

            Text("No Videos")
                .font(.custom(AppFont.Poppins_SemiBold, size: 18))
                .foregroundColor(.white)

            Text("No videos found in this collection.")
                .font(.custom(AppFont.Poppins_Regular, size: 14))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Load
    private func loadVideos() {
        switch mode {
        case .all:
            videos = DownloadStore.shared.load()

        case .collection(let collection):
            videos = CollectionStore.shared.loadVideos(in: collection)
        }
    }

    // MARK: - Delete
    private func deleteVideo(_ video: DownloadedVideo) {
        switch mode {
        case .all:
            DownloadStore.shared.delete(video)

        case .collection(let collection):
            CollectionStore.shared.removeVideo(video, from: collection)
        }

        videos.removeAll { $0.id == video.id }
    }

    // MARK: - Body
    var body: some View {
        ScreenContainer {
            if videos.isEmpty {
                emptyStateView
            } else {
                GeometryReader { geo in
                    let cellWidth = (geo.size.width - spacing * 3) / 2

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: spacing) {
                            ForEach(videos) { video in
                                videoCell(video, width: cellWidth)
                            }
                        }
                        .padding(spacing)
                    }
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadVideos)
        .fullScreenCover(item: $selectedVideo) {
            VideoPlayerFullScreenView(videoURL: $0.videoURL)
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
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - Title
    private var title: String {
        switch mode {
        case .all:
            return "Saved Videos"
        case .collection(let collection):
            return collection.name
        }
    }

    // MARK: - Cell
    @ViewBuilder
    private func videoCell(_ video: DownloadedVideo, width: CGFloat) -> some View {
        ZStack {
            Image(uiImage: UIImage(contentsOfFile: video.thumbnailURL.path)!)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: width * 1.4)
                .clipped()
                .cornerRadius(14)

            Image(systemName: "play.circle.fill")
                .font(.system(size: 36))
                .foregroundColor(.white)
        }
        .overlay(alignment: .topTrailing) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    switch mode {
                    case .collection:
                        deleteButton(video)
                    case .all:
                        menuButton(video)
                    }
                }
            }
        }
        .onTapGesture {
            selectedVideo = video
        }
    }

    // MARK: - Menu (All Videos)
    private func menuButton(_ video: DownloadedVideo) -> some View {
        Menu {
            Button {
                videoToAdd = video
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
            Image(systemName: "ellipsis.circle.fill")
                .font(.system(size: 22))
                .foregroundColor(.white)
                .padding(10)
        }
    }

    // MARK: - Delete (Collection Mode)
    private func deleteButton(_ video: DownloadedVideo) -> some View {
        Button {
            videoToDelete = video
            showDeleteAlert = true
        } label: {
            Image(systemName: "trash.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding(10)
        }
    }
}

// MARK: - Helpers
private extension DownloadedVideosView.Mode {
    var collectionValue: VideoCollection? {
        if case .collection(let collection) = self {
            return collection
        }
        return nil
    }
}
