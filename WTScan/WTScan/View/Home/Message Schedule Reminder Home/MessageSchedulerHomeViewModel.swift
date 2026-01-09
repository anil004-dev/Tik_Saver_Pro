//
//  MessageSchedulerHomeViewModel.swift
//  WTScan
//
//  Created by iMac on 24/11/25.
//

import Combine

class MessageSchedulerHomeViewModel: ObservableObject {
    
    @Published var arrReminders: [WTMessageReminder] = []
    
    func onAppear() {
        fetchReminders()
    }
    
    func fetchReminders() {
        Task {
            arrReminders = await ReminderdManager.shared.fetchAllReminders()
        }
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnCreateReminderAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let _ = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            NavigationManager.shared.push(to: .messageSchedulerReminder)
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}
