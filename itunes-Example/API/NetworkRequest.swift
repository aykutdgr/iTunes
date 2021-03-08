import Foundation
import Alamofire

class NetworkRequest<ReqM: Codable, RM: Codable>: Request {
    
    var endpoint: String = ""
    var path: String = ""
    var paramaters: [String: Any] = [:]
    var checkInternet = false
    
    func send(httpMethod: String, reqM: ReqM, completion: @escaping (RM?, (Error?, String?)?, ResponseEmpty?) -> Void) {
        
        if checkInternet {
            guard hasInternet() else { return }
        }
        
        paramaters = reqM.dictionary
        
        createURLString()
        let p = path + "?" + "term=software&media=software&limit=5"
        var urlRequest = URLRequest(url: URL(string: p)!)
        urlRequest.httpMethod = httpMethod

        do {
           // urlRequest.httpBody = try JSONSerialization.data(withJSONObject: paramaters, options: [])
        } catch {}

        let contentType = "application/x-www-form-urlencoded"

        urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(Constants().osTypeString, forHTTPHeaderField: "Device-Platform")

        
        Alamofire.request(urlRequest).validate(statusCode: 200..<300).validate(contentType: ["text/javascript"]).responseJSON { (response) in
			switch response.result {
            case.success(let data):
                do {
                    let theJSONData = try JSONSerialization.data(withJSONObject: data as Any, options: [])
                    let response = try JSONDecoder().decode(RM.self, from: theJSONData)
                    completion(response, nil, nil)
                }
                catch {
                    print(error)
                    do {
                        let theJSONData = try JSONSerialization.data(withJSONObject: data as Any, options: [])
                        let empty = try JSONDecoder().decode(ResponseEmpty.self, from: theJSONData)
                        completion(nil, nil, empty)
                    }
                    catch {
                        print(error)
                        completion(nil, nil, nil)
                    }
                }
            case .failure(let error):
                print(error)
                
                if let data = response.data {
                    let errResponse = String(data: data, encoding: .utf8)
                    completion(nil, (error, errResponse), nil)
                }
            }
        }
        
    }
    
    func hasInternet() -> Bool {
        if !(NetworkReachabilityManager()?.networkReachabilityStatus != .notReachable && NetworkReachabilityManager()?.networkReachabilityStatus != .unknown) {
            NotificationCenter.default.post(name: Notification.Name(Constants().obs_noInternetConnection), object: nil)
            return false
        }
        return true
    }

    func createURLString() {
        #if DEBUG
        path = TestEnv.shared.baseUrl.relativeString + endpoint
        #else
        path = ProdEnv.shared.baseUrl.relativeString + endpoint
        #endif
    }
}

protocol Request: class {
    var endpoint: String { get }
    var paramaters: [String: Any] { get }
    var checkInternet: Bool { get }
}
