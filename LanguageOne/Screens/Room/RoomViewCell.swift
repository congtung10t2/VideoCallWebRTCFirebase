//
//  RoomViewCell.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/31/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import UIKit
class RoomViewCell : UITableViewCell {
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  @IBOutlet weak var roomDescLabel: UILabel!
  @IBOutlet weak var roomNameLabel: UILabel!
  func load(room: RoomId) {
    roomNameLabel.text = room.room.room
    roomDescLabel.text = room.id
  }
}

