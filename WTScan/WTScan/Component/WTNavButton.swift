//
//  WTNavButton.swift
//  WTScan
//
//  Created by iMac on 12/11/25.
//

import SwiftUI

struct WTNavButton: View {
    let imageName: String
    let fontWeight: Font.Weight
    let iconColor: Color
    let iconSize: CGSize
    let backgroundColor: Color
    
    var body: some View {
        if #available(iOS 26.0, *) {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .fontWeight(fontWeight)
                    .frame(width: iconSize.width * 1.2, height: iconSize.height * 1.2)
            }
        } else {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .fontWeight(fontWeight)
                    .foregroundStyle(iconColor)
                    .frame(width: iconSize.width, height: iconSize.height)
            }
            .frame(width: 24, height: 24)
            .background {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 36, height: 36)
            }
        }
    }
}

struct WTNavHomeButton: View {
    let imageName: String
    let fontWeight: Font.Weight
    let iconColor: Color
    let iconSize: CGSize
    let backgroundColor: Color
    
    var body: some View {
        if #available(iOS 26.0, *) {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .fontWeight(fontWeight)
                    .foregroundStyle(.white)
                    .frame(width: iconSize.width * 1.1, height: iconSize.height * 1.1)
            }
        } else {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .fontWeight(fontWeight)
                    .foregroundStyle(iconColor)
                    .frame(width: iconSize.width, height: iconSize.height)
            }
            .frame(width: 30, height: 30)
            .background {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 30, height: 30)
            }
            .background {
                Circle()
                    .fill(.white.opacity(0.36))
                    .frame(width: 42, height: 42)
            }
        }
    }
}
