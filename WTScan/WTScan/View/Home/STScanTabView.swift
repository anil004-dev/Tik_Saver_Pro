//
//  STScanTabView.swift
//  WTScan
//
//  Created by Anil Jadav on 13/01/26.
//

import SwiftUI

struct STScanTabView: View {

    @StateObject var navigationManager: NavigationManager = .shared
    @ObservedObject var appState: AppState

    var body: some View {
        TabView {

            // 🔖 Bookmarks
            NavigationStack {
                BookmarkView()
            }
            .tabItem {
                Image(systemName: "bookmark.fill")
                Text("Bookmarks")
            }

            // 🧰 Tools / Home
            NavigationStack(path: $navigationManager.path) {
                HomeView(viewModel: appState.homeViewModel)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        NavigationRouter.destinationView(for: destination)
                    }
            }
            .tabItem {
                Image(systemName: "square.grid.2x2.fill")
                Text("Tools")
            }
        }
        .tint(AppColor.Pink)
    }
}
