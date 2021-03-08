//
//  File.swift
//  itunes-Example
//
//  Created by Samet Dogru on 6.03.2021.
//

import Foundation
import UIKit

class iTunesScreenShotListViewModel {
    
    var onSucces : ()->() = {}
    var onError : ()->() = {}

    var itunesResult = [iTunesSearch]()
    var screenShots = [iTunesScreenShots]()
    
    var veryLowSizeArray = [UIImage]()
    var lowSizeArray = [UIImage]()
    var mediumSizeArray = [UIImage]()
    var highSizeArray = [UIImage]()
    
    public func filterContent(for searchText: String) {
        
        iTunesSearchService.shared.getResults(searchTerm: searchText, parameters: ["media": "software", "limit": "5"]) { (result) in
            
            do {
                try self.itunesResult = result.get()
                
                self.itunesResult.forEach { (item) in
                    item.screenshotUrls?.forEach({ (imgURL) in
                        if let url = URL(string: imgURL) {
                            if let img = self.setImage(url: url) {
                                if let data = img.pngData() {
                                    let size = data.count.byteSize
                                    let dd = (size as NSString).integerValue

                                    switch dd {
                                    case 0...100:
                                        self.veryLowSizeArray.append(img)
                                    case 100...250:
                                        self.lowSizeArray.append(img)
                                    case 250...500:
                                        self.mediumSizeArray.append(img)
                                    default:
                                        self.highSizeArray.append(img)
                                    }
                                }
                            }
                        }
                    })
                }
                
                self.screenShots.append(iTunesScreenShots(size: "0-100kb", imgArr: self.veryLowSizeArray))
                self.screenShots.append(iTunesScreenShots(size: "100-250kb", imgArr: self.lowSizeArray))
                self.screenShots.append(iTunesScreenShots(size: "250-500kb", imgArr: self.mediumSizeArray))
                self.screenShots.append(iTunesScreenShots(size: "500+kb", imgArr: self.highSizeArray))
                
                self.onSucces()
            } catch {
                self.onError()
                return
            }
        }
    }
    
    private func setImage(url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}
