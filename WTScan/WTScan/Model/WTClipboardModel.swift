//
//  WTClipboardModel.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import SwiftData
import Foundation

@Model
class WTClipboardModel {
    @Attribute(.unique) var id: UUID
    var clipboardText: String
    var createdAt: Date
    
    init(id: UUID, clipboardText: String) {
        self.id = id
        self.clipboardText = clipboardText
        self.createdAt = Date()
    }
}
