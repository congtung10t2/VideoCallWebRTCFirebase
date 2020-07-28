//
//  AppConfig.swift
//  LanguageOne
//
//  Created by TungHC on 7/28/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import Foundation
class AppConfig {
  class Notifications {
    static let RTCOffer = NSNotification.Name("offer")
    static let RTCAnwer = NSNotification.Name("answer")
    static let RTCCandidate = NSNotification.Name("candidate")
    static func fromString(description: String) -> Notification.Name {
      switch description {
      case "offer":
        return RTCOffer
      case "answer":
        return RTCAnwer
      case "candidate":
        return RTCCandidate
      default:
        return RTCCandidate
      }
    }
  }
}
