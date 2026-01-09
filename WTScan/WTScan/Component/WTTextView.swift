//
//  WTTextView.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//


import SwiftUI

struct WTTextView: View {
    var placeHolder: String = ""
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                if text.isEmpty {
                    VStack(alignment: .leading, spacing: 0) {
                        WTText(title: placeHolder, color: .init(hex: "6A6C6C"), font: .system(size: 16, weight: .regular, design: .default), alignment: .leading)
                            .padding(.horizontal, 18)
                            .padding(.top, 22)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                    }
                }
                
                TextEditor(text: $text)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .foregroundStyle(.black)
                    .tint(.black)
                    .keyboardType(keyboardType)
                    .padding(14)
                    .scrollContentBackground(.hidden)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 17)
                .fill(Color.lightGreenTextfield)
                .stroke(Color.lightBorderGrey, lineWidth: 1)
                .padding(1)
                .frame(maxHeight: .infinity)
        }
    }
}
