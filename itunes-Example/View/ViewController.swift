//
//  ViewController.swift
//  itunes-Example
//
//  Created by Aykut Dogru on 7.03.2021.
//

import UIKit
import QuickLook

class ViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = iTunesScreenShotListViewModel()
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        self.navigationItem.titleView = searchController.searchBar
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self

        self.tableView.registerCell(type: TableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.hideEmptyCells()
        
        self.viewModel.onError = {
            let alert = UIAlertController(title: "Warning!", message: "No content", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.viewModel.reloadData = {
            self.tableView.reloadData()
        }
        
    }
}

// MARK: - UITableView Delegates

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.screenShots[section].size
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel.screenShots[section].images?.count) ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.screenShots.isEmpty {
            tableView.setEmptyView(message: "You haven't searched yet")
        } else {
            tableView.restore()
        }
        return self.viewModel.screenShots.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeReusableCell(for: indexPath)
        cell.imageView?.image = self.viewModel.screenShots[indexPath.section].images?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.viewModel.screenShots[indexPath.section].images?[indexPath.row] else { return }
        let vc = PreviewViewController.instantiate()
        vc.img = item
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - UISearchBar Delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.sendRequest), object: nil)
        self.perform(#selector(self.sendRequest), with: nil, afterDelay: 0.5)
    }
    
    @objc func sendRequest() {
        if !searchText.isEmpty {
            self.viewModel.requestForItunes(searchText: searchText)
        }
    }
}

