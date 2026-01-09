//
//  Utility.swift
//  WTScan
//
//  Created by iMac on 12/11/25.
//

import UIKit
import AVKit

class Utility {
    
    class func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
    
    class func formatteDate(date: Date, formate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        return formatter.string(from: date)
    }
    
    class func getAppName() -> String {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        return appName ?? "WTScan"
    }
    
    class func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return "App Version: v\(version)"
        }
        return "App Version: Unknown"
    }
    
    class func openSettings() {
        if let settingURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }
    
    class func openNotificationSettings() {
        if let settingURL = URL(string: UIApplication.openNotificationSettingsURLString), UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }
    
    class func getCameraPermissionStatus() -> AVAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return status
    }
    
    class func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    class func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            WTAlertManager.shared.showAlert(
                title: "Camera Unavailable",
                message: "Your device's camera is not available. This may be due to hardware issues or restrictions.",
            )
            completion(false)
            return
        }
        
        let permissionStatus = getCameraPermissionStatus()
        switch permissionStatus {
            
        case .authorized:
            completion(true)
        case .restricted, .denied:
            WTAlertManager.shared.showAlert(
                title: "Camera Access Needed",
                message: "To scan QR code, please enable Camera access in Settings. You can continue without it.",
                leftButtonTitle: "Cancel",
                leftButtonRole: .none,
                rightButtonTitle: "Go to Settings",
                rightButtonRole: .none,
                rightButtonAction: {
                    Utility.openSettings()
                }
            )
            completion(false)
        case .notDetermined:
            AppState.shared.isRequestingPermission = true
            requestCameraAccess { isGranted in
                if isGranted {
                    completion(true)
                } else {
                    WTAlertManager.shared.showAlert(
                        title: "Access Denied",
                        message: "Camera access was not granted. You can continue using other features or enable access later in Settings."
                    )
                    completion(false)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    AppState.shared.isRequestingPermission = false
                }
            }
        default:
            WTAlertManager.shared.showAlert(
                title: "Camera Access Needed",
                message: "To scan QR code, please enable Camera access in Settings. You can continue without it.",
                leftButtonTitle: "Cancel",
                leftButtonRole: .none,
                rightButtonTitle: "Go to Settings",
                rightButtonRole: .none,
                rightButtonAction: {
                    Utility.openSettings()
                }
            )
            completion(false)
        }
    }
    
    class func getCharactorIndex(char: Character) -> Int {
        if (char == "a") {
            return 0
        }
        if (char == "b") {
            return 1
        }
        if (char == "c") {
            return 2
        }
        if (char == "d") {
            return 3
        }
        if (char == "e") {
            return 4
        }
        if (char == "f") {
            return 5
        }
        if (char == "g") {
            return 6
        }
        if (char == "h") {
            return 7
        }
        if (char == "i") {
            return 8
        }
        if (char == "j") {
            return 9
        }
        if (char == "k") {
            return 10
        }
        if (char == "l") {
            return 11
        }
        if (char == "m") {
            return 12
        }
        if (char == "n") {
            return 13
        }
        if (char == "o") {
            return 14
        }
        if (char == "p") {
            return 15
        }
        if (char == "q") {
            return 16
        }
        if (char == "r") {
            return 17
        }
        if (char == "s") {
            return 18
        }
        if (char == "t") {
            return 19
        }
        if (char == "u") {
            return 20;
        }
        if (char == "v") {
            return 21
        }
        if (char == "w") {
            return 22
        }
        if (char == "x") {
            return 23
        }
        if (char == "y") {
            return 24;
        }
        if (char == "z") {
            return 25
        }
        if (char == "A") {
            return 26
        }
        if (char == "B") {
            return 27
        }
        if (char == "C") {
            return 28
        }
        if (char == "D") {
            return 29
        }
        if (char == "E") {
            return 30
        }
        if (char == "F") {
            return 31
        }
        if (char == "G") {
            return 32
        }
        if (char == "H") {
            return 33
        }
        if (char == "I") {
            return 34
        }
        if (char == "J") {
            return 35
        }
        if (char == "K") {
            return 36
        }
        if (char == "L") {
            return 37
        }
        if (char == "M") {
            return 38
        }
        if (char == "N") {
            return 39
        }
        if (char == "O") {
            return 40
        }
        if (char == "P") {
            return 41
        }
        if (char == "Q") {
            return 42
        }
        if (char == "R") {
            return 43;
        }
        if (char == "S") {
            return 44
        }
        if (char == "T") {
            return 45
        }
        if (char == "U") {
            return 46;
        }
        if (char == "V") {
            return 47
        }
        if (char == "W") {
            return 48
        }
        if (char == "X") {
            return 49
        }
        if (char == "Y") {
            return 50
        }
        return char == "Z" ? 51 : -1;
    }
}
