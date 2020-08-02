//
//  UICollectionView+Extensions.swift
//  LanguageOne
//
//  Created by tùng hoàng on 7/31/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import UIKit

protocol ReusableView: class { }

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {

    static var nibName: String {
        // notice the new describing here
        // now only one place to refactor if describing is removed in the future
        return String(describing: self)
    }

}

extension UITableViewCell: NibLoadableView { }
extension UITableViewCell: ReusableView { }
extension UICollectionViewCell: NibLoadableView { }
extension UICollectionViewCell: ReusableView { }
extension UITableViewHeaderFooterView: NibLoadableView { }
extension UITableViewHeaderFooterView: ReusableView { }

extension UITableView {
    func register<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellReuseIdentifier: name)
        } else {
            register(aClass, forCellReuseIdentifier: name)
        }
    }

    func register<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
        let name = aClass.reuseIdentifier
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forHeaderFooterViewReuseIdentifier: name)
        } else {
            register(aClass, forHeaderFooterViewReuseIdentifier: name)
        }
    }

    func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }

    func dequeue<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
        let name = aClass.reuseIdentifier
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }

    func register<T: UITableViewCell>(_: T.Type, bundle: Foundation.Bundle? = nil) {

        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func registerHeaderFooterNib<T: UITableViewHeaderFooterView>(_: T.Type, bundle: Foundation.Bundle? = nil) {

        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue view with identifier: \(T.reuseIdentifier)")
        }
        return view
    }

    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
          fatalError(
            "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
              + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
              + "and that you registered the cell beforehand"
          )
        }
        return cell
    }

}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: name)
        } else {
            register(aClass, forCellWithReuseIdentifier: name)
        }
    }

    func register<T: UICollectionReusableView>(header aClass: T.Type) {
        let name = String(describing: aClass)
        let kind = UICollectionView.elementKindSectionHeader
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        }
    }

    func register<T: UICollectionReusableView>(footer aClass: T.Type) {
        let name = String(describing: aClass)
        let kind = UICollectionView.elementKindSectionFooter
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        }
    }

    func dequeue<T: UICollectionViewCell>(_ aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
    func dequeue<T: UICollectionViewCell>(_ aClass: T.Type, identifier: String, for indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }

    func dequeue<T: UICollectionReusableView>(header aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: type(of: aClass))
        let kind = UICollectionView.elementKindSectionHeader
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }

    func dequeue<T: UICollectionReusableView>(footer aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: type(of: aClass))
        let kind = UICollectionView.elementKindSectionFooter
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }

    func register<T: UICollectionViewCell>(_: T.Type, bundle: Foundation.Bundle? = nil) {
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let bareCell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)
        guard let cell = bareCell as? T else {
          fatalError(
            "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
              + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
              + "and that you registered the cell beforehand"
          )
        }
        return cell
    }
}
