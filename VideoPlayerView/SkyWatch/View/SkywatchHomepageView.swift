//
//  SkywatchHomepageView.swift
//  VideoPlayerView
//
//  Created by 陳邦亢 on 2023/6/19.
//

import Foundation
import SwiftUI
import Combine
import AVKit

struct SkywatchCameraPreviewListViewRow: View {
    var flvURL: String
    //    var hlsPath: String
    
    
    init(url: String) {
        self.flvURL = url

    }
    
    var body: some View {
        VStack {
            RTSPVideoPlayerView(videoURLString: self.flvURL)
        }
        .frame(width: 350, height: 350)
        .padding()
    }
}

struct SkywatchHomepageView: View {
    @ObservedObject var helper = SkywatchAPIHelper()
    
    @State private var showDownloadView = false
    private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        Section {
            List {
                
                ForEach( Array(helper.deviceID.enumerated()), id: \.offset) { dIndex, id in
                    SkywatchCameraPreviewListViewRow(url: helper.streamUrls[dIndex])
                    //                    NavigationLink(destination: DownloadView(user: user, password: password, dealer: dealer, version: version).environmentObject(UATHelper())) {
                    //                        SkywatchCameraPreviewListViewRow(url: helper.streamUrls[dIndex])
                    //                    }
                }
            }
        }
        .onAppear {
            helper.getAllStreamUrl()
        }
        .navigationBarTitle("攝影機列表", displayMode: .inline)
        
    }
}

