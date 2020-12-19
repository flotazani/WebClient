//
//  File.swift
//  
//
//  Created by Andrei Konovalov on 13.12.2020.
//

import Foundation

import Fluent

struct CreateUsers: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema)
            .field("id", .uuid, .identifier(auto: true))
            .field("username", .string, .required)
            .unique(on: "username")
            .field("password_hash", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
