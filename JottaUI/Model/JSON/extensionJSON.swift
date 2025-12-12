import Foundation
// MARK: - Subscripts

public extension DecodeJSON {
    subscript(key key: String) -> DecodeJSON {
        get {
            guard case let .dictionary(dict) = storage else {
                let result = DecodeJSON.null
                result.error = error ?? .wrongType
                return result
            }

            guard let value = dict[key] else {
                let result = DecodeJSON.null
                result.error = .notExist
                return result
            }

            return DecodeJSON(value)
        }
        set {
            guard case var .dictionary(dict) = storage else {
                return
            }
            dict[key] = newValue.object
            storage = .dictionary(dict)
            if error == .notExist || error == .wrongType {
                error = nil
            }
        }
    }

    subscript(_ key: String) -> DecodeJSON {
        get { self[key: key] }
        set { self[key: key] = newValue }
    }

    subscript(index: Int) -> DecodeJSON {
        get {
            guard case let .array(arr) = storage else {
                let result = DecodeJSON.null
                result.error = error ?? .wrongType
                return result
            }

            guard arr.indices.contains(index) else {
                let result = DecodeJSON.null
                result.error = .indexOutOfBounds
                return result
            }

            return DecodeJSON(arr[index])
        }
        set {
            guard case var .array(arr) = storage else {
                return
            }

            guard arr.indices.contains(index) else {
                error = .indexOutOfBounds
                return
            }

            arr[index] = newValue.object
            storage = .array(arr)
            if error == .indexOutOfBounds || error == .wrongType {
                error = nil
            }
        }
    }
}

// MARK: - Type-Specific Accessors

public extension DecodeJSON {
    // Array
    var array: [DecodeJSON]? {
        guard case let .array(arr) = storage else { return nil }
        return arr.map { DecodeJSON($0) }
    }

    var arrayValue: [DecodeJSON] {
        array ?? []
    }

    var arrayObject: [Any]? {
        get {
            guard case let .array(arr) = storage else { return nil }
            return arr
        }
        set {
            object = newValue ?? NSNull()
        }
    }

    // Dictionary
    var dictionary: [String: DecodeJSON]? {
        guard case let .dictionary(dict) = storage else { return nil }
        return dict.mapValues { DecodeJSON($0) }
    }

    var dictionaryValue: [String: DecodeJSON] {
        dictionary ?? [:]
    }

    var dictionaryObject: [String: Any]? {
        get {
            guard case let .dictionary(dict) = storage else { return nil }
            return dict
        }
        set {
            object = newValue ?? NSNull()
        }
    }

    // Bool
    var bool: Bool? {
        get {
            guard case let .bool(value) = storage else { return nil }
            return value
        }
        set {
            object = newValue ?? NSNull()
        }
    }

    var boolValue: Bool {
        get {
            switch storage {
            case let .bool(value): return value
            case let .number(num): return num.boolValue
            case let .string(str):
                return ["true", "y", "t", "yes", "1"].contains {
                    str.caseInsensitiveCompare($0) == .orderedSame
                }
            default: return false
            }
        }
        set {
            object = newValue
        }
    }

    // String
    var string: String? {
        get {
            guard case let .string(value) = storage else { return nil }
            return value
        }
        set {
            object = newValue ?? NSNull()
        }
    }

    var stringValue: String {
        get {
            switch storage {
            case let .string(value): return value
            case let .number(num): return num.stringValue
            case let .bool(value): return String(value)
            default: return ""
            }
        }
        set {
            object = newValue
        }
    }

    // Number
    var number: NSNumber? {
        get {
            switch storage {
            case let .number(value): return value
            case let .bool(value): return NSNumber(value: value)
            default: return nil
            }
        }
        set {
            object = newValue ?? NSNull()
        }
    }

    var numberValue: NSNumber {
        get {
            switch storage {
            case let .number(value): return value
            case let .bool(value): return NSNumber(value: value)
            case let .string(str):
                let decimal = NSDecimalNumber(string: str)
                return decimal == .notANumber ? NSNumber(value: 0) : decimal
            default: return NSNumber(value: 0)
            }
        }
        set {
            object = newValue
        }
    }

    // Numeric types
    var int: Int? {
        get { number?.intValue }
        set { object = newValue.map { NSNumber(value: $0) } ?? NSNull() }
    }

    var intValue: Int {
        get { numberValue.intValue }
        set { object = NSNumber(value: newValue) }
    }

    var double: Double? {
        get { number?.doubleValue }
        set { object = newValue.map { NSNumber(value: $0) } ?? NSNull() }
    }

    var doubleValue: Double {
        get { numberValue.doubleValue }
        set { object = NSNumber(value: newValue) }
    }

    var float: Float? {
        get { number?.floatValue }
        set { object = newValue.map { NSNumber(value: $0) } ?? NSNull() }
    }

    var floatValue: Float {
        get { numberValue.floatValue }
        set { object = NSNumber(value: newValue) }
    }

    // URL
    var url: URL? {
        get {
            guard case let .string(str) = storage else { return nil }

            if str.range(of: "%[0-9A-Fa-f]{2}", options: .regularExpression) != nil {
                return URL(string: str)
            } else if let encoded = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return URL(string: encoded)
            }
            return nil
        }
        set {
            if let newValue {
                object = newValue.absoluteString
            } else {
                object = NSNull()
            }
        }
    }

    // Null
    var null: NSNull? {
        get {
            guard case .null = storage else { return nil }
            return NSNull()
        }
        set {
            _ = newValue
            object = NSNull()
        }
    }

    func exists() -> Bool {
        guard let error else { return true }
        return !(400 ... 1000).contains(error.rawValue)
    }
}

// MARK: - CustomStringConvertible

extension DecodeJSON: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        rawString() ?? "unknown"
    }

    public var debugDescription: String {
        description
    }
}

// MARK: - Raw Representation

public extension DecodeJSON {
    func rawData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        guard JSONSerialization.isValidJSONObject(object) else {
            throw JSONError.invalidJSON
        }
        return try JSONSerialization.data(withJSONObject: object, options: options)
    }

    func rawString(
        options: JSONSerialization.WritingOptions = .prettyPrinted,
        encoding: String.Encoding = .utf8
    ) -> String? {
        guard let data = try? rawData(options: options) else { return nil }
        return String(data: data, encoding: encoding)
    }
}

// MARK: - Comparable

extension DecodeJSON: Comparable {
    public static func == (lhs: DecodeJSON, rhs: DecodeJSON) -> Bool {
        switch (lhs.storage, rhs.storage) {
        case let (.number(left), .number(right)): return left == right
        case let (.string(left), .string(right)): return left == right
        case let (.bool(left), .bool(right)): return left == right
        case let (.array(left), .array(right)): return left as NSArray == right as NSArray
        case let (.dictionary(left), .dictionary(right)): return left as NSDictionary == right as NSDictionary
        case (.null, .null): return true
        default: return false
        }
    }

    public static func < (lhs: DecodeJSON, rhs: DecodeJSON) -> Bool {
        switch (lhs.storage, rhs.storage) {
        case let (.number(left), .number(right)): return left < right
        case let (.string(left), .string(right)): return left < right
        default: return false
        }
    }
}

// MARK: - Codable

extension DecodeJSON: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch storage {
        case .null:
            try container.encodeNil()
        case let .bool(value):
            try container.encode(value)
        case let .number(value):
            try container.encode(value.doubleValue)
        case let .string(value):
            try container.encode(value)
        case .array:
            try container.encode(arrayValue)
        case .dictionary:
            try container.encode(dictionaryValue)
        }
    }
}

// MARK: - NSNumber Bool Detection Helper
public extension NSNumber {
    /// Detects if this NSNumber represents a Bool (bridged from Swift Bool / CFBoolean)
    var jsonIsBool: Bool {
        // CFBoolean instances are singletons for true/false and a subclass of NSNumber
        // Also check objCType == "c" (char) which is the canonical bool encoding
        let isCFBoolean = CFGetTypeID(self) == CFBooleanGetTypeID()
        let isObjCBool = String(cString: self.objCType) == "c"
        return isCFBoolean || isObjCBool
    }
}

// MARK: - NSNumber Comparison Operators

public func == (lhs: NSNumber, rhs: NSNumber) -> Bool {
    guard lhs.jsonIsBool == rhs.jsonIsBool else { return false }
    return lhs.compare(rhs) == .orderedSame
}

public func < (lhs: NSNumber, rhs: NSNumber) -> Bool {
    guard lhs.jsonIsBool == rhs.jsonIsBool else { return false }
    return lhs.compare(rhs) == .orderedAscending
}
