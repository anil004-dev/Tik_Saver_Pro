//
//  WPGroupCategory.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import Foundation

struct WPGroupCategory: Codable, Identifiable, Hashable {
    let id: Int
    let emoji: String
    let name: String
    let names: [String]
    
    static func loadGroupCategories() -> [WPGroupCategory] {
        guard let url = Bundle.main.url(forResource: "WPGroupNames", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load file.")
            return []
        }

        do {
            return try JSONDecoder().decode([WPGroupCategory].self, from: data)
        } catch {
            print("Decoding failed:", error)
            return []
        }
    }
}
