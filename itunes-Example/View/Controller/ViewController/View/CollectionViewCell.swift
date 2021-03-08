//
//  CollectionViewCell.swift
//  itunes-Example
//
//  Created by Aykut Dogru on 22.02.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var result: iTunesSearchResult? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgArtwork.layer.cornerRadius = 25
    }

    func updateUI() {
        self.lblName.text = result?.artistName
        if let url = result?.artworkUrl100 {
            self.imgArtwork.image = setImage(url: url)
        }
        
        if result?.clicked == true {
            self.lblName.textColor = .red
        } else {
            self.lblName.textColor = .black
        }
    }
    
    func setImage(url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}
