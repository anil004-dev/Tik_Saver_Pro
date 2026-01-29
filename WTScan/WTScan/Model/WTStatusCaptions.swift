//
//  WTStatusCaptions.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import Foundation

struct WTStatusCaptions: Codable {
    let categories: [WTCaptionCategory]
}

struct WTCaptionCategory: Codable, Identifiable, Hashable {
  
    let id: Int
    let name: String
    let imageName: String
    let quotes: [WTCaptionItem]
    
    static func loadCaptionsCategory() -> [WTCaptionCategory] {
        guard let url = Bundle.main.url(forResource: "StatusCaptions", withExtension: "json") else {
            print("JSON not found")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let library = try JSONDecoder().decode(WTStatusCaptions.self, from: data)
            return library.categories
        } catch {
            print("JSON decode error:", error)
            return []
        }
    }
    
    static func == (lhs: WTCaptionCategory, rhs: WTCaptionCategory) -> Bool {
        return lhs.id == rhs.id
    }
}

struct WTCaptionItem: Codable, Hashable {
    let text: String
    let author: String
}

