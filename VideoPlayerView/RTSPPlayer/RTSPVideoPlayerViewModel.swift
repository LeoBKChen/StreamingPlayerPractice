//
//  VideoPlayerViewModel.swift
//  VideoPlayerView
//
//  Created by 陳邦亢 on 2023/6/9.
//

import Foundation
import Combine
import MobileVLCKit

class RTSPVideoPlayerViewModel: ObservableObject {
    @Published var playerState: VLCMediaPlayerState = .stopped
    private var cancellables = Set<AnyCancellable>()
    
    @Published var mediaPlayer: VLCMediaPlayer
    
    init() {
        mediaPlayer = VLCMediaPlayer()
        
        NotificationCenter.default.publisher(for: Notification.Name(rawValue: VLCMediaPlayerStateChanged))
            .sink { [weak self] notification in
                guard let self = self,
                      let mediaPlayer = notification.object as? VLCMediaPlayer else { return }
                
                self.playerState = mediaPlayer.state
            }
            .store(in: &cancellables)
    }
    
    func playVideo(url: URL) {
        mediaPlayer.media = VLCMedia(url: url)
        mediaPlayer.play()
    }
    
    func pauseVideo() {
        mediaPlayer.pause()
    }
    
    func stopVideo() {
        mediaPlayer.stop()
    }
}
