import UIKit

class TestEnv: NSObject {
    static let shared = TestEnv()
 
    var baseUrl = URL(string: "https://itunes.apple.com")!
    var apiString = "/search"
}
