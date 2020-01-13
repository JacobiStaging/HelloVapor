//
//  Acronym.swift
//  App
//
//  Created by Jacob on 2020/1/13.
//

import Vapor
import FluentSQLite

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String
    
    init(short: String, long: String) {
        self.short = short
        self.long = long
    }
}

extension Acronym: SQLiteModel {
    // 1. Tell Fluent what database to use for this model. The template is already configured to use SQLite.
    typealias Database = SQLiteDatabase
    
    // 2. Tell Fluent what type the ID is.
    typealias ID = Int
    
    // 3. Tell Fluent the key path of the model’s ID property.
    public static var idKey: IDKey = \Acronym.id
}

//extension Acronym:  {
//
//}

extension Acronym: SQLiteMigration {
    
}

extension Acronym: Content {
    
}

extension Acronym: Parameter {
    
}

