//
//  ClipboardManager.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//


import Foundation
import SwiftData
import FamilyControls

final class ClipboardManager {
    // MARK: - Singleton
    static let shared = ClipboardManager()
    private init() {}
    
    // MARK: - Context
    var context: ModelContext? = ModelContext(ModelContainer.shared)
    
    enum ClipboardError: LocalizedError {
        case failedToSave
        case contextNotFound
        
        var info: (title: String, message: String) {
            switch self {
            case .failedToSave:
                return ("Oops!", "Unable to perform an operation.")
                
            case .contextNotFound:
                return ("Context not found!", "Swift data context not exist.")
            }
        }
    }
    
    func configure(with context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Fetch All Groups
    func fetchAllClipboards() -> [WTClipboardModel] {
        guard let context else { return [] }
        
        let descriptor = FetchDescriptor<WTClipboardModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }
    
    // MARK: - Add Group
    func addClipboard(clipboardText: String, completion: @escaping ((WTClipboardModel?, ClipboardError?) -> Void)) {
        let group = WTClipboardModel(id: UUID(), clipboardText: clipboardText)
        context?.insert(group)
        save { error in
            if let error {
                completion(nil, error)
            } else {
                completion(group, nil)
            }
        }
    }
    
    // MARK: - Delete Group
    func deleteClipboard(_ clipboard: WTClipboardModel, completion: @escaping ((ClipboardError?) -> Void)) {
        context?.delete(clipboard)
        save(completion: completion)
    }
    
    // MARK: - Helpers
    func save(completion: @escaping (ClipboardError?) -> Void) {
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
