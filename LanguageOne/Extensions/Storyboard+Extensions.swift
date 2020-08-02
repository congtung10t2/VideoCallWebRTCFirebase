//
//  Storyboard+Extensions.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/31/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import UIKit
protocol StoryboardEnumerable {
    /// name of storyboard
    var name: String { get }
    /// storyboardBundle
    var bundle: Bundle? { get }
}

extension StoryboardEnumerable {
    // swiftlint:disable force_cast
    func viewController<T: UIViewController>() -> T {
        let className = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: className) as! T
    }
}

protocol Storyboardable {
    static var board: StoryboardEnumerable { get }
    static var instantiate: Self { get }
}

extension Storyboardable where Self: UIViewController {
    static var instantiate: Self {
        return board.viewController()
    }
}

enum StoryboardType: String, StoryboardEnumerable {
    var bundle: Bundle? {
        nil
    }

    var name: String {
        rawValue
    }

    case main = "Main"
}
