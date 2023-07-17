//
//  VideoPlayerView.swift
//  VideoPlayerView
//
//  Created by 陳邦亢 on 2023/6/9.
//

import SwiftUI

struct RTSPVideoPlayerView: View{
    @StateObject private var viewModel = RTSPVideoPlayerViewModel()
    @State private var isPlaying = false
    var videoURLString: String = "rtsp://admin:admin@122.117.181.97:5555"
    
    init(videoURLString: String = "rtsp://admin:admin@122.117.181.97:5555") {
        print("input videoURLString: \(videoURLString)")
        self.videoURLString = videoURLString
    }
    
    var body: some View {
        VStack {
            Text("Camera name: Demo")
                .padding()
            
            RTSPVideoPlayerRepresentable(mediaPlayer: viewModel.mediaPlayer)
                .frame(height: 250)
                .padding()
            
            HStack {
                Button(action: {
                    print("clicked play button")
                    guard let videoURL = URL(string: videoURLString) else {
                        return
                    }
                    viewModel.playVideo(url: videoURL)
                    isPlaying = true
                    
                }) {
                    Image(systemName: "play.circle")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                }
                .disabled(isPlaying)
                
                Button(action: {
                    print("clicked pause button")
                    viewModel.pauseVideo()
                    isPlaying = false
                }) {
                    Image(systemName: "pause.circle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                .disabled(!isPlaying)
                
                Button(action: {
                    print("clicked stop button")
                    viewModel.stopVideo()
                    isPlaying = false
                }) {
                    Image(systemName: "stop.circle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                .disabled(!isPlaying)
            }.padding()
        }.padding()
    }
}
