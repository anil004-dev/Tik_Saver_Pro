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
        VStack(spacing: 16) {
            Image(systemName: "play.slash.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(AppColor.Pink)
                .padding(12.0)
                .frame(width: 50, height: 50)
                .background(.white.opacity(0.13))
                .clipShape(Circle())
            VStack(spacing: 0) {
                Text("No Videos")
                    .font(.custom(AppFont.Poppins_SemiBold, size: 18))
                    .foregroundColor(.white)
                switch mode {
                case .all:
                    Text("You didn't saved any videos yet.")
                        .lineLimit(2)
                        .font(.custom(AppFont.Poppins_Medium, size: 18))
                        .foregroundColor(Color(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0))
                        .multilineTextAlignment(.leading)
                case .collection(let collection):
                    Text("Videos not found in \(collection.name) collection.")
                        .lineLimit(2)
                        .font(.custom(AppFont.Poppins_Medium, size: 18))
                        .foregroundColor(Color(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0))
                        .multilineTextAlignment(.leading)
                }
                
            }
        }
        .padding(20.0)
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
                .cornerRadius(20.0)

            Image(systemName: "play.circle.fill")
                .resizable()
                .frame(width: 55, height: 55)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 3)
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
                .font(.system(size: 30))
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
                .font(.system(size: 30))
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
