import UIKit

class APIManager: NSObject {
    static let shared = APIManager()
    
    func errorHandling(errorCode: Int? = 0, errorDescription: String? = NSLocalizedString("DefaultErrorDescription", comment: "")) {
        if errorCode == 403 {
            //AppUtils.shared.showAlertWithTitle(title: "Login Error" + "Code: \(errorCode!)", message: errorDescription)
        }
        else if errorCode == 401 {
           // AppUtils.shared.showAlertWithTitle(title: "Wrong Request" + "Code: \(errorCode!)", message: errorDescription)
        }
        else {
          //  AppUtils.shared.showAlertWithTitle(title: NSLocalizedString("DefaultErrorTitle", comment: "") + "Code: \(errorCode!)", message: errorDescription)
        }
    }
    
    

    
    
    
    func requestForItunes(sender: AnyObject?, selector: Selector?, media: String, limit: String) {
        
        var reqM = iTunesRequestRM()
        reqM.limit = limit
        reqM.media = media
        reqM.term = "software"
        
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
                           // self.errorHandling(errorCode: errorResult.errorCode, errorDescription: errorResult.errorDescription)
                        }
                        return
                    }
                    self.errorHandling()
                }
                else if let empty = empty {
                    let data = try JSONDecoder().decode(ResponseEmpty.self, from: empty.data)
                    _ = sender?.perform(selector, with: data)
                }
                else {
                    self.errorHandling()
                }
            }
            catch {
                self.errorHandling()
            }
        }
    }
}
