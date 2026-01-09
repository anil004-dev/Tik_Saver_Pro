//
//  WTNetworkMonitor.swift
//  WTScan
//
//  Created by iMac on 26/11/25.
//


import Foundation
import Network
import Combine

final class WTNetworkMonitor: ObservableObject {
    static let shared = WTNetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isInternetAvailable: Bool = true
    @Published var internetConnectionChanged: ((_ isConnected: Bool) -> Void)?
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let isConnected = path.status == .satisfied
                self?.isInternetAvailable = isConnected
                self?.internetConnectionChanged?(isConnected)
            }
        }
        monitor.start(queue: queue)
    }
}
