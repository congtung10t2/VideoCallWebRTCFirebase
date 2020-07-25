//
//  FirebaseSignaling.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import Foundation
protocol SignalingProtocol {
  func sendMessage(message: SignalingMessage)
  func receivedMessage(message: SignalingMessage)
}
