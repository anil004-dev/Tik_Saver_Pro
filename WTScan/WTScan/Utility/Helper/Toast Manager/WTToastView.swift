//
//  WTToastView.swift
//  WTScan
//
//  Created by IMac on 13/11/25.
//

import SwiftUI

struct WTToastView: View {
    @ObservedObject var toastManager: WTToastManager = .shared

    var body: some View {
        if let message = toastManager.message {
            VStack {
                Spacer()
                
                WTText(title: message, color: .white, font: .system(size: 16, weight: .regular, design: .default), alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .lineSpacing(4)
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(10)
                    .padding(.bottom, 0)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: toastManager.message)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
        }
    }
}
