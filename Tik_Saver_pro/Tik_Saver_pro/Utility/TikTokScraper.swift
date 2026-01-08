//
//  TikTokScraper.swift
//  TikSavePro
//
//  Created by Bhautik Patoliya on 06/01/26.
//


import Foundation

final class TikTokScraper {

    static let shared = TikTokScraper()

    func scrapePost(from url: URL) async throws -> TikTokPost {
        let html = try await HTTPClient.shared.get(url)
        let json = try HTMLParser.extractUniversalJSON(from: html)
        return try parsePost(jsonData: json)
    }

    func scrapePosts(from urls: [URL]) async -> [TikTokPost] {
        await withTaskGroup(of: TikTokPost?.self) { group in
            for url in urls {
                group.addTask {
                    try? await self.scrapePost(from: url)
                }
            }

            var results: [TikTokPost] = []

            for await post in group {
                if let post {
                    results.append(post)
                }
            }

            return results
        }
    }

    private func parsePost(jsonData: Data) throws -> TikTokPost {
        
        guard
            let root = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
            let defaultScope = root["__DEFAULT_SCOPE__"] as? [String: Any],
            let videoDetail = defaultScope["webapp.video-detail"] as? [String: Any],
            let itemInfo = videoDetail["itemInfo"] as? [String: Any],
            let itemStruct = itemInfo["itemStruct"] as? [String: Any]
        else {
            throw NSError(domain: "INVALID_STRUCTURE", code: -2)
        }
        
        let cleaned: [String: Any] = [
            "id": itemStruct["id"] ?? "",
            "desc": itemStruct["desc"] ?? "",
            "createTime": itemStruct["createTime"] ?? "",
            "video": itemStruct["video"] ?? [:],
            "author": itemStruct["author"] ?? [:],
            "stats": itemStruct["stats"] ?? [:],
            "locationCreated": itemStruct["locationCreated"] ?? ""
        ]
        
        let normalized = try JSONSerialization.data(withJSONObject: cleaned)
        return try JSONDecoder().decode(TikTokPost.self, from: normalized)
    }



}
