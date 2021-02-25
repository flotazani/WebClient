import Fluent
import Foundation
import FluentPostgresDriver

struct CreateNote: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Note.schema)
            .field("id", .uuid, .identifier(auto: false))
            .field("user_id", .uuid, .references("users", "id"))
            .field("body", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Note.schema).delete()
    }
}
