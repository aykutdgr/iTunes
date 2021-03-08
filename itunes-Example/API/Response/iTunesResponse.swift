import Foundation

// MARK: - iTunesResponse
public struct iTunesResponse: Codable {
    let results: [iTunesURL]?
}

// MARK: - iTunesURL
public struct iTunesURL: Codable {
    let screenshotUrls: [String]?
}
