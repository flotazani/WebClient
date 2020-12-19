//
//  File.swift
//  
//
//  Created by Andrei Konovalov on 11.12.2020.
//

import Foundation
import Fluent

// 1
struct CreateTokens: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // 2
        database.schema(Token.schema)
            // 3
            .field("id", .uuid, .identifier(auto: true))
            .field("user_id", .uuid, .references("users", "id"))
            .field("value", .string, .required)
            .unique(on: "value")
            .field("source", .int, .required)
            .field("created_at", .datetime, .required)
            .field("expires_at", .datetime)
            // 4
            .create()
    }

    // 5
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.schema).delete()
    }
}
