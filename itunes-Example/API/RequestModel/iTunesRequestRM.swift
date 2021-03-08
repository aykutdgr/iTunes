import Foundation

struct iTunesRequestRM: Codable {
    var media: String?
    var limit: String?
    var term: String?
    
    enum CodingKeys: String, CodingKey {
        case media
        case limit
        case term
    }
}
