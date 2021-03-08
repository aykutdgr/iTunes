//
//  TableView-Extension.swift
//  itunes-Example
//
//  Created by Aykut Dogru on 7.03.2021.
//

import UIKit

public extension UITableView {
    
    func register<T: UITableViewCell> (_ type: T.Type) where T: Reusable {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Error")
        }
        
        return cell
    }
    
    func hideEmptyCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    func setEmptyView(message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        emptyView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.text = message
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UITableView {
    
    func registerCell<T: UITableViewCell>(type: T.Type) where T: Reusable {
        self.register(UINib(nibName: T.reuseIdentifier, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
        
    }
    
    func dequeueReusableCell<T: UITableViewCell> (forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as! T
    }
    
}
