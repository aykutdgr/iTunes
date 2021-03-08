//
//  TableViewCell.swift
//  itunes-Example
//
//  Created by Samet Dogru on 3.03.2021.
//

import UIKit

class TableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var imgScreenShot: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
