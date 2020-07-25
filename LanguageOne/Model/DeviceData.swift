
//
//  DeviceInfo.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import UIKit
class DeviceData {
  private init() {}
  static let udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
}
