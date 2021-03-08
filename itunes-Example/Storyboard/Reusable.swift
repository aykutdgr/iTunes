//
//  Reusable.swift
//  itunes-Example
//
//  Created by Aykut Dogru on 22.02.2021.
//

import UIKit

public protocol Reusable {
  static var reuseIdentifier: String { get }
}

public extension Reusable {
  static var reuseIdentifier: String { return String(describing: self) }
}

public extension Reusable where Self: UIViewController {
  init(bundle: Bundle?) {
    self.init(nibName: Self.reuseIdentifier, bundle: bundle)
  }
}
