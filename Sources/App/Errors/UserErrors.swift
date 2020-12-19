//
//  File.swift
//  
//
//  Created by Andrei Konovalov on 13.12.2020.
//

import Foundation
import Vapor

enum UserError {
    case usernameTaken
}

extension UserError: AbortError {
    var description: String {
        reason
    }

    var status: HTTPResponseStatus {
        switch self {
        case .usernameTaken: return .conflict
        }
    }

    var reason: String {
        switch self {
        case .usernameTaken: return "Username already taken"
        }
    }
}
