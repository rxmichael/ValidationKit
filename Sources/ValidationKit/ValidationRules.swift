//
//  ValidationRules.swift
//
//
//  Created by Michael Eid on 7/4/24.
//

import Foundation

public typealias ValidationRulesBuilder = ArrayBuilder<ValidationRule>

public protocol ValidationRule {
    typealias Input = String
    var priority: Int { get set }
    var validationError: ValidationError { get set }
    func validate(_ input: Input) -> ValidationResult
}

public struct NonAsciiRule: ValidationRule {
    public var priority: Int
    public var validationError: ValidationError = .init(message: "Unsupported character")

    public func validate(_ input: Input) -> ValidationResult {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.canBeConverted(to: .ascii) ? .valid : .invalid(Set([validationError]))
    }
}

public struct NonEmptyRule: ValidationRule {
    public var priority: Int
    public var validationError: ValidationError = .init(message: "Must not be empty")

    public func validate(_ input: Input) -> ValidationResult {
        !input.isEmpty ? .valid : .invalid(Set([validationError]))
    }
}

public struct ValidationRuleLength: ValidationRule {
    public var priority: Int
    public var validationError: ValidationError

    private let length: Int

    init(length: Int, priority: Int) {
        self.length = length
        self.validationError = .init(message: "Must be equal to \(length)")
        self.priority = priority
    }

    public func validate(_ input: Input) -> ValidationResult {
        input.count == length ? .valid : .invalid(Set([validationError]))
    }
}

public struct ValidationRuleRangeLength: ValidationRule {
    public var priority: Int
    public var validationError: ValidationError

    private let min: Int
    private let max: Int

    init(min: Int, max: Int, priority: Int) {
        self.min = min
        self.max = max
        self.validationError = .init(message: "Must be between \(min) \(max)")
        self.priority = priority
    }

    public func validate(_ input: Input) -> ValidationResult {
        return (min...max ~= input.count) ? .valid : .invalid(Set([validationError]))
    }
}

public struct FullNameValidationRule: ValidationRule {
    public var priority: Int
    public var validationError: ValidationError  = .init(message: "Invalid Name")

    public func validate(_ input: Input) -> ValidationResult {
        let names = input.split { $0 == " " }.map { String($0) }
        return (names.count > 1 &&  names.allSatisfy { $0.count > 1 }) ? .valid : .invalid(Set([validationError]))
    }
}

public struct RegexValidationRule: ValidationRule {
    public var priority: Int
    public var validationError: ValidationError

    private let pattern: RegexValidationPattern

    init(pattern: RegexValidationPattern, priority: Int) {
        self.pattern = pattern
        self.validationError = .init(message: pattern.errorDescription)
        self.priority = priority
    }

    public func validate(_ input: Input) -> ValidationResult {
        return input.matches(pattern.rawValue) ? .valid : .invalid(Set([validationError]))
    }
}

public struct StateValidationRule: ValidationRule {
    public var priority: Int
    public var validationError: ValidationError  = .init(message: "Invalid State")

    private let stateLookup: [String: String]

    init(stateLookup: [String: String], priority: Int) {
        self.stateLookup = stateLookup
        self.priority = priority
    }

    public func validate(_ input: Input) -> ValidationResult {
        return stateLookup.values.contains(input) ? .valid : .invalid(Set([validationError]))
    }
}

enum StateLookup {
    static let us: [String: String] = [
        "Alaska": "AK", "Alabama": "AL", "Arkansas": "AR", "American Samoa": "AS", "Arizona": "AZ", "California": "CA", "Colorado": "CO", "Connecticut": "CT", "District of Columbia": "DC", "Delaware": "DE", "Florida": "FL", "Georgia": "GA", "Guam": "GU", "Hawaii": "HI", "Iowa": "IA", "Idaho": "ID", "Illinois": "IL", "Indiana": "IN", "Kansas": "KS", "Kentucky": "KY", "Louisiana": "LA", "Massachusetts": "MA", "Maryland": "MD", "Maine": "ME", "Michigan": "MI", "Minnesota": "MN", "Missouri": "MO", "Mississippi": "MS", "Montana": "MT", "North Carolina": "NC", "North Dakota": "ND", "Nebraska": "NE", "New Hampshire": "NH", "New Jersey": "NJ", "New Mexico": "NM", "Nevada": "NV", "New York": "NY", "Ohio": "OH", "Oklahoma": "OK", "Oregon": "OR", "Pennsylvania": "PA", "Puerto Rico": "PR", "Rhode Island": "RI", "South Carolina": "SC", "South Dakota": "SD", "Tennessee": "TN", "Texas": "TX", "Utah": "UT", "Virginia": "VA", "Virgin Islands": "VI", "Vermont": "VT", "Washington": "WA", "Wisconsin": "WI", "West Virginia": "WV", "Wyoming": "WY"
    ]
}

enum RegexValidationPattern: String {
    case phone = "^[0-9]{3}[-][0-9]{3}[-][0-9]{4}$"
    case phoneAreaCodeParentheses = "^[(][0-9]{3}[)][ ][0-9]{3}[-][0-9]{4}$"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case ssn = "^[0-9]{3}[-]{1}[0-9]{2}[-]{1}[0-9]{4}$"
    case zip = "^[0-9]{5}"

    var errorDescription: String {
        switch self {
        case .phoneAreaCodeParentheses: return "Invalid Phone"
        case .phone: return "Invalid Phone"
        case .email: return "Invalid Email"
        case .ssn: return "Invalid SSN"
        case .zip: return "Invalid Zip"
        }
    }
}


extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
