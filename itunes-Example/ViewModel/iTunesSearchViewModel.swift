//
//  File.swift
//  itunes-Example
//
//  Created by Aykut Dogru on 7.03.2021.
//

import Foundation
import UIKit

class iTunesScreenShotListViewModel {
    enum params: String {
        case media = "software"
        case limit = "5"
    }
    
    var screenShots = [iTunesScreenShots]()
    var itunesResult = [String]()
    
    var veryLowSizeArray = [UIImage]()
    var mediumSizeArray = [UIImage]()
    var highSizeArray = [UIImage]()
    var lowSizeArray = [UIImage]()
    var queue = OperationQueue()
    
    var reloadData : ()->() = {}
    var onError : ()->() = {}
    
    public func requestForItunes(searchText: String) {
        APIManager.shared.requestForItunes(sender: self, selector:  #selector(self.response(data:)), media: params.media.rawValue, limit: params.limit.rawValue, searchText: searchText)
    }

    @objc func response(data: Any?) {
        if let response = data as? [iTunesURL] {
            if !response.isEmpty {
                self.prepare(model: response)
            } else {
                self.onError()
            }
        } else {
            self.onError()
        }
    }
    
    private func prepare(model: [iTunesURL]) {
        self.removeArrayItems()
        
        model.forEach { (models) in
            models.screenshotUrls?.forEach({ (item) in
                itunesResult.append(item)
            })
        }
        
        self.downloadStart()
    }
    
    private func downloadStart() {
        self.queue = OperationQueue()
        let operation1 = BlockOperation(block: {
            let Queue1 = Array(self.itunesResult[0..<(self.itunesResult.count/3)])
            Queue1.forEach { (imgURL) in
                guard let image = self.downloadImageWithURL(url: imgURL) else { return }
                OperationQueue.main.addOperation({
                    self.groupImage(img: image)
                })
            }
        })
        self.queue.addOperation(operation1)
        
        
        let operation2 = BlockOperation(block: {
            let Queue2 = Array(self.itunesResult[((self.itunesResult.count/3))..<((self.itunesResult.count - self.itunesResult.count/3))])
            Queue2.forEach { (imgURL) in
                    guard let image = self.downloadImageWithURL(url: imgURL) else { return }
                    OperationQueue.main.addOperation({
                        self.groupImage(img: image)
                    })
            }
        })
        self.queue.addOperation(operation2)
        
        
        let operation3 = BlockOperation(block: {
            let Queue3 = Array(self.itunesResult[((((self.itunesResult.count - self.itunesResult.count/3))))..<((self.itunesResult.count))])
            Queue3.forEach { (imgURL) in
                    guard let image = self.downloadImageWithURL(url: imgURL) else { return }
                    OperationQueue.main.addOperation({
                        self.groupImage(img: image)
                    })
            }
        })
        
        self.queue.addOperation(operation3)
        operation1.addDependency(operation2)
        operation2.addDependency(operation3)
    }
    
    private func groupImage(img: UIImage) {
        if let data = img.pngData() {
            let size = data.count.byteSize
            let value = (size as NSString).integerValue
            self.screenShots.removeAll()

            switch value {
            case 0...100:
                self.veryLowSizeArray.append(img)
            case 100...250:
                self.lowSizeArray.append(img)
            case 250...500:
                self.mediumSizeArray.append(img)
            default:
                self.highSizeArray.append(img)
            }
            
            self.screenShots.append(iTunesScreenShots(size: "0-100kb", images: self.veryLowSizeArray))
            self.screenShots.append(iTunesScreenShots(size: "100-250kb", images: self.lowSizeArray))
            self.screenShots.append(iTunesScreenShots(size: "250-500kb", images: self.mediumSizeArray))
            self.screenShots.append(iTunesScreenShots(size: "500+kb", images: self.highSizeArray))

            self.reloadData()
        }
    }
    
    private func removeArrayItems() {
        self.itunesResult.removeAll()
        self.veryLowSizeArray.removeAll()
        self.mediumSizeArray.removeAll()
        self.highSizeArray.removeAll()
        self.lowSizeArray.removeAll()
    }
    
    func downloadImageWithURL(url: String) -> UIImage? {
       guard let item = URL(string: url) else { return nil }
       if let data = try? Data(contentsOf: item) {
           if let image = UIImage(data: data) {
               return image
           }
       }
       return nil
   }
}
 
