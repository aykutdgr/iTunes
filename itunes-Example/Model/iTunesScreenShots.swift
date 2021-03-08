//
//  iTunesScreenShots.swift
//  itunes-Example
//
//  Created by Aykut Dogru on 7.03.2021.
//

import Foundation
import UIKit

struct iTunesScreenShots {
    var size: String?
    var images: [UIImage]?
    
    init(size: String, images: [UIImage]) {
        self.size = size
        self.images = images
    }
}
