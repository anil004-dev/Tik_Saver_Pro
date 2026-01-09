//
//  AppBackgroundView.swift
//  Tik_Saver_pro
//
//  Created by Anil Jadav on 08/01/26.
//

import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        Image("screen_bg")
            .resizable()
            //.scaledToFill()
            .ignoresSafeArea()
    }
}

struct ScreenContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            AppBackgroundView()
            content
        }
    }
}
