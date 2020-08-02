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

protocol WebRTCProtocol: class {
  func setupWebRTC(localView: RTCEAGLVideoView, remoteView: RTCEAGLVideoView)
  func receivedOffer(signalingMessage: SignalingMessage)
  func captureBuffer(buffer: CMSampleBuffer)
  func receivedAnswer(signalingMessage: SignalingMessage)
  func sendOffer(sessionDescription: RTCSessionDescription)
  func receivedCandidate(iceCandidate: RTCIceCandidate)
  func sendAnswer(recipentId: String, sessionDescription: RTCSessionDescription)
  func startConnect()
}
class WebRTCController {
  static let shared = WebRTCController()
  var client = WebRTCClient()
  var signalingClient: SignalingWebRTC = SignalingClient.shared
  
  
}

extension WebRTCController: WebRTCProtocol {
  func setupWebRTC(localView: RTCEAGLVideoView, remoteView: RTCEAGLVideoView) {
    client.renderLocalVideo(to: localView)
    client.renderRemoteVideo(to: remoteView)
    client.delegate = self
    client.setup(videoTrack: true, audioTrack: true, dataChannel: true)
  }
  
  func startConnect() {
    client.connect() { desc in
      self.sendOffer(sessionDescription: desc)
    }
  }
  
  func sendOffer(sessionDescription: RTCSessionDescription) {
    signalingClient.sendOffer(desc: sessionDescription)
  }
  
  func sendAnswer(recipentId: String, sessionDescription: RTCSessionDescription) {
    signalingClient.makeAnswer(recipentId: recipentId, desc: sessionDescription)
  }
  
  func receivedOffer(signalingMessage: SignalingMessage) {
    
    client.receiveOffer(offerSDP: RTCSessionDescription(type: .offer, sdp: (signalingMessage.sessionDescription?.sdp)!), onCreateAnswer: {(answerSDP: RTCSessionDescription) -> Void in
      if let senderId = signalingMessage.senderId {
        self.client.recipentId = senderId
        self.sendAnswer(recipentId: senderId, sessionDescription: answerSDP)
      }
    })
  }
  
  func captureBuffer(buffer: CMSampleBuffer) {
    
  }
  
  private func sendCandidate(iceCandidate: RTCIceCandidate){
    if let id = client.recipentId {
      signalingClient.sendCandidate(recipentId: id, iceCandidate: iceCandidate)
    }
  }
  
  func receivedCandidate(iceCandidate: RTCIceCandidate) {
    client.receiveCandidate(candidate: RTCIceCandidate(sdp: iceCandidate.sdp, sdpMLineIndex: iceCandidate.sdpMLineIndex, sdpMid: iceCandidate.sdpMid))
  }
  
  func receivedAnswer(signalingMessage: SignalingMessage) {
    client.receiveAnswer(answerSDP: RTCSessionDescription(type: .answer, sdp: (signalingMessage.sessionDescription?.sdp)!))
  }
  
}
extension WebRTCController: WebRTCClientDelegate {
  func didGenerateCandidate(iceCandidate: RTCIceCandidate) {
    self.sendCandidate(iceCandidate: iceCandidate)
  }
  
  func didIceConnectionStateChanged(iceConnectionState: RTCIceConnectionState) {
    debugPrint(iceConnectionState)
  }
  
  func didOpenDataChannel() {
    
  }
  
  func didReceiveData(data: Data) {
    
  }
  
  func didReceiveMessage(message: String) {
    
  }
  
  func didConnectWebRTC() {
    
  }
  
  func didDisconnectWebRTC() {
    
  }
  
  
}
