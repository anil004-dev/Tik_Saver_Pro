//
//  VideoDownloader.swift
//  TikSavePro
//
//  Created by Bhautik Patoliya on 06/01/26.
//  Updated to support downloadAddr → playAddr fallback
//

import Foundation

final class VideoDownloader {

    static let shared = VideoDownloader()

    /// Public API — pass the whole Video object
    func downloadVideo(from video: Video) async throws -> URL {
        let urlString: String
        if !video.playAddr.isEmpty {
            urlString = video.playAddr
            print("⬇️ Using playAddr")
        } else {
            urlString = video.downloadAddr
            print("⬇️ playAddr missing, using downloadAddr")
        }
        return try await downloadVideo(from: urlString)
    }

    /// Internal downloader
    private func downloadVideo(from urlString: String) async throws -> URL {
        guard let url = URL(string: urlString), !urlString.isEmpty else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // 🔑 Required headers for TikTok CDN
        request.setValue(
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36",
            forHTTPHeaderField: "User-Agent"
        )
        request.setValue("https://www.tiktok.com/", forHTTPHeaderField: "Referer")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard http.statusCode == 200 else {
            print("❌ HTTP Status:", http.statusCode)
            print("📦 Headers:", http.allHeaderFields)
            throw URLError(.badServerResponse)
        }
        let fileURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mp4")
        try data.write(to: fileURL)
        print("✅ Video saved at:", fileURL)
        return fileURL
    }
}
