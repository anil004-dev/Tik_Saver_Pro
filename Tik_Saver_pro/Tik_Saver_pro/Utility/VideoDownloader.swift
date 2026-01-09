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
        
        
        // MARK: - Documents/Videos directory
        let fileManager = FileManager.default
        let documentsURL = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let videosDirectory = documentsURL.appendingPathComponent("App_Media", isDirectory: true)
        // Create folder if needed
        if !fileManager.fileExists(atPath: videosDirectory.path) {
            try fileManager.createDirectory(
                at: videosDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        // MARK: - Fixed file name (replace previous)
        let videoFileURL = videosDirectory.appendingPathComponent("app_video.mp4")
        // Remove existing file if present
        if fileManager.fileExists(atPath: videoFileURL.path) {
            try fileManager.removeItem(at: videoFileURL)
        }
        // Save new video
        try data.write(to: videoFileURL, options: .atomic)
        print("✅ Video saved at:", videoFileURL)
        return videoFileURL
    }
}
