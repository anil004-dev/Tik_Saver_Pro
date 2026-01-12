//
//  MainTabView.swift
//  WTScan
//
//  Created by Anil Jadav on 10/01/26.
//

import SwiftUI

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            
            // 1️⃣ TikSave
            NavigationStack { TikSaveRootView() }
                .tabItem {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("TikSave")
                }
            // 2️⃣ Downloads
            NavigationStack { DownloadedVideosView(mode: .all) }
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Downloads")
                }
            // 3️⃣ Collection
            NavigationStack { MyVideoCollectionView(videoToAdd: nil) }
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Collection")
                }
            // 4️⃣ Settings
            NavigationStack { TikSaveSettingView() }
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(AppColor.Pink)
    }
}

