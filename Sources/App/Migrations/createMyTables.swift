import Fluent
import Foundation
import FluentPostgresDriver

struct CreateMyTables: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}
