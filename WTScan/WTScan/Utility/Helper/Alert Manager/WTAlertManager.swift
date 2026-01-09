//
//  WTAlertManager.swift
//  WTScan
//
//  Created by iMac on 11/11/25.
//

import Foundation
import Combine
import SwiftUI

struct WTAlertModel: Identifiable {
    let id = UUID()
    var title: String = ""
    var message: String = ""
    var leftButtonTitle: String = "OK"
    var leftButtonRole: ButtonRole? = nil
    var rightButtonTitle: String = ""
    var rightButtonRole: ButtonRole? = nil
    var leftButtonAction: (() -> Void)? = nil
    var rightButtonAction: (() -> Void)? = nil
}

class WTAlertManager: ObservableObject {
    static let shared = WTAlertManager()
    
    @Published var showAlert: Bool = false
    @Published var alertModel: WTAlertModel = WTAlertModel()
    
    private init() {}
    
    func showAlert(title: String = "",
                   message: String = "",
                   leftButtonTitle: String = "OK",
                   leftButtonRole: ButtonRole? = nil,
                   rightButtonTitle: String = "",
                   rightButtonRole: ButtonRole? = nil,
                   leftButtonAction: (() -> Void)? = nil,
                   rightButtonAction: (() -> Void)? = nil
    ) {
        var alertModel = WTAlertModel()
        alertModel.title = title
        alertModel.message = message
        alertModel.leftButtonTitle = leftButtonTitle
        alertModel.leftButtonRole = leftButtonRole
        alertModel.rightButtonTitle = rightButtonTitle
        alertModel.rightButtonRole = rightButtonRole
        alertModel.leftButtonAction = leftButtonAction
        alertModel.rightButtonAction = rightButtonAction
        
        self.alertModel = alertModel
        self.showAlert = true
    }
    
    func dismiss() {
        showAlert = false
    }
}
