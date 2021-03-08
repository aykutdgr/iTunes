//
//  PreviewViewController.swift
//  itunes-Example
//
//  Created by Aykut Dogru on 7.03.2021.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var bgView: UIView!
    var img: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    private func initUI() {
        self.imgPreview.image = self.img
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        bgView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PreviewViewController: StoryboardInstatiate, Reusable {
    public static var storyboard: Storyboard { return .main }
}
