//
//  SignalingMessage.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import Foundation

struct SignalingMessage: Codable {
  let type: SignalingType
  let sessionDescription: SDP?
  let candidate: Candidate?
  let receivedId: String
  let senderId: String
}
enum SignalingType: String, Codable {
  case offer
  case answer
  case candidate
}

struct SDP: Codable {
  let sdp: String
}

struct Candidate: Codable {
  let sdp: String
  let sdpMLineIndex: Int32
  let sdpMid: String
}
