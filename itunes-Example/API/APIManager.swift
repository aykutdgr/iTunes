import UIKit

class APIManager: NSObject {
    static let shared = APIManager()
    
    func requestForItunes(sender: AnyObject?, selector: Selector?, media: String, limit: String, searchText: String) {
        
        var reqM = iTunesRequestRM()
        reqM.limit = limit
        reqM.media = media
        reqM.term = searchText
        
        let req = iTunesRequest()
        req.send(httpMethod: Constants().HttpMethod_GET, reqM: reqM) { (model, errorTuple, empty) in
            
            do {
                if let response = model {
                    _ = sender?.perform(selector, with: response.results)
                    return
                }
                else if errorTuple != nil {
                    let error = errorTuple?.0
                    
                    guard error == nil else {
                        let errResponse = errorTuple?.1
                        if let data = errResponse?.data(using: String.Encoding.utf8) {
                            let errorResult = try JSONDecoder().decode(iTunesResponse.self, from: data)
                                print(errorResult)
                        }
                        return
                    }
                }
                else if let empty = empty {
                    let data = try JSONDecoder().decode(ResponseEmpty.self, from: empty.data)
                    _ = sender?.perform(selector, with: data)
                }
                else {
                    print("Error occured")
                }
            }
            catch {
                print("Error occured")
            }
        }
    }
}
