import UIKit


extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var data: Data {
        return try! JSONEncoder().encode(self)
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] ?? [:]
    }
}

extension Dictionary {
    func stringFromHttpParameters() -> String {

        var parametersString = ""
        for (key, value) in self {
            if let key = key as? String,
               let value = value as? String {
                parametersString = parametersString + key + "=" + value + "&"
            }
        }
        parametersString = String(parametersString[..<parametersString.index(before: parametersString.endIndex)])
        return parametersString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

extension Int {
    var byteSize: String {
        return ByteCountFormatter().string(fromByteCount: Int64(self))
    }
}
