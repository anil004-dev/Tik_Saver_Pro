//
//  Bookmark.swift
//  WTScan
//
//  Created by Anil Jadav on 13/01/26.
//

import Foundation

struct BookmarkItem: Identifiable, Codable, Equatable {
    let id: UUID
    let url: String
    let title: String?
    let createdAt: Date

    init(url: String, title: String?) {
        self.id = UUID()
        self.url = url
        self.title = title
        self.createdAt = Date()
    }
}

