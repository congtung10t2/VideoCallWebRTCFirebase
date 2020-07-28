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
class ViewController: UIViewController {
  @IBOutlet weak var remoteView: RTCEAGLVideoView!
  
  @IBOutlet weak var localView: RTCEAGLVideoView!
  var webRTCController: WebRTCProtocol = WebRTCController.shared
  override func viewDidLoad() {
    super.viewDidLoad()
    webRTCController.setupWebRTC(localView: localView, remoteView: remoteView)
    
    // Do any additional setup after loading the view.
  }


}

