//
//  VideoDownloader.swift
//  TikSavePro
//
//  Created by Bhautik Patoliya on 06/01/26.
//  Updated to support downloadAddr → playAddr fallback
//

import Foundation
import AVFoundation
import UIKit

final class VideoDownloader {
    
    static let shared = VideoDownloader()
    
    /// Public API — pass the whole Video object
//    func downloadVideo(from video: Video) async throws -> DownloadedVideo {
//        let urlString: String
//        if !video.playAddr.isEmpty {
//            urlString = video.playAddr
//            print("⬇️ Using playAddr")
//        } else {
//            urlString = video.downloadAddr
//            print("⬇️ playAddr missing, using downloadAddr")
//        }
//        return try await downloadVideoAPI(from: urlString)
//    }
    
    /// Internal downloader
    //    private func downloadVideo(from urlString: String) async throws -> URL {
    //        guard let url = URL(string: urlString), !urlString.isEmpty else {
    //            throw URLError(.badURL)
    //        }
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "GET"
    //        // 🔑 Required headers for TikTok CDN
    //        request.setValue(
    //            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36",
    //            forHTTPHeaderField: "User-Agent"
    //        )
    //        request.setValue("https://www.tiktok.com/", forHTTPHeaderField: "Referer")
    //        request.setValue("*/*", forHTTPHeaderField: "Accept")
    //        let (data, response) = try await URLSession.shared.data(for: request)
    //        guard let http = response as? HTTPURLResponse else {
    //            throw URLError(.badServerResponse)
    //        }
    //        guard http.statusCode == 200 else {
    //            print("❌ HTTP Status:", http.statusCode)
    //            print("📦 Headers:", http.allHeaderFields)
    //            throw URLError(.badServerResponse)
    //        }
    //
    //
    //        // MARK: - Documents/Videos directory
    //        let fileManager = FileManager.default
    //        let documentsURL = try fileManager.url(
    //            for: .documentDirectory,
    //            in: .userDomainMask,
    //            appropriateFor: nil,
    //            create: true
    //        )
    //        let videosDirectory = documentsURL.appendingPathComponent("App_Media", isDirectory: true)
    //        // Create folder if needed
    //        if !fileManager.fileExists(atPath: videosDirectory.path) {
    //            try fileManager.createDirectory(
    //                at: videosDirectory,
    //                withIntermediateDirectories: true,
    //                attributes: nil
    //            )
    //        }
    //        // MARK: - Fixed file name (replace previous)
    //        let videoFileURL = videosDirectory.appendingPathComponent("app_video.mp4")
    //        // Remove existing file if present
    //        if fileManager.fileExists(atPath: videoFileURL.path) {
    //            try fileManager.removeItem(at: videoFileURL)
    //        }
    //        // Save new video
    //        try data.write(to: videoFileURL, options: .atomic)
    //        print("✅ Video saved at:", videoFileURL)
    //        return videoFileURL
    //    }
    
    func downloadVideo(from video: Video) async throws -> DownloadedVideo {

        let urlString = video.playAddr.isEmpty ? video.downloadAddr : video.playAddr
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.setValue(
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
            forHTTPHeaderField: "User-Agent"
        )
        request.setValue("https://www.tiktok.com/", forHTTPHeaderField: "Referer")

        let (data, _) = try await URLSession.shared.data(for: request)

        try MediaDirectory.ensureDirectories()

        let timestamp = Int(Date().timeIntervalSince1970)
        let baseName = "video_\(timestamp)"

        let videoFileName = "\(baseName).mp4"
        let thumbnailFileName = "\(baseName).jpg"

        let videoURL = MediaDirectory.videos.appendingPathComponent(videoFileName)
        try data.write(to: videoURL, options: .atomic)

        try generateThumbnail(
            from: videoURL,
            saveTo: MediaDirectory.thumbnails.appendingPathComponent(thumbnailFileName)
        )

        let item = DownloadedVideo(
            id: UUID(),
            videoFileName: videoFileName,
            thumbnailFileName: thumbnailFileName,
            createdAt: Date()
        )

        DownloadStore.shared.save(item)
        return item
    }

    
    private func generateThumbnail(from videoURL: URL, saveTo url: URL) throws {
        let asset = AVAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 0.5, preferredTimescale: 600)
        let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
        
        let uiImage = UIImage(cgImage: cgImage)
        let data = uiImage.jpegData(compressionQuality: 0.8)!
        
        try data.write(to: url)
    }
    
}

enum MediaDirectory {

    static var base: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("App_Media", isDirectory: true)
    }

    static var videos: URL {
        base.appendingPathComponent("Videos", isDirectory: true)
    }

    static var thumbnails: URL {
        base.appendingPathComponent("Thumbnails", isDirectory: true)
    }

    static func ensureDirectories() throws {
        let fm = FileManager.default
        try fm.createDirectory(at: videos, withIntermediateDirectories: true)
        try fm.createDirectory(at: thumbnails, withIntermediateDirectories: true)
    }
}

enum CollectionDirectory {
    static var base: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("App_Collections", isDirectory: true)
    }

    static func ensureBase() throws {
        try FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
    }

    static func url(for name: String) -> URL {
        base.appendingPathComponent(name, isDirectory: true)
    }
}


struct DownloadedVideo: Identifiable, Codable {
    let id: UUID
    let videoFileName: String
    let thumbnailFileName: String
    let createdAt: Date
}

extension DownloadedVideo {
    var videoURL: URL {
        MediaDirectory.videos.appendingPathComponent(videoFileName)
    }

    var thumbnailURL: URL {
        MediaDirectory.thumbnails.appendingPathComponent(thumbnailFileName)
    }
}

struct VideoCollection: Identifiable, Codable {
    let id: UUID
    let name: String
    let createdAt: Date
}

struct CollectionVideoRef: Identifiable, Codable {
    let id: UUID
    let videoFileName: String
    let thumbnailFileName: String
    let addedAt: Date
}


final class DownloadStore {

    static let shared = DownloadStore()
    private let fileURL: URL

    private init() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = docs.appendingPathComponent("downloads.json")
    }

    func save(_ item: DownloadedVideo) {
        var items = load()
        items.insert(item, at: 0)
        write(items)
    }

    func load() -> [DownloadedVideo] {
        guard
            let data = try? Data(contentsOf: fileURL),
            let items = try? JSONDecoder().decode([DownloadedVideo].self, from: data)
        else { return [] }
        return items
    }

    private func write(_ items: [DownloadedVideo]) {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL)
        }
    }
    
    func delete(_ item: DownloadedVideo) {
        var items = load()
        items.removeAll { $0.id == item.id }
        write(items)
        VideoFileManager.deleteIfUnused(
            videoFileName: item.videoFileName,
            thumbnailFileName: item.thumbnailFileName
        )
    }
}

final class CollectionStore {

    static let shared = CollectionStore()
    private let collectionsFile: URL

    private init() {
        collectionsFile = CollectionDirectory.base.appendingPathComponent("collections.json")
        try? CollectionDirectory.ensureBase()
    }

    // MARK: - Collections

    func load() -> [VideoCollection] {
        guard
            let data = try? Data(contentsOf: collectionsFile),
            let items = try? JSONDecoder().decode([VideoCollection].self, from: data)
        else { return [] }
        return items
    }

    func create(name: String) throws {
        var items = load()

        guard !items.contains(where: { $0.name.lowercased() == name.lowercased() }) else {
            throw NSError(domain: "Collection", code: 1)
        }

        let dir = CollectionDirectory.url(for: name)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)

        items.append(
            VideoCollection(id: UUID(), name: name, createdAt: Date())
        )

        save(items)
    }

    func delete(_ collection: VideoCollection) {
        var items = load()
        items.removeAll { $0.id == collection.id }
        save(items)
        
        let dir = CollectionDirectory.url(for: collection.name)
        try? FileManager.default.removeItem(at: dir)
    }
    // MARK: - Videos

    func loadVideos(in collection: VideoCollection) -> [CollectionVideoRef] {
        let fileURL = CollectionDirectory
            .url(for: collection.name)
            .appendingPathComponent("videos.json")

        guard
            let data = try? Data(contentsOf: fileURL),
            let items = try? JSONDecoder().decode([CollectionVideoRef].self, from: data)
        else { return [] }

        return items
    }

    func addVideo(_ video: DownloadedVideo, to collection: VideoCollection) throws {
        let fileURL = CollectionDirectory
            .url(for: collection.name)
            .appendingPathComponent("videos.json")

        var items = loadVideos(in: collection)

        if items.contains(where: { $0.videoFileName == video.videoFileName }) {
            return
        }

        items.append(
            CollectionVideoRef(
                id: UUID(),
                videoFileName: video.videoFileName,
                thumbnailFileName: video.thumbnailFileName,
                addedAt: Date()
            )
        )

        let data = try JSONEncoder().encode(items)
        try data.write(to: fileURL)
    }

    func removeVideo(
        _ video: CollectionVideoRef,
        from collection: VideoCollection
    ) {
        let fileURL = CollectionDirectory
            .url(for: collection.name)
            .appendingPathComponent("videos.json")

        var items = loadVideos(in: collection)
        items.removeAll { $0.videoFileName == video.videoFileName }

        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL)
        }

        VideoFileManager.deleteIfUnused(
            videoFileName: video.videoFileName,
            thumbnailFileName: video.thumbnailFileName
        )
    }

    private func save(_ items: [VideoCollection]) {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: collectionsFile)
        }
    }
}

enum VideoOwnershipChecker {

    static func isReferenced(videoFileName: String) -> Bool {

        // Downloads
        if DownloadStore.shared.load()
            .contains(where: { $0.videoFileName == videoFileName }) {
            return true
        }

        // Collections
        for collection in CollectionStore.shared.load() {
            let videos = CollectionStore.shared.loadVideos(in: collection)
            if videos.contains(where: { $0.videoFileName == videoFileName }) {
                return true
            }
        }

        return false
    }
}

enum VideoFileManager {

    static func deleteIfUnused(
        videoFileName: String,
        thumbnailFileName: String
    ) {
        guard !VideoOwnershipChecker.isReferenced(videoFileName: videoFileName) else {
            return
        }

        let videoURL = MediaDirectory.videos.appendingPathComponent(videoFileName)
        let thumbURL = MediaDirectory.thumbnails.appendingPathComponent(thumbnailFileName)

        try? FileManager.default.removeItem(at: videoURL)
        try? FileManager.default.removeItem(at: thumbURL)
    }
}
