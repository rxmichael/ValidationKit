//
//  Validator.swift
//  
//
//  Created by Michael Eid on 7/4/24.
//

import Foundation

public protocol Validator {
    typealias Input = String
    var validationRules: [ValidationRule] { get }
    func validate(_ input: Input) -> ValidationResult
    func isValid(_ input: Input) -> Bool
}

public extension Validator {
    func validate(_ input: Input) -> ValidationResult {
        let results = validationRules.sorted { $0.priority > $1.priority }.compactMap { $0.validate(input) }
        return ValidationResult.merge(results: results)
    }

    func isValid(_ input: Input) -> Bool {
        validate(input) == .valid
    }
}

public struct AlwaysValidValidator: Validator {
    public init() {}
    @ValidationRulesBuilder public var validationRules: [ValidationRule] {
        AlwaysValidRule(priority: 0)
    }

    public struct AlwaysValidRule: ValidationRule {
        public var priority: Int
        public var validationError: ValidationError = .init(message: "")
        public func validate(_ input: Input) -> ValidationResult {
            .valid
        }
    }
}

public struct BaseValidator: Validator {
    public init() {}
    @ValidationRulesBuilder public var validationRules: [ValidationRule] {
        NonAsciiRule(priority: 0)
    }
}

public struct EmailValidator: Validator {
    public init() {}
    @ValidationRulesBuilder public var validationRules: [ValidationRule] {
        NonAsciiRule(priority: 0)
        RegexValidationRule(pattern: .email, priority: 1)
    }
}

public struct FullNameValidator: Validator {
    public init() {}
    @ValidationRulesBuilder public var validationRules: [ValidationRule] {
        NonAsciiRule(priority: 0)
        FullNameValidationRule(priority: 1)
    }
}

public struct PhoneValidator: Validator {
    let style: Style

    public enum Style {
        case hyphens
        case areaCodeParentheses

        fileprivate var pattern: RegexValidationPattern {
            switch self {
            case .areaCodeParentheses: .phoneAreaCodeParentheses
            case .hyphens: .phone
            }
        }
    }

    public init(style: Style) {
        self.style = style
    }

    @ValidationRulesBuilder public var validationRules: [ValidationRule] {
        NonAsciiRule(priority: 0)
        RegexValidationRule(pattern: style.pattern, priority: 1)
    }
}

public struct SSNValidator: Validator {
    public init() {}
    @ValidationRulesBuilder public var validationRules: [ValidationRule] {
        NonAsciiRule(priority: 0)
        RegexValidationRule(pattern: .ssn, priority: 1)
    }
}

public struct ZipValidator: Validator {
    public init() {}
    @ValidationRulesBuilder public var validationRules: [ValidationRule] {
        NonAsciiRule(priority: 0)
        RegexValidationRule(pattern: .zip, priority: 1)
    }
}

public struct StateValidator: Validator {
    public init() {}
    @ValidationRulesBuilder public var validationRules: [ValidationRule] {
        NonAsciiRule(priority: 0)
        StateValidationRule(stateLookup: StateLookup.us, priority: 1)
    }
}

public struct CCVValidator: Validator {
    public init() {}
    @ValidationRulesBuilder public var validationRules: [ValidationRule] {
        NonAsciiRule(priority: 0)
        ValidationRuleRangeLength(min: 3, max: 4, priority: 1)
    }
}

public struct LastFourSSNValidator: Validator {
    public init() {}
    @ValidationRulesBuilder public var validationRules: [ValidationRule] {
        NonAsciiRule(priority: 0)
        ValidationRuleLength(length: 4, priority: 1)
    }
}

