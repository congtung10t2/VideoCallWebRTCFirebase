//
//  RoomViewController.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/29/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomAppBar
final class RoomViewController: UIViewController {
  @IBOutlet weak var bottomBarView: MDCBottomAppBarView!
  @IBOutlet weak var tableView: UITableView!
  var signalingClient: SignalingClient = SignalingClient.shared
  var lastRoom: [RoomId] = []
  func getAllRoom() -> [RoomId] {
    return lastRoom
  }
  func calulateRooms() {
    lastRoom = DataManager.shared.listRoom.map { RoomId(id: $0.key, room: $0.value) }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    DataManager.shared.addObserver(self, forKeyPath: "listRoom", options: [.new, .old], context: nil)
    
  }
  
  func setupView() {
    bottomBarView.floatingButton.setImage(.add, for: .normal)
    bottomBarView.floatingButton.addTarget(self, action: #selector(showTextInput(_:)), for: .touchUpInside)
    let trailingButton = UIBarButtonItem()
    
    trailingButton.accessibilityHint = "Purchase the item"
    trailingButton.image = UIImage(named: "ic-search")
    let leadingButton = UIBarButtonItem()
    
    leadingButton.accessibilityHint = "Purchase the item"
    leadingButton.image = UIImage(named: "ic-search")
    bottomBarView.leadingBarButtonItems = [ leadingButton ]
    bottomBarView.trailingBarButtonItems = [ trailingButton ]
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(RoomViewCell.self)
  }
  
  deinit {
    DataManager.shared.removeObserver(self, forKeyPath: "listRoom")
  }
  @objc func showTextInput(_ sender: UIEvent) {
    showAlert() { text in
      guard let text = text else { return }
      DataManager.shared.createRoom(name: text)
      let vc = HomeViewController.instantiate
      self.present(vc, animated: true, completion: nil)
    }
  }
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "listRoom" {
      calulateRooms()
      tableView.reloadData()
    }
  }
}
extension RoomViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return getAllRoom().count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let roomId =  getAllRoom()[indexPath.row].id
    DataManager.shared.joinRoom(by: roomId, useHost: false)
    let vc = HomeViewController.instantiate
    
    self.present(vc, animated: true, completion: { 
      vc.startConnect()
    })
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: RoomViewCell = tableView.dequeueReusableCell(for: indexPath, cellType: RoomViewCell.self)
    cell.load(room: getAllRoom()[indexPath.row])
    return cell
  }
}
extension RoomViewController: Storyboardable {
    static var board: StoryboardEnumerable {
      return StoryboardType.main
    }
}
