//
//  MyVideoCollectionView.swift
//  WTScan
//
//  Created by Anil Jadav on 10/01/26.
//

import SwiftUI

struct MyVideoCollectionView: View {

    @State private var collections: [VideoCollection] = []
    @State private var showAddCollection = false
    @State private var showDeleteAlert = false
    @State private var collectionToDelete: VideoCollection?
    let videoToAdd: DownloadedVideo?
    @State private var selectedCollection: VideoCollection?
    @State private var previewCollection: VideoCollection?
    @State private var showPreviewCollection = false
    @Environment(\.dismiss) private var dismiss
    
//    private let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
    
    func getColumn(columnsCount: Int, cellWidth: CGFloat, spacing: CGFloat) -> [GridItem] {
        Array(
            repeating: GridItem(.fixed(cellWidth), spacing: spacing),
            count: Int(columnsCount)
        )
    }
    
    private var collectionGridView: some View {
        GeometryReader { geo in
            ScrollView {
                let columnCount: Int = 3
                let spacing: CGFloat = 14
                let totalSpacing = spacing * CGFloat(columnCount - 1)
                let leftAndRightSpacing: CGFloat = spacing + spacing
                let cellWidth = (geo.size.width - leftAndRightSpacing - totalSpacing) / CGFloat(columnCount)

                let columns = self.getColumn(columnsCount: columnCount, cellWidth: cellWidth, spacing: spacing)
                
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(collections) { collection in
                        collectionCell(
                            collection: collection,
                            size: cellWidth
                        )
                    }
                }
                .padding(spacing)
            }
        }
    }

    @ViewBuilder
    private func collectionCell(
        collection: VideoCollection,
        size: CGFloat
    ) -> some View {
        CollectionCellView(
            collection: collection,
            size: size,
            videoToAdd: videoToAdd,
            isSelected: selectedCollection?.id == collection.id,
            onTap: {
                if videoToAdd != nil {
                    if selectedCollection?.id == collection.id {
                        selectedCollection = nil   // deselect
                    } else {
                        selectedCollection = collection
                    }
                }
                else {
                    previewCollection = collection
                    showPreviewCollection = true
                }
            },
            onDelete: {
                collectionToDelete = collection
                showDeleteAlert = true
            }
        )
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if !collections.isEmpty {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddCollection = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }

        if videoToAdd != nil {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }

    @ViewBuilder
    private var addToCollectionButton: some View {
        if let video = videoToAdd {
            Button {
                if let collection = selectedCollection {
                    do {
                        try CollectionStore.shared.addVideo(video, to: collection)
                    }
                    catch let error {
                        print(error)
                    }
                    dismiss()
                }
            } label: {
                Text("Add to Collection")
                    .font(.custom(AppFont.Poppins_SemiBold, size: 16))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .tint(
                selectedCollection == nil
                ? Color.gray
                : AppColor.Pink
            )
            .disabled(selectedCollection == nil)
        }
    }



    var body: some View {
        ScreenContainer {
            if collections.isEmpty {
                emptyStateView
            } else {
                collectionGridView
            }
        }
        .navigationTitle("Collections")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContent
        }
        .onAppear {
            collections = CollectionStore.shared.load()
        }
        .sheet(isPresented: $showAddCollection) {
            AddCollectionView { _ in
                //try? CollectionStore.shared.create(name: name)
                collections = CollectionStore.shared.load()
            }
        }
        .alert("Delete Collection?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let collection = collectionToDelete {
                    CollectionStore.shared.delete(collection)
                    collections = CollectionStore.shared.load()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("All videos inside this collection will be removed from the collection.")
        }
        .safeAreaInset(edge: .bottom) {
            addToCollectionButton
        }
        .navigationDestination(isPresented: $showPreviewCollection) {
            if let collection = self.previewCollection {
                DownloadedVideosView(mode: .collection(collection))
            }
        }
    }
}

private extension MyVideoCollectionView {

    var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder")
                .font(.system(size: 48))
                .foregroundColor(.white)

            Text("No Collections Yet")
                .font(.custom(AppFont.Poppins_SemiBold, size: 18))
                .foregroundColor(.white)

            Text("Create collections to organize your videos.")
                .font(.custom(AppFont.Poppins_Regular, size: 14))
                .foregroundColor(.white.opacity(0.8))

            Button {
                showAddCollection = true
            } label: {
                Text("Add Collection")
                    .font(.custom(AppFont.Poppins_Medium, size: 15))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

enum CardGradients {
    static let all: [LinearGradient] = [
        LinearGradient(colors: [Color.blue.opacity(0.9), Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.purple.opacity(0.9), Color.pink], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.orange.opacity(0.9), Color.red], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.green.opacity(0.9), Color.teal], startPoint: .topLeading, endPoint: .bottomTrailing)
    ]

    static func gradient(for id: UUID) -> LinearGradient {
        let index = abs(id.hashValue) % all.count
        return all[index]
    }
}


struct CollectionCellView: View {

    let collection: VideoCollection
    let size: CGFloat
    let videoToAdd: DownloadedVideo?
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: () -> Void

    private var gradient: LinearGradient {
        CardGradients.gradient(for: collection.id)
    }
    
    private var coverThumbnailURL: URL? {
        let videos = CollectionStore.shared.loadVideos(in: collection)
        guard let first = videos.first else { return nil }
        return MediaDirectory.thumbnails.appendingPathComponent(first.thumbnailFileName)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(gradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            isSelected ? Color.white : Color.clear,
                            lineWidth: 2
                        )
                )
                .shadow(color: .black.opacity(0.5), radius: 18, x: 0, y: 14)

            VStack(spacing: 0) {

                ZStack {
                    if let url = coverThumbnailURL,
                       let image = UIImage(contentsOfFile: url.path) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipped()
                    } else {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 38))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Bottom black title
                Text(collection.name)
                    .font(.custom(AppFont.Poppins_SemiBold, size: 14))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .padding(5)
                    .frame(width: size, height: 50)
                    .background(Color.black.opacity(0.85))
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
            // ❌ Delete (only normal mode)
            if videoToAdd == nil {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: onDelete) {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding(10)
                                .clipShape(Circle())
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(width: size, height: size + 50)
        .onTapGesture {
            onTap()
        }
    }

}
