//
//  GPSARInfo.swift
//  App
//
//  Created by Jacob on 2020/1/13.
//

import Vapor
import FluentPostgreSQL

final class GPSARInfo: Codable {
    var id: Int?
    var name: String
    var photoName: String
    var area: Double
    var price: Double
    var latitude: Double
    var longitude: Double
    var altitide: Double

    
    init(name: String, photoName: String, area: Double, price: Double, latitude: Double, longitude: Double, altitide: Double) {
        self.name = name
        self.photoName = photoName
        self.area = area
        self.price = price
        self.latitude = latitude
        self.longitude = longitude
        self.altitide = altitide
    }
}

extension GPSARInfo: PostgreSQLModel {
    typealias Database = PostgreSQLDatabase
    
    typealias ID = Int
    
    public static var idKey: IDKey = \GPSARInfo.id
}

extension GPSARInfo: PostgreSQLMigration {
    
}

extension GPSARInfo: Content {
    
}

extension GPSARInfo: Parameter {
    
}
