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
  func receivedOffer(senderId: String)
  func captureBuffer(buffer: CMSampleBuffer)
  func receivedAnswer(senderId: String)
  func sendOffer(recipentId: String, sessionDescription: RTCSessionDescription)
  func sendAnswer(recipentId: String, sessionDescription: RTCSessionDescription)
}
class WebRTCController {
  static let shared = WebRTCController()
  var clients: [String: WebRTCClient] = [:]
  var signalingClient: SignalingClient?
  func setup(signalingClient: SignalingClient) {
    self.signalingClient = signalingClient
  }
  
  
}

extension WebRTCController: WebRTCProtocol {
  
  func sendOffer(recipentId: String, sessionDescription: RTCSessionDescription) {
    signalingClient?.sendOffer(recipentId: recipentId, desc: sessionDescription)
  }
  
  func sendAnswer(recipentId: String, sessionDescription: RTCSessionDescription) {
    signalingClient?.makeAnswer(recipentId: recipentId, desc: sessionDescription)
  }
  
  func receivedOffer(senderId: String) {
    
  }
  
  func captureBuffer(buffer: CMSampleBuffer) {
    
  }
  
  func receivedAnswer(senderId: String) {
    
  }
  
}
