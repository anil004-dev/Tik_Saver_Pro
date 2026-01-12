//
//  TikSaveWebViewContainer.swift
//  WTScan
//
//  Created by Anil Jadav on 12/01/26.
//

import UIKit
import WebKit
import SwiftUI

struct TikSaveWebViewContainer: View {
    let url: URL
    let title: String
    @Environment(\.dismiss) private var dismiss

    @State private var progress: Double = 0.2
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {

                TikSaveWebView(
                    url: url,
                    progress: $progress,
                    isLoading: $isLoading
                )

                if isLoading {
                    ProgressView(value: progress)
                        .progressViewStyle(.linear)
                        .tint(AppColor.Pink)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // NAV BAR RIGHT BUTTON
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark")
                            .font(.footnote)
                    }
                }
            }
        }
    }
}

struct TikSaveWebView: UIViewRepresentable {

    let url: URL
    @Binding var progress: Double
    @Binding var isLoading: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        webView.addObserver(
            context.coordinator,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )

        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.removeObserver(
            coordinator,
            forKeyPath: #keyPath(WKWebView.estimatedProgress)
        )
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, WKNavigationDelegate {
        let parent: TikSaveWebView

        init(_ parent: TikSaveWebView) {
            self.parent = parent
        }

        override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey : Any]?,
            context: UnsafeMutableRawPointer?
        ) {
            if keyPath == "estimatedProgress",
               let webView = object as? WKWebView {

                parent.progress = webView.estimatedProgress
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
