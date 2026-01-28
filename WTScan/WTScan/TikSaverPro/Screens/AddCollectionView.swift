//
//  AddCollectionView.swift
//  WTScan
//
//  Created by Anil Jadav on 10/01/26.
//

import SwiftUI

struct AddCollectionView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var entitlementManager: EntitlementManager
    @State private var name: String = ""
    @State private var errorMessage: String?

    let onCreate: (String) -> Void

    var body: some View {
        ScreenContainer {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Collection Name")
                            .font(.custom(AppFont.Poppins_SemiBold, size: 16))
                            .foregroundColor(.white)
                        TextField("", text: $name, prompt: Text("e.g. Travel, Picnic, Business").foregroundStyle(.gray))
                            .font(.custom(AppFont.Poppins_Regular, size: 14))
                            .padding(12)
                            .background(.white)
                            .cornerRadius(14)
                            .foregroundColor(.black)
                            .autocapitalization(.words)
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.custom(AppFont.Poppins_Regular, size: 13))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.leading)
                    }

                    Button {
                        createCollection()
                    } label: {
                        Text("Create Collection")
                            .font(.custom(AppFont.Poppins_SemiBold, size: 16))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                    }
                    .buttonStyle(.plain)
                    .background(
                        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? Color.gray
                        : AppColor.Pink
                    )
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .cornerRadius(14.0)
                }
                .padding()
                .background(AppColor.Gray.opacity(0.12))
                .cornerRadius(20.0)
                Spacer()
            }
            .padding()
            
        }
        .navigationTitle("New Collection")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }

    // MARK: - Create Logic

    private func createCollection() {
        if entitlementManager.hasPro {
            DispatchQueue.main.async {
                self.applyCreate()
            }
        }
        else {
            InterstitialAdManager.shared.didFinishedAd = {
                InterstitialAdManager.shared.didFinishedAd = nil
                DispatchQueue.main.async {
                    self.applyCreate()
                }
            }
            InterstitialAdManager.shared.showAd()
        }
        
        
    }
    
    func applyCreate() {
        let trimmedName = name
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            errorMessage = "Collection name cannot be empty."
            return
        }

        let existing = CollectionStore.shared
            .load()
            .contains { $0.name.lowercased() == trimmedName.lowercased() }

        guard !existing else {
            errorMessage = "A collection with this name already exists."
            return
        }

        do {
            try CollectionStore.shared.create(name: trimmedName)
            onCreate(trimmedName)
            dismiss()
        } catch {
            errorMessage = "Failed to create collection. Please try again."
        }
    }
}
