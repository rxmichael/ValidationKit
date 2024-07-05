//
//  ValidationResult.swift
//  
//
//  Created by Michael Eid on 7/4/24.
//

import Foundation

public enum ValidationResult {
    case valid
    case invalid(Set<ValidationError>)

    var isValid: Bool {
        return self == .valid
    }

    var errors: Set<ValidationError>? {
        switch self {
        case .valid:
            return nil
        case .invalid(let errors):
            return errors
        }
    }

    func merge(with result: ValidationResult) -> ValidationResult {
        switch self {
        case .valid: return result
        case .invalid(let errors):
            switch result {
            case .valid:
                return self
            case .invalid(let otherErrors):
                return .invalid(errors.union(otherErrors))
            }
        }
    }

    func merge(with results: [ValidationResult]) -> ValidationResult {
        return results.reduce(self) { return $0.merge(with: $1) }
    }

    static func merge(results: [ValidationResult]) -> ValidationResult {
        return ValidationResult.valid.merge(with: results)
    }
}

extension ValidationResult: Equatable {
    static public func ==(lhs: ValidationResult, rhs: ValidationResult) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid): return true
        case (let .invalid(lhsErrors), let .invalid(rhsErrors)): return lhsErrors == rhsErrors
        default: return false
        }
    }
}

