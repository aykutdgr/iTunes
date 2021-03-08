// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let productCommentsResponse = try? newJSONDecoder().decode(ProductCommentsResponse.self, from: jsonData)

import Foundation

// MARK: - iTunesResponseResponse
// MARK: - Welcome
public struct iTunesResponse: Codable {
    let results: [Result]?
}

// MARK: - Result
public struct Result: Codable {
    let screenshotUrls: [String]?
}
