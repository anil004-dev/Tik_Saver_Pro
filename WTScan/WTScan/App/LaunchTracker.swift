//
//  LaunchTracker.swift
//  WTScan
//
//  Created by iMac on 26/11/25.
//


final class LaunchTracker {
    static let shared = LaunchTracker()
    private init() {}
    
    var hasLaunchedOnce = false
    var splashCompleted = false
}
