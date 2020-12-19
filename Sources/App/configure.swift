import Fluent
import FluentPostgresDriver
import Vapor

public struct PostgresDefaults {
    public static let hostname = "localhost"
    public static let username = "andreikonovalov"
    public static let port = 5432
    public static let databasename = "webproject"
    public static let password = ""
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    

    app.databases.use(.postgres(
        hostname: PostgresDefaults.hostname,
        port: PostgresDefaults.port,
        username: PostgresDefaults.username,
        password: PostgresDefaults.password,
        database: PostgresDefaults.databasename),
                      as: .psql)

    app.migrations.add(CreateUsers())
    app.migrations.add(CreateTokens())

    try app.autoMigrate().wait()

    // register routes
    try routes(app)
}
