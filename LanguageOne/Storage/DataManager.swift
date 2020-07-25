//
//  DataManager.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/25/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class DataManager {
  static var shared = DataManager()
  var db: Firestore!
  var collectRef: CollectionReference?
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
    }
    
  }
  
  func sendOffer(message: SignalingMessage, completion: @escaping (Error?) -> Void) {
    collectRef?.addDocument(data: ["message": message]) { error in
      completion(error)
    }
  }
  
  
}
