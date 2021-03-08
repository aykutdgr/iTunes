//
//  StoryboardInstatiate.swift
//  itunes-Example
//
//  Created by Aykut Dogru on 7.03.2021.
//

import UIKit

public protocol StoryboardInstatiate {
    static var storyboard: Storyboard { get }
    static var storybardIdentifier: String { get }
}

public extension StoryboardInstatiate where Self: UIViewController & Reusable {
    static var storybardIdentifier: String {return Self.reuseIdentifier}
    static func instantiate() -> Self {
        let bundle = Bundle(for: Self.self)
        let storyboard = UIStoryboard(name: Self.storyboard.name, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: Self.storybardIdentifier) as! Self
    }
}
