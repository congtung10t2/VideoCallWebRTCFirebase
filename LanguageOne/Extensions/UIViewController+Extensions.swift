//
//  UIViewController+Extensions.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/31/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import UIKit
extension UIViewController {
  func showAlert(completion: @escaping (String?) -> Void) {
    let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)

    //2. Add the text field. You can configure it however you need.
    alert.addTextField { (textField) in
        textField.text = "Some default text"
    }

    // 3. Grab the value from the text field, and print it when the user clicks OK.
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
      let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
      guard let text = textField?.text else {
        completion(nil)
        return
      }
      completion(text)
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] _ in
      completion(nil)
    }
    ))

    // 4. Present the alert.
    self.present(alert, animated: true, completion: nil)
  }
}

