//
//  Acronym.swift
//  App
//
//  Created by Jacob on 2020/1/13.
//

import Vapor
import FluentPostgreSQL

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String
    
    init(short: String, long: String) {
        self.short = short
        self.long = long
    }
}

extension Acronym: PostgreSQLModel {
    // 1. Tell Fluent what database to use for this model. The template is already configured to use SQLite.
    typealias Database = PostgreSQLDatabase
    
    // 2. Tell Fluent what type the ID is.
    typealias ID = Int
    
    // 3. Tell Fluent the key path of the model’s ID property.
    public static var idKey: IDKey = \Acronym.id
}

//extension Acronym:  {
//
//}

extension Acronym: PostgreSQLMigration {
    
}

extension Acronym: Content {
    
}

extension Acronym: Parameter {
    
}

