//
//  WTTextField.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import SwiftUI

struct WTTextField: View {
    var placeHolder: String = ""
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var font: Font = .system(size: 18, weight: .semibold, design: .default)
    
    var body: some View {
        VStack(alignment: .center, spacing: 7) {
            Spacer(minLength: 0)
            ZStack {
                if text.isEmpty {
                    WTText(title: placeHolder, color: .gray, font: .system(size: 16, weight: .regular, design: .default), alignment: .leading)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                TextField("", text: $text)
                    .font(font)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                    .keyboardType(keyboardType)
                    .tint(.black)
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
        }
        .background {
            RoundedRectangle(cornerRadius: 17)
                .fill(Color.lightGreenTextfield)
                .stroke(Color.lightBorderGrey, lineWidth: 1)
                .padding(1)
                .frame(maxHeight: .infinity)
        }
        .ignoresSafeArea(.keyboard)
    }
}
