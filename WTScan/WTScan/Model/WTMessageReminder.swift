//
//  WTMessageReminder.swift
//  WTScan
//
//  Created by iMac on 24/11/25.
//

import SwiftData
import Foundation

@Model
class WTMessageReminder {
    @Attribute(.unique) var id: UUID
    var messageText: String
    var scheduleDate: Date
    var createdAt: Date
    
    init(id: UUID, messageText: String, scheduleDate: Date) {
        self.id = id
        self.messageText = messageText
        self.scheduleDate = scheduleDate
        self.createdAt = Date()
    }
}
