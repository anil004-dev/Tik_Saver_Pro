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
                    Image("ic_home")
                }
            // 2️⃣ Downloads
            NavigationStack { DownloadedVideosView(mode: .all) }
                .tabItem {
                    Image("ic_download")
                }
            // 3️⃣ Collection
            NavigationStack { MyVideoCollectionView(videoToAdd: nil) }
                .tabItem {
                    Image("ic_collection_tab")
                }
            // 4️⃣ Settings
            NavigationStack { TikSaveSettingView() }
                .tabItem {
                    Image("ic_setting")
                }
        }
        .accentColor(AppColor.Pink)
    }
}

