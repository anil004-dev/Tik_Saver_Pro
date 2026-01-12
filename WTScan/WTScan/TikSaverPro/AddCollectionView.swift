//
//  AddCollectionView.swift
//  WTScan
//
//  Created by Anil Jadav on 10/01/26.
//

import SwiftUI

struct AddCollectionView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var errorMessage: String?

    let onCreate: (String) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Collection Name")
                        .font(.custom(AppFont.Poppins_Medium, size: 14))
                        .foregroundColor(.white.opacity(0.9))

                    TextField("e.g. Travel, Picnic, Business", text: $name)
                        .font(.custom(AppFont.Poppins_Regular, size: 15))
                        .padding(12)
                        .background(AppColor.Gray)
                        .cornerRadius(10)
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
                        .font(.custom(AppFont.Poppins_SemiBold, size: 15))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(
                    name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ? Color.gray
                    : AppColor.Pink
                )
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()
            }
            .padding()
            .navigationTitle("New Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Create Logic

    private func createCollection() {
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
