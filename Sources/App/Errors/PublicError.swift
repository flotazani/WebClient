//
//  File.swift
//  
//
//  Created by Andrei Konovalov on 15.02.2021.
//

import Foundation
import Vapor

enum PublicEror {
    case couldNotCast
    case noData
}

extension PublicEror: AbortError {
    var description: String {
        reason
    }

    var status: HTTPResponseStatus {
        switch self {
        case .couldNotCast: return .conflict
        case .noData: return .notFound
        }
    }

    var reason: String {
        switch self {
        case .couldNotCast: return "Couldn't cast data to public struct"
        case .noData: return "No data found"
        }
    }
}
