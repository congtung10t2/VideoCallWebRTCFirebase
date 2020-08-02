//
//  FirebaseSignaling.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import Foundation
import WebRTC
protocol SignalingProtocol {
  func sendMessage(signalingMessage: SignalingMessage)
  func receivedMessage(signalingMessage: SignalingMessage)
  func createRoom(name: String)
}

protocol SignalingWebRTC {
  func sendOffer(desc: RTCSessionDescription)
  func makeAnswer(recipentId: String, desc: RTCSessionDescription)
  func sendCandidate(recipentId: String, iceCandidate: RTCIceCandidate)
}

class SignalingClient: SignalingProtocol {
  func sendMessage(signalingMessage: SignalingMessage) {
    do {
        let data = try JSONEncoder().encode(signalingMessage)
        let message = String(data: data, encoding: String.Encoding.utf8)!
     
        
    }catch{
        print(error)
    }
  }
  
  func receivedMessage(signalingMessage: SignalingMessage) {
    
  }
  func createRoom(name: String) {
    DataManager.shared.createRoom(name: name)
  }
  
  static let shared = SignalingClient()
}
extension SignalingClient: SignalingWebRTC {
  func sendCandidate(recipentId: String, iceCandidate: RTCIceCandidate) {
    let candidate = Candidate(sdp: iceCandidate.sdp, sdpMLineIndex: iceCandidate.sdpMLineIndex, sdpMid: iceCandidate.sdpMid!)
    let signalingMessage = SignalingMessage(type: .candidate, sessionDescription: nil, candidate: candidate, receivedId: recipentId, senderId: DeviceData.udid)
    DataManager.shared.sendCandidate(message: signalingMessage) { error in
      
    }
  }
  
  func sendOffer(desc: RTCSessionDescription) {
    let type: SignalingType = SignalingType.initWith(rtcType: desc.type)
    
    let sdp = SDP(sdp: desc.sdp)
    let signalingMessage = SignalingMessage(type: type, sessionDescription: sdp, candidate: nil, receivedId: nil, senderId: DeviceData.udid)
    DataManager.shared.sendOffer(message: signalingMessage)
  }
  
  func makeAnswer(recipentId: String, desc: RTCSessionDescription) {
    let type: SignalingType = SignalingType.initWith(rtcType: desc.type)
    
    let sdp = SDP(sdp: desc.sdp)
    let signalingMessage = SignalingMessage(type: type, sessionDescription: sdp, candidate: nil, receivedId: recipentId, senderId: DeviceData.udid)
    DataManager.shared.sendAnswer(message: signalingMessage) { error in
      
    }
  }
  
  
}
