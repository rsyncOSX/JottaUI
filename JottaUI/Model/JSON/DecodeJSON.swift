
import Foundation

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

public struct DecodeJSON {
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
    
    public init(data: Data, options: JSONSerialization.ReadingOptions = []) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: options)
        self.init(object)
    }
    
    public init(parseJSON jsonString: String) {
        if let data = jsonString.data(using: .utf8) {
            self.init(data)
        } else {
            self.init(NSNull())
        }
    }
    
    public init(_ object: Any) {
        switch object {
        case let data as Data:
            if let parsed = try? DecodeJSON(data: data) {
                self = parsed
            } else {
                self.init(NSNull())
            }
        default:
            self.init(jsonObject: object)
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
            case .array(let value): return value
            case .dictionary(let value): return value
            case .string(let value): return value
            case .number(let value): return value
            case .bool(let value): return value
            case .null: return NSNull()
            }
        }
        set {
            self = DecodeJSON(newValue)
        }
    }
    
    // MARK: - Merging
    
    public mutating func merge(with other: DecodeJSON) throws {
        try merge(with: other, typecheck: true)
    }
    
    public func merged(with other: DecodeJSON) throws -> DecodeJSON {
        var merged = self
        try merged.merge(with: other, typecheck: true)
        return merged
    }
    
    private mutating func merge(with other: DecodeJSON, typecheck: Bool) throws {
        guard type == other.type else {
            if typecheck {
                throw JSONError.wrongType
            } else {
                self = other
                return
            }
        }
        
        switch (storage, other.storage) {
        case (.dictionary(var dict), .dictionary(let otherDict)):
            for (key, _) in otherDict {
                var value = self[key]
                try value.merge(with: other[key], typecheck: false)
                dict[key] = value.object
            }
            self.storage = .dictionary(dict)
            
        case (.array(let arr), .array(let otherArr)):
            self.storage = .array(arr + otherArr)
            
        default:
            self = other
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

// MARK: - Collection Conformance

extension DecodeJSON: Collection {
    public struct Index: Comparable {
        fileprivate enum Value {
            case array(Int)
            case dictionary(Dictionary<String, Any>.Index)
            case null
        }
        
        fileprivate let value: Value
        
        public static func == (lhs: Index, rhs: Index) -> Bool {
            switch (lhs.value, rhs.value) {
            case (.array(let l), .array(let r)): return l == r
            case (.dictionary(let l), .dictionary(let r)): return l == r
            case (.null, .null): return true
            default: return false
            }
        }
        
        public static func < (lhs: Index, rhs: Index) -> Bool {
            switch (lhs.value, rhs.value) {
            case (.array(let l), .array(let r)): return l < r
            case (.dictionary(let l), .dictionary(let r)): return l < r
            default: return false
            }
        }
    }
    
    public var startIndex: Index {
        switch storage {
        case .array(let arr):
            return Index(value: .array(arr.startIndex))
        case .dictionary(let dict):
            return Index(value: .dictionary(dict.startIndex))
        default:
            return Index(value: .null)
        }
    }
    
    public var endIndex: Index {
        switch storage {
        case .array(let arr):
            return Index(value: .array(arr.endIndex))
        case .dictionary(let dict):
            return Index(value: .dictionary(dict.endIndex))
        default:
            return Index(value: .null)
        }
    }
    
    public func index(after i: Index) -> Index {
        switch (storage, i.value) {
        case (.array(let arr), .array(let idx)):
            return Index(value: .array(arr.index(after: idx)))
        case (.dictionary(let dict), .dictionary(let idx)):
            return Index(value: .dictionary(dict.index(after: idx)))
        default:
            return Index(value: .null)
        }
    }
    
    public subscript(position: Index) -> (String, DecodeJSON) {
        switch (storage, position.value) {
        case (.array(let arr), .array(let idx)):
            return (String(idx), DecodeJSON(arr[idx]))
        case (.dictionary(let dict), .dictionary(let idx)):
            let pair = dict[idx]
            return (pair.key, DecodeJSON(pair.value))
        default:
            return ("", .null)
        }
    }
}

// MARK: - Subscript

public protocol JSONSubscriptType {
    var jsonKey: JSONKey { get }
}

public enum JSONKey {
    case index(Int)
    case key(String)
}

extension Int: JSONSubscriptType {
    public var jsonKey: JSONKey { .index(self) }
}

extension String: JSONSubscriptType {
    public var jsonKey: JSONKey { .key(self) }
}

extension DecodeJSON {
    private subscript(index index: Int) -> DecodeJSON {
        get {
            guard case .array(let arr) = storage else {
                var result = DecodeJSON.null
                result.error = error ?? .wrongType
                return result
            }
            
            guard arr.indices.contains(index) else {
                var result = DecodeJSON.null
                result.error = .indexOutOfBounds
                return result
            }
            
            return DecodeJSON(arr[index])
        }
        set {
            guard case .array(var arr) = storage,
                  arr.indices.contains(index),
                  newValue.error == nil else { return }
            
            arr[index] = newValue.object
            storage = .array(arr)
        }
    }
    
    private subscript(key key: String) -> DecodeJSON {
        get {
            guard case .dictionary(let dict) = storage else {
                var result = DecodeJSON.null
                result.error = error ?? .wrongType
                return result
            }
            
            guard let value = dict[key] else {
                var result = DecodeJSON.null
                result.error = .notExist
                return result
            }
            
            return DecodeJSON(value)
        }
        set {
            guard case .dictionary(var dict) = storage,
                  newValue.error == nil else { return }
            
            dict[key] = newValue.object
            storage = .dictionary(dict)
        }
    }
    
    public subscript(path: [JSONSubscriptType]) -> DecodeJSON {
        get {
            path.reduce(self) { json, key in
                switch key.jsonKey {
                case .index(let idx): return json[index: idx]
                case .key(let k): return json[key: k]
                }
            }
        }
        set {
            guard !path.isEmpty else { return }
            
            if path.count == 1 {
                switch path[0].jsonKey {
                case .index(let idx): self[index: idx] = newValue
                case .key(let k): self[key: k] = newValue
                }
            } else {
                let nextPath = Array(path.dropFirst())
                let firstKey = path[0]
                var nextJSON: DecodeJSON
                switch firstKey.jsonKey {
                case .index(let idx): nextJSON = self[index: idx]
                case .key(let k): nextJSON = self[key: k]
                }
                nextJSON[nextPath] = newValue
                switch firstKey.jsonKey {
                case .index(let idx): self[index: idx] = nextJSON
                case .key(let k): self[key: k] = nextJSON
                }
            }
        }
    }
    
    public subscript(path: JSONSubscriptType...) -> DecodeJSON {
        get { self[path] }
        set { self[path] = newValue }
    }
}

// MARK: - Literal Conformances

extension DecodeJSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension DecodeJSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

extension DecodeJSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
}

extension DecodeJSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.init(value)
    }
}

extension DecodeJSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Any)...) {
        let dictionary = Dictionary(elements, uniquingKeysWith: { $1 })
        self.init(dictionary)
    }
}

extension DecodeJSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Any...) {
        self.init(elements)
    }
}

// MARK: - Raw Representation

extension DecodeJSON: RawRepresentable {
    public init?(rawValue: Any) {
        let json = DecodeJSON(rawValue)
        guard json.type != .unknown else { return nil }
        self = json
    }
    
    public var rawValue: Any {
        object
    }
    
    public func rawData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        guard JSONSerialization.isValidJSONObject(object) else {
            throw JSONError.invalidJSON
        }
        return try JSONSerialization.data(withJSONObject: object, options: options)
    }
    
    public func rawString(options: JSONSerialization.WritingOptions = .prettyPrinted, encoding: String.Encoding = .utf8) -> String? {
        guard let data = try? rawData(options: options) else { return nil }
        return String(data: data, encoding: encoding)
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

// MARK: - Type-Specific Accessors

public extension DecodeJSON {
    // Array
    var array: [DecodeJSON]? {
        guard case .array(let arr) = storage else { return nil }
        return arr.map { DecodeJSON($0) }
    }
    
    var arrayValue: [DecodeJSON] {
        array ?? []
    }
    
    var arrayObject: [Any]? {
        get {
            guard case .array(let arr) = storage else { return nil }
            return arr
        }
        set {
            object = newValue ?? NSNull()
        }
    }
    
    // Dictionary
    var dictionary: [String: DecodeJSON]? {
        guard case .dictionary(let dict) = storage else { return nil }
        return dict.mapValues { DecodeJSON($0) }
    }
    
    var dictionaryValue: [String: DecodeJSON] {
        dictionary ?? [:]
    }
    
    var dictionaryObject: [String: Any]? {
        get {
            guard case .dictionary(let dict) = storage else { return nil }
            return dict
        }
        set {
            object = newValue ?? NSNull()
        }
    }
    
    // Bool
    var bool: Bool? {
        get {
            guard case .bool(let value) = storage else { return nil }
            return value
        }
        set {
            object = newValue ?? NSNull()
        }
    }
    
    var boolValue: Bool {
        get {
            switch storage {
            case .bool(let value): return value
            case .number(let num): return num.boolValue
            case .string(let str):
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
            guard case .string(let value) = storage else { return nil }
            return value
        }
        set {
            object = newValue ?? NSNull()
        }
    }
    
    var stringValue: String {
        get {
            switch storage {
            case .string(let value): return value
            case .number(let num): return num.stringValue
            case .bool(let value): return String(value)
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
            case .number(let value): return value
            case .bool(let value): return NSNumber(value: value)
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
            case .number(let value): return value
            case .bool(let value): return NSNumber(value: value)
            case .string(let str):
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
        set { object = newValue.map(NSNumber.init) ?? NSNull() }
    }
    
    var intValue: Int {
        get { numberValue.intValue }
        set { object = NSNumber(value: newValue) }
    }
    
    var double: Double? {
        get { number?.doubleValue }
        set { object = newValue.map(NSNumber.init) ?? NSNull() }
    }
    
    var doubleValue: Double {
        get { numberValue.doubleValue }
        set { object = NSNumber(value: newValue) }
    }
    
    var float: Float? {
        get { number?.floatValue }
        set { object = newValue.map(NSNumber.init) ?? NSNull() }
    }
    
    var floatValue: Float {
        get { numberValue.floatValue }
        set { object = NSNumber(value: newValue) }
    }
    
    // URL
    var url: URL? {
        get {
            guard case .string(let str) = storage else { return nil }
            
            if str.range(of: "%[0-9A-Fa-f]{2}", options: .regularExpression) != nil {
                return URL(string: str)
            } else if let encoded = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return URL(string: encoded)
            }
            return nil
        }
        set {
            object = newValue?.absoluteString ?? NSNull()
        }
    }
    
    // Null
    var null: NSNull? {
        get {
            guard case .null = storage else { return nil }
            return NSNull()
        }
        set {
            object = NSNull()
        }
    }
    
    func exists() -> Bool {
        guard let error = error else { return true }
        return !(400...1000).contains(error.rawValue)
    }
}

// MARK: - Comparable

extension DecodeJSON: Comparable {
    public static func == (lhs: DecodeJSON, rhs: DecodeJSON) -> Bool {
        switch (lhs.storage, rhs.storage) {
        case (.number(let l), .number(let r)): return l == r
        case (.string(let l), .string(let r)): return l == r
        case (.bool(let l), .bool(let r)): return l == r
        case (.array(let l), .array(let r)): return l as NSArray == r as NSArray
        case (.dictionary(let l), .dictionary(let r)): return l as NSDictionary == r as NSDictionary
        case (.null, .null): return true
        default: return false
        }
    }
    
    public static func < (lhs: DecodeJSON, rhs: DecodeJSON) -> Bool {
        switch (lhs.storage, rhs.storage) {
        case (.number(let l), .number(let r)): return l < r
        case (.string(let l), .string(let r)): return l < r
        default: return false
        }
    }
}

// MARK: - Codable

extension DecodeJSON: Codable {
    public init(from decoder: Decoder) throws {
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
            self.init(array.map { $0.object })
        } else if let dictionary = try? container.decode([String: DecodeJSON].self) {
            self.init(dictionary.mapValues { $0.object })
        } else {
            self.init(NSNull())
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch storage {
        case .null:
            try container.encodeNil()
        case .bool(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value.doubleValue)
        case .string(let value):
            try container.encode(value)
        case .array:
            try container.encode(arrayValue)
        case .dictionary:
            try container.encode(dictionaryValue)
        }
    }
}

// MARK: - NSNumber Extensions

private extension NSNumber {
    var isBool: Bool {
        String(cString: objCType) == String(cString: NSNumber(value: true).objCType)
    }
}

private func == (lhs: NSNumber, rhs: NSNumber) -> Bool {
    guard lhs.isBool == rhs.isBool else { return false }
    return lhs.compare(rhs) == .orderedSame
}

private func < (lhs: NSNumber, rhs: NSNumber) -> Bool {
    guard lhs.isBool == rhs.isBool else { return false }
    return lhs.compare(rhs) == .orderedAscending
}

