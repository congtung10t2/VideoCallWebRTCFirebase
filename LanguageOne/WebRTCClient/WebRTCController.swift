//
//  WebRTCController.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import Foundation
import AVFoundation
import WebRTC

protocol WebRTCProtocol {
  func setupWebRTC()
  func receivedOffer(senderId: String)
  func captureBuffer(buffer: CMSampleBuffer)
  func receivedAnswer(senderId: String)
  func sendOffer(recipentId: String, sessionDescription: RTCSessionDescription)
  func sendAnswer(recipentId: String, sessionDescription: RTCSessionDescription)
}
class WebRTCController {
  static let shared = WebRTCController()
  var client = WebRTCClient()
  var signalingClient: SignalingClient = SignalingClient.shared
  
  
}

extension WebRTCController: WebRTCProtocol {
  func setupWebRTC() {
    client.setup(videoTrack: true, audioTrack: true, dataChannel: true)
  }
  
  func sendOffer(recipentId: String, sessionDescription: RTCSessionDescription) {
    signalingClient.sendOffer(recipentId: recipentId, desc: sessionDescription)
  }
  
  func sendAnswer(recipentId: String, sessionDescription: RTCSessionDescription) {
    signalingClient.makeAnswer(recipentId: recipentId, desc: sessionDescription)
  }
  
  func receivedOffer(senderId: String) {
    
  }
  
  func captureBuffer(buffer: CMSampleBuffer) {
    
  }
  
  func receivedAnswer(senderId: String) {
    
  }
  
}
