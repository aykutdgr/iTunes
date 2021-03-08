import UIKit

extension NSMutableDictionary {
    func objectForKeyWithEmptyString(key: Any) -> Any? {
        return self.object(forKey: key) ?? key
    }
}

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

extension UIDevice {
    func platform() -> String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
    
    func build() -> String {
        var size = 0
        sysctlbyname("kern.osversion", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("kern.osversion", &machine, &size, nil, 0)
        return String(cString: machine)
    }
}

extension String {
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }
    
    func ranges(of searchString: String) -> [Range<String.Index>] {
        let _indices = indices(of: searchString)
        let count = searchString.count
        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
    }
    
    func stringWithString(fullString: NSMutableAttributedString, stringToReplace: String, newStringPart: String) -> NSMutableAttributedString {
        let mutableAttributedString = fullString.mutableCopy() as! NSMutableAttributedString
        let mutableString = mutableAttributedString.mutableString
        while mutableString.contains(stringToReplace) {
            let rangeOfStringToBeReplaced = mutableString.range(of: stringToReplace)
            mutableAttributedString.replaceCharacters(in: rangeOfStringToBeReplaced, with: newStringPart)
        }
        return mutableAttributedString
    }
    
    func addBoldText(fullString: String, boldPartOfString: String, baseFont: UIFont, boldFont: UIFont) -> NSMutableAttributedString {
        let baseFontAttribute = [NSAttributedString.Key.font: baseFont]
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont]
        let attributedString = NSMutableAttributedString(string: fullString, attributes: baseFontAttribute)
        attributedString.addAttributes(boldFontAttribute, range: NSRange(fullString.range(of: boldPartOfString) ?? fullString.startIndex..<fullString.endIndex, in: fullString))
        return attributedString
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

