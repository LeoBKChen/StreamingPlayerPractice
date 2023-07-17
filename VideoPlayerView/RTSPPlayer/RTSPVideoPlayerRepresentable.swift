//
//  VideoPlayerRepresentable.swift
//  VideoPlayerView
//
//  Created by 陳邦亢 on 2023/6/9.
//

import SwiftUI
import MobileVLCKit

struct RTSPVideoPlayerRepresentable: UIViewRepresentable {
    var mediaPlayer: VLCMediaPlayer
    
    init(mediaPlayer: VLCMediaPlayer) {
        self.mediaPlayer = mediaPlayer
    }
    
    func makeUIView(context: Context) -> UIView {
        let videoView = UIView()
        
        DispatchQueue.main.async {
            mediaPlayer.drawable = videoView
        }
        
        return videoView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
