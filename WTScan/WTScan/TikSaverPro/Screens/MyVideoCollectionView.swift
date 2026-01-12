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
                let columnCount: Int = 2
                let spacing: CGFloat = 20
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
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showAddCollection = true
            } label: {
                Image(systemName: "plus")
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
        if let video = videoToAdd, collections.count > 0 {
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
                HStack {
                    Spacer()
                    Text("Add to Collection")
                        .font(.custom(AppFont.Poppins_SemiBold, size: 16))
                        .padding(.vertical, 15)
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            .background(
                selectedCollection == nil
                ? Color.gray
                : AppColor.Pink
            )
            .disabled(selectedCollection == nil)
            .cornerRadius(14.0)
            .padding(.horizontal, 20)
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
            NavigationStack {
                AddCollectionView { _ in
                    //try? CollectionStore.shared.create(name: name)
                    collections = CollectionStore.shared.load()
                }
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
            Image("ic_collection")
                .resizable()
                .scaledToFit()
                .foregroundColor(AppColor.Pink)
                .padding(12)
                .frame(width: 50, height: 50)
                .background(.white.opacity(0.13))
                .clipShape(Circle())
            
            VStack(spacing: 0) {
                Text("No Collections")
                    .font(.custom(AppFont.Poppins_SemiBold, size: 18))
                    .foregroundColor(.white)
                
                Text("Start by adding a collection.")
                    .font(.custom(AppFont.Poppins_Medium, size: 18))
                    .foregroundColor(Color(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0))
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CollectionCellView: View {

    let collection: VideoCollection
    let size: CGFloat
    let videoToAdd: DownloadedVideo?
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: () -> Void

    private var coverThumbnailURL: URL? {
        let videos = CollectionStore.shared.loadVideos(in: collection)
        guard let first = videos.first else { return nil }
        return MediaDirectory.thumbnails.appendingPathComponent(first.thumbnailFileName)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(hex: "#CCCCCC"))
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
                        Image(systemName: "folder.circle.fill")
                            .font(.system(size: 45))
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Bottom black title
                Text(collection.name)
                    .font(.custom(AppFont.Poppins_SemiBold, size: 14))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .padding(5)
                    .frame(width: size, height: 56)
                    .background(Color.black)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
            // ❌ Delete (only normal mode)
            if videoToAdd == nil {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: onDelete) {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(width: 35, height: 35)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
                                .padding(.trailing, 12)
                                .padding(.top, 12)
                        }
                        
                    }
                    Spacer()
                }
            }
        }
        .frame(width: size, height: size + 56)
        .onTapGesture {
            onTap()
        }
    }

}
