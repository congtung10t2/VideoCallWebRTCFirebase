//
//  RTCVideoView.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/27/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import Foundation
import WebRTC
#if arch(arm64)
class RTCVideoView: RTCMTLVideoView {
}
#else
class RTCVideoView: RTCEAGLVideoView {
}
#endif


