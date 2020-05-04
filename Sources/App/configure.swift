import FluentPostgreSQL
import Vapor
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    
    let databaseConfig: PostgreSQLDatabaseConfig
    if let url = Environment.get("postgres://bsiuvbgsfilmwh:ed7967d6c4552b706ec65f00f35921f724188a7dc9340916c95478e4d219269f@ec2-50-17-90-177.compute-1.amazonaws.com:5432/de0tm180s9eb1u") {
        databaseConfig = PostgreSQLDatabaseConfig(url: url)!
    }
    else {
        let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
        let databaseName: String
        let databasePort: Int
        if env == .testing {
            databaseName = "vapor-test"
            if let testPort = Environment.get("DATABASE_PORT") {
                databasePort = Int(testPort) ?? 5433
            }
            else {
                databasePort = 5433
            }
        }
        else {
            databaseName = "vapor"
            databasePort = 5432
        }
        
        databaseConfig = PostgreSQLDatabaseConfig(
        hostname: hostname,
        port: databasePort,
        username: "vapor",
        database: databaseName,
        password: "password")
    }
    let database = PostgreSQLDatabase(config: databaseConfig)


    databases.add(database: database, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .psql)
    migrations.add(model: Acronym.self, database: .psql)
    migrations.add(model: GPSARInfo.self, database: .psql)
    services.register(migrations)
    
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
}
