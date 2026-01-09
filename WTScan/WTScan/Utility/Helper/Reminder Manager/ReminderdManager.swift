//
//  ReminderdManager.swift
//  WTScan
//
//  Created by iMac on 24/11/25.
//


import Foundation
import SwiftData
import FamilyControls
import UserNotifications

final class ReminderdManager {
    // MARK: - Singleton
    static let shared = ReminderdManager()
    private init() {}
    
    // MARK: - Context
    var context: ModelContext? = ModelContext(ModelContainer.shared)
    
    enum ReminderError: LocalizedError {
        case failedToSave
        case contextNotFound
        
        var info: (title: String, message: String) {
            switch self {
            case .failedToSave:
                return ("Oops!", "Unable to perform an operation")
                
            case .contextNotFound:
                return ("Context not found!", "Swift data context not exist")
            }
        }
    }
    
    func configure(with context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Fetch All Groups
    func fetchAllReminders() async -> [WTMessageReminder] {
        guard let context else { return [] }
        
        let descriptor = FetchDescriptor<WTMessageReminder>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        let arrReminders = (try? context.fetch(descriptor)) ?? []
        let arrPendingNotifications = await NotificationManager.shared.fetchPending()
        let arrPendingIds = Set(arrPendingNotifications.map { $0.identifier })
        var arrFinalReminders: [WTMessageReminder] = []
        
        for reminder in arrReminders {
            let id = reminder.id.uuidString
            
            // Delete reminders whose notifications no longer exist (already fired)
            if !arrPendingIds.contains(id) {
                deleteReminder(reminder, completion: {_ in})
            } else {
                arrFinalReminders.append(reminder)
            }
        }

        return arrFinalReminders
    }
    
    // MARK: - Add Group
    func addReminder(reminder: WTMessageReminder) async throws {
        try await NotificationManager.shared.scheduleNotification(id: reminder.id.uuidString, title: Utility.getAppName(), body: reminder.messageText, date: reminder.scheduleDate)
        context?.insert(reminder)
        try context?.save()
    }
    
    // MARK: - Delete Group
    func deleteReminder(_ reminder: WTMessageReminder, completion: @escaping ((ReminderError?) -> Void)) {
        NotificationManager.shared.remove(id: reminder.id.uuidString)
        context?.delete(reminder)
        save(completion: completion)
    }
    
    // MARK: - Helpers
    func save(completion: @escaping (ReminderError?) -> Void) {
        guard let context = context else {
            completion(.contextNotFound)
            return
        }
        
        do {
            try context.save()
            completion(nil)
        }
        catch {
            print("❌ SwiftData Save Failed: \(error)")
            completion(.failedToSave)
        }
    }
 }
