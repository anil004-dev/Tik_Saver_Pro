//
//  AppVideoPlayer.swift
//  Tik_Saver_pro
//
//  Created by Anil Jadav on 08/01/26.
//

import SwiftUI
import AVKit

struct AppVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer
    let showControls: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.videoGravity = .resizeAspectFill
        controller.showsPlaybackControls = showControls
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(
        _ uiViewController: AVPlayerViewController,
        context: Context
    ) {}
}

