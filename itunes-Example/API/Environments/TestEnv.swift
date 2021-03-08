//
//  TestEnv.swift
//  Transliter
//
//  Created by Kaan Esin on 6/27/19.
//

import UIKit

class TestEnv: NSObject {
    static let shared = TestEnv()
 
    var baseUrl = URL(string: "https://itunes.apple.com")!
    var apiString = "/search"
}
