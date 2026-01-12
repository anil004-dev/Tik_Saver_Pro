//
//  VideoPlayerFullScreenView.swift
//  WTScan
//
//  Created by Anil Jadav on 10/01/26.
//

import AVKit
import SwiftUI

struct VideoPlayerFullScreenView: View {

    let videoURL: URL
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer

    init(videoURL: URL) {
        self.videoURL = videoURL
        _player = State(initialValue: AVPlayer(url: videoURL))
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            
            AppVideoPlayer(player: player, showControls: true)
                .ignoresSafeArea()
                .onAppear {
                    player.play()
                }
                .onDisappear {
                    player.pause()
                }
        }
    }
}
