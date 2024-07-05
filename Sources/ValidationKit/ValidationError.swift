//
//  ValidationError.swift
//  
//
//  Created by Michael Eid on 7/4/24.
//

import Foundation

protocol ValidationErrorType: Error {
    var message: String { get }
    var recovery: String? { get }
}

public struct ValidationError: ValidationErrorType, Equatable, Hashable {
    let message: String
    let recovery: String?

    public init(message: String, recovery: String? = nil) {
        self.message = message
        self.recovery = recovery
    }
}

