//
//  BookmarkStore.swift
//  WTScan
//
//  Created by Anil Jadav on 13/01/26.
//

import Foundation
import Combine

final class BookmarkStore: ObservableObject {

    @Published private(set) var items: [BookmarkItem] = []

    private let key = "saved_bookmarks"

    init() {
        load()
    }

    func add(_ item: BookmarkItem) {
        if !items.contains(where: { $0.url == item.url }) {
            items.insert(item, at: 0)
            save()
        }
    }

    func delete(_ item: BookmarkItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([BookmarkItem].self, from: data)
        else { return }

        items = decoded
    }
}
