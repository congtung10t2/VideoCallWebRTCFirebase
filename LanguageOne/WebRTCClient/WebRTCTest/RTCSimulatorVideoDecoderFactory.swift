//
//  RTCSimulatorVideoDecoderFactory.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/27/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import WebRTC


class RTCSimulatorVideoDecoderFactory: RTCDefaultVideoDecoderFactory {
  override init() {
    super.init()
  }
  
  override func supportedCodecs() -> [RTCVideoCodecInfo] {
    var codecs = super.supportedCodecs()
    codecs = codecs.filter{$0.name != "H264"}
    return codecs
  }
}
