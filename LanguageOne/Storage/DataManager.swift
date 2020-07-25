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
  func configurate() {
    let settings = FirestoreSettings()
    Firestore.firestore().settings = settings
    // [END setup]
    db = Firestore.firestore()
  }
}
