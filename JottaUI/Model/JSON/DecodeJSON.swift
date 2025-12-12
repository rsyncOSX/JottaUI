import Foundation

fileprivate extension NSNumber {
    var isBool: Bool {
        CFGetTypeID(self) == CFBooleanGetTypeID()
    }
}

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

    public enum Storage {
        case array([Any])
        case dictionary([String: Any])
        case string(String)
        case number(NSNumber)
        case bool(Bool)
        case null
    }

    public var storage: Storage
    public var error: JSONError?

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
