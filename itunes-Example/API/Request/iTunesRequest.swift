import Foundation

class iTunesRequest: NetworkRequest<iTunesRequestRM, iTunesResponse> {
    
    override init() {
        super.init()
        endpoint = "/search"
        checkInternet = true
    }
    
}
