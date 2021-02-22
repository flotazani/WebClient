import Fluent
import Foundation
import FluentPostgresDriver

struct CreateSchedule: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Schedule.schema)
            .field("id", .uuid, .identifier(auto: true))
            .field("user_id", .uuid, .references("users", "id"))
            .field("day", .string, .required)
            .field("start_time", .string, .required)
            .field("end_time", .string, .required)
            .field("subject_name", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Schedule.schema).delete()
    }
}
