//
//  RepostView.swift
//  WTScan
//
//  Created by Anil Jadav on 17/01/26.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct RepostView: View {
    
    // Data passed from the picker
    var image: UIImage?
    var videoURL: URL?
    @State private var caption: String = ""
    @State private var showShareSheet: Bool = false
    // 1. Create a State object for the player to control playback
    @State private var player: AVPlayer?
    @State private var isPlaying: Bool = false
    
    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: 0) {
                // 2. Content
                if let image = image {
                    HStack {
                        Spacer(minLength: 15)
                        VStack {
                            Spacer(minLength: 15)
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 35))
                            Spacer(minLength: 15)
                        }
                        Spacer(minLength: 15)
                    }
                }
                else if let videoURL = videoURL {
                    // Video Preview with Custom Play Button
                    ZStack {
                        // The Player
                        // We use the @State player here
                        if let player = player {
                            AppVideoPlayer(player: player, showControls: true) // Hide native controls for cleaner look
                                .clipShape(RoundedRectangle(cornerRadius: 35))
                        }
                        
                        // The Custom Play Button Overlay
                        // Only show if NOT playing
                        if !isPlaying {
                            Button(action: {
                                // Action: Start playing and hide button
                                player?.play()
                                isPlaying = true
                            }) {
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundStyle(.white)
                                    .background(
                                        Circle()
                                            .fill(.black.opacity(0.3)) // Subtle dark background for contrast
                                    )
                            }
                        }
                    }
                    .onAppear {
                        // Initialize player when view appears
                        if player == nil {
                            player = AVPlayer(url: videoURL)
                        }
                    }
                    .onDisappear {
                        // Cleanup: Pause when leaving screen
                        player?.pause()
                        isPlaying = false
                    }
                }
                WTTextField(placeHolder: "Add Caption", text: $caption)
                    .frame(height: 51)
                    .padding([.top, .bottom], 20)
                WTButton(title: "Repost") {
                    showShareSheet = true
                }
                .padding(.bottom)
            }
            .padding()
            .onTapGesture {
                Utility.hideKeyboard()
            }
        }
        .navigationTitle("Preview")
        .sheet(isPresented: $showShareSheet) {
            TikSaveShareSheet(items: generateShareItems())
            // Optional: Fix for iPad to prevent crashes by constraining presentation
                .presentationDetents([.medium, .large])
        }
    }
    
    // 4. Helper function to combine Media + Text
    func generateShareItems() -> [Any] {
        var items: [Any] = []
        
        // Add Text (Caption)
        if !caption.isEmpty {
            items.append(caption)
        }
        
        // Add Media (Image OR Video)
        if let image = image {
            items.append(image)
        } else if let videoURL = videoURL {
            items.append(videoURL)
        }
        
        return items
    }
}

#Preview {
    RepostView()
}
