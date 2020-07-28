//
//  DataManager.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
protocol FireBaseRTCProtocol {
  func sendOffer(message: SignalingMessage)
  func createRoom(name: String)
  func joinRoom(by id: String, useHost: Bool)
  
}
class DataManager : FireBaseRTCProtocol {
  static var shared = DataManager()
  var db: Firestore!
  var collectRef: CollectionReference?
  var roomId: String?
  var isHost = false
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
      let doc = ref.documents[0]
      self.joinRoom(by: doc.documentID, useHost: self.isHost)
      print(doc.documentID)
    }
    
  }
  
  func joinRoom(by id: String, useHost: Bool = false) {
    roomId = id
    let type = useHost ? "offer": "answer"
    collectRef?.document(roomId!).collection(type).addSnapshotListener { snap, error in
      if let error = error {
        print(error)
      }
      guard let documents = snap?.documents else {
          print("Error fetching documents: \(error!)")
          return
      }
      guard let message = documents.compactMap ({
        $0.data()["message"]
      }).first else { return }
      print(message)
      NotificationCenter.default.post(name: AppConfig.Notifications.fromString(description: type), object: ["message": message])
    }
  }
  
  func createRoom(name: String) {
    guard let docRef = collectRef?.addDocument(data: ["room": name]) else { return }
    isHost = true
    joinRoom(by: docRef.documentID, useHost: true)
  }
  
  func sendOffer(message: SignalingMessage) {
    guard let roomId = self.roomId,
      let collectRef = collectRef else {
        return
    }
    collectRef.document(roomId).collection("offer").addDocument(data: ["message": message])
  }
  
  func sendAnswer(message: SignalingMessage, completion: @escaping (Error?) -> Void) {
    guard let roomId = self.roomId,
      let collectRef = collectRef else {
        return
    }
    collectRef.document(roomId).collection("answer").addDocument(data: ["message": message]) { error in
      completion(error)
    }
  }
}
