//
//  DataManager.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
class Room: NSObject, Codable {
  var room: String
}
typealias RoomId = (id: String, room: Room)

protocol FireBaseRTCProtocol: class {
  func sendOffer(message: SignalingMessage)
  func createRoom(name: String)
  func joinRoom(by id: String, useHost: Bool)
  
}
class DataManager : NSObject, FireBaseRTCProtocol {
  static var shared = DataManager()
  var db: Firestore!
  var collectRef: CollectionReference?
  var roomId: String?
  var isHost = false
  var offerListener: ListenerRegistration?
  @objc dynamic var listRoom = [String: Room] ()
  
  func configurate() {
    let settings = FirestoreSettings()
    Firestore.firestore().settings = settings
    // [END setup]
    db = Firestore.firestore()
    collectRef = db.collection("rooms")
    collectRef?.addSnapshotListener { ref, error in
      guard let ref = ref else {
        print("Error fetching document: \(error!)")
        return
      }
      
      let documents = ref.documents
      documents.forEach({ element in
        guard let room = try? element.data(as: Room.self) else { return }
        self.listRoom[element.documentID] = room
      })
      print(self.listRoom)
    }
    
  }
  
  func joinRoom(by id: String, useHost: Bool = false) {
    roomId = id
    let type = useHost ? "offer": "answer"
    offerListener = collectRef?.document(roomId!).collection(type).addSnapshotListener { snap, error in
      if let error = error {
        print(error)
      }
      guard let documents = snap?.documents else {
          print("Error fetching documents: \(error!)")
          return
      }
      guard let message = documents.compactMap ({
        $0.data()["message"]
      }).first as? String else { return }
      print(message)
      do {
        guard let data = message.data(using: .utf8) else { return }
        let signalingMessage = try JSONDecoder().decode(SignalingMessage.self, from: data)
        if signalingMessage.senderId != DeviceData.udid {
          
          NotificationCenter.default.post(name: AppConfig.Notifications.RTCMessage, object: nil, userInfo: ["message": signalingMessage])
          self.offerListener?.remove()
        }
      } catch {
        print(error)
      }
    }
    
    collectRef?.document(roomId!).collection("candidate").addSnapshotListener { snap, error in
      if let error = error {
        print(error)
      }
      guard let documents = snap?.documents else {
          print("Error fetching documents: \(error!)")
          return
      }
      guard let message = documents.compactMap ({
        $0.data()["message"]
      }).first as? String else { return }
      print(message)
      do {
        guard let data = message.data(using: .utf8) else { return }
        let signalingMessage = try JSONDecoder().decode(SignalingMessage.self, from: data)
        if signalingMessage.senderId != DeviceData.udid {
           NotificationCenter.default.post(name: AppConfig.Notifications.RTCMessage, object: nil, userInfo: ["message": signalingMessage])
        }
      } catch {
        print(error)
      }
      
      
     
    }

  }
  
  func createRoom(name: String) {
    guard let collectRef = collectRef else { return }
    var roomId: String?
    let docRef = collectRef.addDocument(data: ["room": name]) { error in
     // joinRoom(by: docRef.documentID, useHost: true)
      if let roomId = roomId {
        self.joinRoom(by: roomId, useHost: true)
      }
    }
    roomId = docRef.documentID
    isHost = true
  }
  
  func sendOffer(message: SignalingMessage) {
    guard let roomId = self.roomId,
      let collectRef = collectRef else {
        return
    }
    do {
      let data = try JSONEncoder().encode(message)
      let messageString = String(data: data, encoding: String.Encoding.utf8)!
      collectRef.document(roomId).collection("offer").addDocument(data: ["message": messageString])
      
    }catch{
      print(error)
    }
    
  }
  
  func sendAnswer(message: SignalingMessage, completion: @escaping (Error?) -> Void) {
    guard let roomId = self.roomId,
      let collectRef = collectRef else {
        return
    }
    
    do {
      let data = try JSONEncoder().encode(message)
      let messageString = String(data: data, encoding: String.Encoding.utf8)!
      collectRef.document(roomId).collection("answer").addDocument(data: ["message": messageString]) { error in
        completion(error)
      }
      
    }catch{
      print(error)
      completion(error)
    }
  }
  
  func sendCandidate(message: SignalingMessage, completion: @escaping (Error?) -> Void) {
    guard let roomId = self.roomId,
      let collectRef = collectRef else {
        return
    }
    do {
      let data = try JSONEncoder().encode(message)
      let messageString = String(data: data, encoding: String.Encoding.utf8)!
      collectRef.document(roomId).collection("candidate").addDocument(data: ["message": messageString]) { error in
        completion(error)
      }
      
    }catch{
      print(error)
    }
    
  }

}
