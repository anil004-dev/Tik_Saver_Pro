//
//  WTCheckBox.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import SwiftUI

struct WTCheckBox: View {
    @Binding var isSelected: Bool
    let title: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .center, spacing: 0) {
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(AppColor.Pink)
                    .frame(width: 14, height: 14)
                    .opacity(isSelected ? 1 : 0)
                    .transition(.opacity)
            }
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.clear)
                    .stroke(Color.white, lineWidth: 1)
                    .padding(1)
                    .frame(width: 28, height: 28)
            }
            .frame(width: 28, height: 28)
            
            WTText(title: title, color: .white, font: .system(size: 16, weight: .medium, design: .default), alignment: .leading)
        }
        .background(Color.clear)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}
