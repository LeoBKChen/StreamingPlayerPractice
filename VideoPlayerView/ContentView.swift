//
//  ContentView.swift
//  VideoPlayerView
//
//  Created by 陳邦亢 on 2023/6/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    NavigationLink(destination: RTSPVideoPlayerView()) {
                        Text("Go To RTSP Page")
                    }.padding()
                    
                    NavigationLink(destination: SkywatchHomepageView()) {
                        Text("Go To Skywatch(flv) Page")
                    }.padding()
                }
            }
            
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
