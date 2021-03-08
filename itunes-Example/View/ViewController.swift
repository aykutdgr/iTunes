//
//  ViewController.swift
//  itunes-Example
//
//  Created by Aykut Dogru on 16.02.2021.
//

import UIKit
import QuickLook

class ViewController: UIViewController {
    
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let searchController = UISearchController(searchResultsController: nil)
    var itunesResult = [iTunesSearch]()
    var searchText = ""
    var type = "software"

    
    var updateUI: ((String) -> Void)?
    
    var screenShots = [iTunesScreenShots]()
    var veryLowSizeArray = [UIImage]()
    var lowSizeArray = [UIImage]()
    var mediumSizeArray = [UIImage]()
    var highSizeArray = [UIImage]()

    
    lazy var previewItem = NSURL()
    
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
        activityIndicator.style = .medium
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true

        self.tableView.registerCell(type: TableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.hideEmptyCells()
        
        self.updateUI = { type in
            self.type = type
            if self.searchText != "" {
                self.filterContent(for: self.searchText)
            }
        }
    }
    
    private func filterContent(for searchText: String) {
        activityIndicator.startAnimating()
        
        iTunesSearchService.shared.getResults(searchTerm: searchText, parameters: ["media": self.type, "limit": "5"]) { (result) in
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
                
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            } catch {
                print("err no content")
                self.activityIndicator.stopAnimating()
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
    
    @IBAction func filterBarButton(_ sender: Any) {
        let vc = FilterViewController.instantiate()
        vc.updateUI = self.updateUI
        self.present(vc, animated: true, completion: nil)
    }
    
    func downloadfile(with url: String ,completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){

        let itemUrl = URL(string: url)
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("filename.png")
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            completion(true, destinationUrl)
        } else {
            URLSession.shared.downloadTask(with: itemUrl!, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    print("File moved to documents folder")
                    completion(true, destinationUrl)
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
            }).resume()
        }
    }
}

// MARK: - UITableView Delegates

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if screenShots.count == 0 {
            tableView.setEmptyView(message: "You haven't searched yet")
        } else {
            tableView.restore()
        }
        return screenShots.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return screenShots[section].size
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (screenShots[section].imgArr?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeReusableCell(for: indexPath)
        cell.imageView?.image = screenShots[indexPath.section].imgArr?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(indexPath.row)
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
        self.filterContent(for: searchText)
        self.tableView.reloadData()
    }
}

extension Int {
    var byteSize: String {
        return ByteCountFormatter().string(fromByteCount: Int64(self))
    }
}
