//
//  SignalingMessage.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import WebRTC
struct SignalingMessage: Codable {
  let type: SignalingType
  let sessionDescription: SDP?
  let candidate: Candidate?
  let receivedId: String?
  let senderId: String?
}
enum SignalingType: String, Codable {
  case offer
  case answer
  case candidate
  static func initWith(rtcType: RTCSdpType) -> SignalingType {
    switch rtcType {
    case .answer:
      return .answer
    case .offer:
      return .offer
    default:
      return .candidate
    }
  }
}

struct SDP: Codable {
  let sdp: String
}

struct Candidate: Codable {
  let sdp: String
  let sdpMLineIndex: Int32
  let sdpMid: String
}
