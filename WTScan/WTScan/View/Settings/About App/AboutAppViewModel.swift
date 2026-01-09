//
//  AboutAppViewModel.swift
//  WTScan
//
//  Created by iMac on 01/12/25.
//

import Combine

class AboutAppViewModel: ObservableObject {
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
}
