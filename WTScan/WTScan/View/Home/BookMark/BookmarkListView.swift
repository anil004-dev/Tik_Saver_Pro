//
//  BookmarkListView.swift
//  WTScan
//
//  Created by Anil Jadav on 13/01/26.
//

import SwiftUI

struct BookmarkListView: View {

    @ObservedObject var store: BookmarkStore

    var body: some View {
        ScreenContainer {
            List {
                if store.items.isEmpty {
                    Text("No bookmarks saved yet.")
                        .foregroundStyle(.white)
                }

                ForEach(store.items) { item in
                    HStack(spacing: 12) {
                        Image(systemName: "link")
                            .foregroundStyle(AppColor.Pink)
                            .frame(width: 40, height: 40)
                            .background(AppColor.Gray.opacity(0.15))
                            .cornerRadius(10)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title ?? item.url)
                                .font(.custom(AppFont.Poppins_Medium, size: 14))
                                .lineLimit(1)
                            Text(item.url)
                                .font(.custom(AppFont.Poppins_Regular, size: 12))
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(AppColor.Gray.opacity(0.12))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .cornerRadius(10.0)
                    .onTapGesture {
                        if let url = URL(string: item.url) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { store.items[$0] }.forEach(store.delete)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.inline)
    }
}
