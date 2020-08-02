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
    static let RTCMessage = NSNotification.Name("RTCMessage")
    static func fromString(description: String) -> Notification.Name {
      switch description {
      case "offer":
        return RTCMessage
      case "answer":
        return RTCMessage
      case "candidate":
        return RTCMessage
      default:
        return RTCMessage
      }
    }
  }
}
