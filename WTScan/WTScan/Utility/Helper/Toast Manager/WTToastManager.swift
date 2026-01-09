//
//  WTToastManager.swift
//  WTScan
//
//  Created by IMac on 13/11/25.
//


import Foundation
import Combine

final class WTToastManager: ObservableObject {
    static let shared = WTToastManager()
    
    @Published var message: String? = nil
    private var hideTask: Task<Void, Never>? = nil

    private init() {}

    func show(_ message: String, duration: TimeInterval = 2.5) {
        hideTask?.cancel()
        
        // If same message is already shown, reset it briefly to re-trigger
        if self.message == message {
            self.message = nil // Dismiss the current toast
            
            // Delay before showing again so SwiftUI can animate it properly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.setMessage(message, duration: duration)
            }
        } else {
            setMessage(message, duration: duration)
        }
    }

    
    private func setMessage(_ message: String, duration: TimeInterval) {
        self.message = message
        
        hideTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            await MainActor.run {
                self.message = nil
            }
        }
    }

}
