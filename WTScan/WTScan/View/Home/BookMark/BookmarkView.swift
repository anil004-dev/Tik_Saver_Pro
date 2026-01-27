//
//  BookmarkView.swift
//  WTScan
//
//  Created by Anil Jadav on 13/01/26.
//

import SwiftUI
import LinkPresentation

struct BookmarkView: View {
    @State private var bookmarkURL: String = ""
    @State private var isLoading: Bool = false
    @State private var linkMetadata: LPLinkMetadata?
    @State private var previewError: Bool = false
    @StateObject private var bookmarkStore = BookmarkStore()
    @State private var showBookmarkList = false
    @State private var showPurchase = false

    func showBookmarkButtonAction() {
        showBookmarkList = true
    }
    
    func pasteButtonAction() {
        AppOpenAdManager.shared.isAdsDisabled = true
        if let pasted = UIPasteboard.general.string {
            bookmarkURL = pasted
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                AppOpenAdManager.shared.isAdsDisabled = false
            }
            findBookmarkPreview()
        }
        else {
            AppOpenAdManager.shared.isAdsDisabled = false
        }
    }
    
    func saveButtonAction() {
        self.showPurchase = true
        return
        
        guard let metadata = linkMetadata,
              let url = metadata.originalURL?.absoluteString ?? metadata.url?.absoluteString
        else {
            WTToastManager.shared.show("No preview available to save.")
            return
        }
        InterstitialAdManager.shared.didFinishedAd = {
            InterstitialAdManager.shared.didFinishedAd = nil
            let bookmark = BookmarkItem(
                url: url,
                title: metadata.title
            )
            bookmarkStore.add(bookmark)
            WTToastManager.shared.show("Bookmark saved")
            
            // Reset UI
            bookmarkURL = ""
            linkMetadata = nil
            previewError = false
        }
        
        InterstitialAdManager.shared.showAd()
    }

    
    func findBookmarkPreview() {
        guard let url = URL(string: bookmarkURL),
              UIApplication.shared.canOpenURL(url) else {
            WTToastManager.shared.show("Please enter valid url.")
            linkMetadata = nil
            return
        }
        isLoading = true
        previewError = false
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { metadata, error in
            DispatchQueue.main.async {
                isLoading = false
                if let metadata = metadata {
                    self.linkMetadata = metadata
                } else {
                    self.linkMetadata = nil
                    self.previewError = true
                }
            }
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
                            Text("Bookmark")
                                .font(.custom(AppFont.Poppins_SemiBold, size: 33.0))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 16.0) {
                            bulletsView(text: "Copy the link you want to save as a bookmark")
                            bulletsView(text: "Paste the link into the field below")
                            bulletsView(text: "Preview the page and save it for quick access later")

                            
                            VStack(alignment: .leading, spacing: 10.0) {
                                Text("Paste the link you want to bookmark")
                                    .font(.custom(AppFont.Poppins_Regular, size: 14.0))
                                    .foregroundStyle(.white)
                                    .padding(.leading, 10.0)
                                HStack {
                                    TextField("", text: $bookmarkURL, prompt: Text("Enter or Paste URL.").foregroundStyle(.gray))
                                        .font(.custom(AppFont.Poppins_Regular, size: 14.0))
                                        .foregroundStyle(.black)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .textContentType(.URL)
                                        .tint(.black)
                                        .onChange(of: bookmarkURL) { _, newValue in
                                            linkMetadata = nil
                                            previewError = false
                                            
                                            if newValue.count > 8 {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                    findBookmarkPreview()
                                                }
                                            }
                                        }
                                    
                                    if !bookmarkURL.isEmpty {
                                        Button {
                                            bookmarkURL = ""
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
                                
                                if self.isLoading {
                                    ProgressView()
                                        .tint(AppColor.Pink)
                                }
                                
                                if let metadata = linkMetadata {
                                    BookmarkPreviewView(metadata: metadata)
                                        .padding(.top, 12)
                                }

                                if previewError {
                                    Text("Unable to load preview for this link.")
                                        .font(.custom(AppFont.Poppins_Regular, size: 13))
                                        .foregroundStyle(.gray)
                                        .padding(.top, 8)
                                }
                            }
                            .padding(.top, 30)
                            
                            Button(action: saveButtonAction) {
                                HStack {
                                    Spacer()
                                    Text("Save Bookmark")
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
                WTToastView()
                    .zIndex(9999)
            }
            .hideKeyboardOnTap()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Image("splash_logo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 97, height: 39, alignment: .center)
//            }
            ToolbarItem(placement: .topBarTrailing) {
                navigationButton(action: showBookmarkButtonAction, icon: "bookmark.fill")
            }
        }
        .navigationDestination(isPresented: $showBookmarkList) {
            BookmarkListView(store: bookmarkStore)
                .toolbar(.hidden, for: .tabBar)
        }
        .fullScreenCover(isPresented: $showPurchase) {
            
        } content: {
            NavigationStack {
                TikSavePurchaseView(isPremium: .constant(false))
            }
        }

    }
}

struct BookmarkPreviewView: View {

    let metadata: LPLinkMetadata
    @State private var previewImage: UIImage?

    var body: some View {
        HStack(spacing: 12) {

            // MARK: - Image / Placeholder
            Group {
                if let image = previewImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.25))

                        Image(systemName: "link")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.gray)
                    }
                }
            }
            .frame(width: 60, height: 60)
            .clipped()
            .cornerRadius(10)

            // MARK: - Text Content
            VStack(alignment: .leading, spacing: 4) {

                Text(metadata.title?.isEmpty == false
                     ? metadata.title!
                     : (metadata.originalURL?.absoluteString ?? ""))
                    .font(.custom(AppFont.Poppins_Medium, size: 14))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text(metadata.url?.host ?? "Preview not available")
                    .font(.custom(AppFont.Poppins_Regular, size: 12))
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding()
        .background(AppColor.Gray.opacity(0.15))
        .cornerRadius(14)
        .onAppear {
            loadImageIfNeeded()
        }
    }

    // MARK: - Async Image Loader
    private func loadImageIfNeeded() {
        guard let provider = metadata.imageProvider,
              provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }

        provider.loadObject(ofClass: UIImage.self) { object, _ in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self.previewImage = image
                }
            }
        }
    }
}

