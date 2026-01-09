//
//  ModelContainer + Custom.swift
//  WTScan
//
//  Created by iMac on 11/11/25.
//


import SwiftData
import Foundation

extension ModelContainer {
    static let shared: ModelContainer = {
        let schema = Schema([WTClipboardModel.self, WTMessageReminder.self])
        let config = ModelConfiguration()

        return try! ModelContainer(for: schema, configurations: config)
    }()
}
