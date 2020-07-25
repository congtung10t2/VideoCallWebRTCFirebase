//
//  WebRTCController.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import Foundation
import AVFoundation

protocol WebRTCProtocol {
  func receivedOffer(senderId: String)
  func captureBuffer(buffer: CMSampleBuffer)
  func receivedAnswer(senderId: String)
  func sendOffer(recipentId: String)
  func sendAnswer(recipentId: String)
}
class WebRTCController {
  static let shared = WebRTCController()
  var clients: [String: WebRTCClient] = [:]
  
}

extension WebRTCController: WebRTCProtocol {
  func sendOffer(recipentId: String) {
    
  }
  
  func sendAnswer(recipentId: String) {
    
  }
  
  func receivedOffer(senderId: String) {
    
  }
  
  func captureBuffer(buffer: CMSampleBuffer) {
    
  }
  
  func receivedAnswer(senderId: String) {
    
  }
  
}
