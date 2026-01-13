//
//  Color + Custom.swift
//  WTScan
//
//  Created by iMac on 11/11/25.
//


import SwiftUI

extension Color {
    
    /// Create a Color from RGB values (0-255) and optional alpha
    init(r: Double, g: Double, b: Double, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            opacity: opacity
        )
    }
    
    /// Create a Color from a Hex string (e.g. "#FF0000" or "FF0000").
    /// Returns `.white` if invalid.
    init(hex: String, opacity: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self = .white
            return
        }
        
        if hexSanitized.count == 6 {
            let r = Double((rgb & 0xFF0000) >> 16)
            let g = Double((rgb & 0x00FF00) >> 8)
            let b = Double(rgb & 0x0000FF)
            self.init(r: r, g: g, b: b, opacity: opacity)
        } else {
            self = .white
        }
    }
}

//extension Color {
//    static var btnDarkGreen: Color { AppState.shared.isLive ? .btnDarkGreenMain : Color(hex: "6F57FF") }
//    static var greenBg: Color { AppState.shared.isLive ? .greenBgMain : Color(hex: "D2CBFF") }
//    static var lightGreenBg: Color { AppState.shared.isLive ? .lightGreenBgMain : Color(hex: "ECF2FF") }
//    static var lightBorderGrey: Color { AppState.shared.isLive ? .lightBorderGreyMain : Color(hex: "BFBFBF") }
//    static var lightGreenTextfield: Color { AppState.shared.isLive ? .lightGreenTextfieldMain : Color(hex: "F5F8FF") }
//    static var navBackground: Color { AppState.shared.isLive ? .navBackgroundMain : Color(hex: "0E8A6D") }
//    static var navIcon: Color { AppState.shared.isLive ? .navIconMain : Color(hex: "6F57FF") }
//}

extension LinearGradient {
//    static var wtGreen: LinearGradient {
//        LinearGradient(
//            colors: AppState.shared.isLive ?
//            [
//                Color(hex: "#14CD10"),
//                Color(hex: "#07A020"),
//                Color(hex: "#07A020"),
//                Color(hex: "#07A020"),
//                Color(hex: "#07A020"),
//                Color(hex: "#07A020"),
//                Color(hex: "#07A020")
//            ] :
//                [
//                    Color(hex: "#10A3FF"),
//                    Color(hex: "#6F57FF"),
//                    Color(hex: "#6F57FF"),
//                    Color(hex: "#6F57FF"),
//                    Color(hex: "#6F57FF"),
//                    Color(hex: "#6F57FF"),
//                    Color(hex: "#6F57FF")
//                ],
//            startPoint: .top,
//            endPoint: .bottom
//        )
//    }
    
//    static var optionBg: LinearGradient {
//        LinearGradient(
//            colors: AppState.shared.isLive ?
//            [
//                Color(hex: "#14CD10"),
//                Color(hex: "#07A020")
//            ] :
//                [
//                    Color(hex: "10A3FF"),
//                    Color(hex: "6F57FF")
//                ],
//            startPoint: .top,
//            endPoint: .bottom
//        )
//    }
    
    static var wtGreen: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                AppColor.Pink, // Color 1
                AppColor.Pink, // Color 2
                AppColor.Pink  // Color 3
            ]),
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
    
    static var optionBg: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                // Bottom-left (dark greenish black)
                .init(
                    color: Color(
                        red: 31.0 / 255.0,
                        green: 41.0 / 255.0,
                        blue: 41.0 / 255.0
                    ),
                    location: 0.0
                ),

                // Center (deep dark gray)
                .init(
                    color: Color(
                        red: 24.0 / 255.0,
                        green: 24.0 / 255.0,
                        blue: 24.0 / 255.0
                    ),
                    location: 0.52
                ),

                // Top-right (purple)
                .init(
                    color: Color(
                        red: 57.0 / 255.0,
                        green: 28.0 / 255.0,
                        blue: 54.0 / 255.0
                    ),
                    location: 1.0
                )
            ]),
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }



}

extension Color {
    static var btnDarkGreen: Color { AppState.shared.isLive ? .btnDarkGreenMain : Color(hex: "6F57FF") }
    static var greenBg: Color { Color.black }
    static var lightGreenBg: Color { Color.black }
    static var lightBorderGrey: Color { AppState.shared.isLive ? .lightBorderGreyMain : Color(hex: "BFBFBF") }
    static var lightGreenTextfield: Color { AppState.shared.isLive ? .lightGreenTextfieldMain : Color(hex: "F5F8FF") }
    static var navBackground: Color { AppState.shared.isLive ? .navBackgroundMain : Color(hex: "0E8A6D") }
    static var navIcon: Color { AppState.shared.isLive ? .navIconMain : Color(hex: "6F57FF") }
}
