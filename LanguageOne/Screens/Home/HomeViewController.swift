//
//  ViewController.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import UIKit
import Firebase
import WebRTC
final class HomeViewController: UIViewController {
  @IBOutlet weak var remoteView: RTCEAGLVideoView!
  
  @IBOutlet weak var localView: RTCEAGLVideoView!
  var webRTCController: WebRTCProtocol = WebRTCController.shared
  override func viewDidLoad() {
    super.viewDidLoad()
    remoteView.delegate = self
    localView.delegate = self
    webRTCController.setupWebRTC(localView: localView, remoteView: remoteView)
    NotificationCenter.default.addObserver(self, selector: #selector(self.onReceivedMessage), name: AppConfig.Notifications.RTCMessage, object: nil)
    // Do any additional setup after loading the view.
  }
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func onReceivedMessage(_ data: Notification) {
    guard let message = data.userInfo?["message"] as? SignalingMessage else { return }
    switch message.type {
    case .offer:
      webRTCController.receivedOffer(signalingMessage: message)
    case .answer:
      webRTCController.receivedAnswer(signalingMessage: message)
    default:
      if let candidate = message.candidate {
        webRTCController.receivedCandidate(iceCandidate: RTCIceCandidate(sdp: candidate.sdp, sdpMLineIndex: candidate.sdpMLineIndex, sdpMid: candidate.sdpMid))
      }
    }
  }
  
  func startConnect() {
    WebRTCController.shared.startConnect()
  }
}
extension HomeViewController: RTCVideoViewDelegate {
  func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
    
  }
}

extension HomeViewController: Storyboardable {
    static var board: StoryboardEnumerable {
      return StoryboardType.main
    }
}
