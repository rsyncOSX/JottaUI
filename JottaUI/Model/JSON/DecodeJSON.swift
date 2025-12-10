import Foundation

fileprivate extension NSNumber {
    var isBool: Bool {
        CFGetTypeID(self) == CFBooleanGetTypeID()
    }
}

// swiftlint:disable identifier_name

// MARK: - Error

public enum JSONError: Int, Error {
    case unsupportedType = 999
    case indexOutOfBounds = 900
    case elementTooDeep = 902
    case wrongType = 901
    case notExist = 500
    case invalidJSON = 490
}

extension JSONError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unsupportedType:
            return "Unsupported type"
        case .indexOutOfBounds:
            return "Array index is out of bounds"
        case .wrongType:
            return "Cannot merge JSONs with different top-level types"
        case .notExist:
            return "Dictionary key does not exist"
        case .invalidJSON:
            return "JSON is invalid"
        case .elementTooDeep:
            return "Element too deep. Increase maxObjectDepth and ensure there are no reference loops"
        }
    }
}

// MARK: - JSON Type

public enum JSONType {
    case number
    case string
    case bool
    case array
    case dictionary
    case null
    case unknown
}

// MARK: - JSON Base

public final class DecodeJSON {
    // MARK: - Storage

    private enum Storage {
        case array([Any])
        case dictionary([String: Any])
        case string(String)
        case number(NSNumber)
        case bool(Bool)
        case null
    }

    private var storage: Storage
    public private(set) var error: JSONError?

    public var type: JSONType {
        switch storage {
        case .array: return .array
        case .dictionary: return .dictionary
        case .string: return .string
        case .number: return .number
        case .bool: return .bool
        case .null: return .null
        }
    }

    // MARK: - Initializers

    public convenience init(data: Data, options: JSONSerialization.ReadingOptions = []) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: options)
        self.init(object)
    }

    public convenience init(parseJSON jsonString: String) {
        if let data = jsonString.data(using: .utf8) {
            self.init(data)
        } else {
            self.init(NSNull())
        }
    }

    public convenience init(_ object: Any) {
        switch object {
        case let data as Data:
            if let obj = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.init(jsonObject: obj)
            } else {
                self.init(NSNull())
            }
        default:
            self.init(jsonObject: object)
        }
    }

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.init(NSNull())
            return
        }

        if let bool = try? container.decode(Bool.self) {
            self.init(bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else if let double = try? container.decode(Double.self) {
            self.init(double)
        } else if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let array = try? container.decode([DecodeJSON].self) {
            self.init(array.map(\.object))
        } else if let dictionary = try? container.decode([String: DecodeJSON].self) {
            self.init(dictionary.mapValues { $0.object })
        } else {
            self.init(NSNull())
        }
    }
    
    private init(jsonObject: Any) {
        let unwrapped = Self.unwrap(jsonObject)

        switch unwrapped {
        case let number as NSNumber:
            if number.isBool {
                storage = .bool(number.boolValue)
            } else {
                storage = .number(number)
            }
        case let string as String:
            storage = .string(string)
        case is NSNull:
            storage = .null
        case let array as [Any]:
            storage = .array(array)
        case let dictionary as [String: Any]:
            storage = .dictionary(dictionary)
        default:
            storage = .null
            error = .unsupportedType
        }
    }

    // MARK: - Static Properties

    public static var null: DecodeJSON {
        DecodeJSON(NSNull())
    }

    // MARK: - Object Access

    public var object: Any {
        get {
            switch storage {
            case let .array(value): return value
            case let .dictionary(value): return value
            case let .string(value): return value
            case let .number(value): return value
            case let .bool(value): return value
            case .null: return NSNull()
            }
        }
        set {
            switch DecodeJSON.unwrap(newValue) {
            case let number as NSNumber:
                if number.isBool {
                    storage = .bool(number.boolValue)
                } else {
                    storage = .number(number)
                }
            case let string as String:
                storage = .string(string)
            case is NSNull:
                storage = .null
                error = nil
            case let array as [Any]:
                storage = .array(array)
                error = nil
            case let dictionary as [String: Any]:
                storage = .dictionary(dictionary)
                error = nil
            default:
                storage = .null
                error = .unsupportedType
            }
        }
    }

    // MARK: - Merging

    public func merge(with other: DecodeJSON) throws {
        try merge(with: other, typecheck: true)
    }

    public func merged(with other: DecodeJSON) throws -> DecodeJSON {
        let copy = DecodeJSON(self.object)
        copy.error = self.error
        try copy.merge(with: other, typecheck: true)
        return copy
    }

    private func merge(with other: DecodeJSON, typecheck: Bool) throws {
        guard type == other.type else {
            if typecheck {
                throw JSONError.wrongType
            } else {
                self.storage = other.storage
                self.error = other.error
                return
            }
        }

        switch (storage, other.storage) {
        case (.dictionary(var dict), let .dictionary(otherDict)):
            for (key, _) in otherDict {
                let value = self[key: key]
                try value.merge(with: other[key: key], typecheck: false)
                dict[key] = value.object
            }
            storage = .dictionary(dict)

        case let (.array(arr), .array(otherArr)):
            storage = .array(arr + otherArr)

        default:
            self.storage = other.storage
            self.error = other.error
        }
    }

    // MARK: - Helper Methods

    private static func unwrap(_ object: Any) -> Any {
        switch object {
        case let json as DecodeJSON:
            return unwrap(json.object)
        case let array as [Any]:
            return array.map(unwrap)
        case let dictionary as [String: Any]:
            return dictionary.mapValues(unwrap)
        default:
            return object
        }
    }
}

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
        case let (.number(l), .number(r)): return l == r
        case let (.string(l), .string(r)): return l == r
        case let (.bool(l), .bool(r)): return l == r
        case let (.array(l), .array(r)): return l as NSArray == r as NSArray
        case let (.dictionary(l), .dictionary(r)): return l as NSDictionary == r as NSDictionary
        case (.null, .null): return true
        default: return false
        }
    }

    public static func < (lhs: DecodeJSON, rhs: DecodeJSON) -> Bool {
        switch (lhs.storage, rhs.storage) {
        case let (.number(l), .number(r)): return l < r
        case let (.string(l), .string(r)): return l < r
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

// MARK: - NSNumber Comparison Operators

private func == (lhs: NSNumber, rhs: NSNumber) -> Bool {
    guard lhs.isBool == rhs.isBool else { return false }
    return lhs.compare(rhs) == .orderedSame
}

private func < (lhs: NSNumber, rhs: NSNumber) -> Bool {
    guard lhs.isBool == rhs.isBool else { return false }
    return lhs.compare(rhs) == .orderedAscending
}
// swiftlint:enable identifier_name
