import Vapor
import Fluent
struct InfoData: Content {
    let name: String
}

struct InfoResponse: Content {
    let request: InfoData
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello", String.parameter) { req -> String in
        let name = try  req.parameters.next(String.self)
        return "Hello \(name)"
    }
    
    router.post(InfoData.self, at: "info") { (request, data) -> InfoResponse in
        return InfoResponse(request: data)
    }
    
    router.post("api", "acronyms") { req -> Future<Acronym> in
        return try req.content.decode(Acronym.self)
            .flatMap(to: Acronym.self) { acronym in
                return acronym.save(on: req)
            }
    }
    
    router.get("api", "acronyms") { req -> Future<[Acronym]> in
        return Acronym.query(on: req).all()
    }
    
    router.get("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        return try req.parameters.next(Acronym.self)
    }
    
    // 1. Register a route for a PUT request to /api/acronyms/<ID> that returns Future<Acronym>.
    router.put("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        
        // 2. Use flatMap(to:_:_:), the dual future form of flatMap, to wait for both the parameter extraction and content decoding to complete. This provides both the acronym from the database and acronym from the request body to the closure.
        return try flatMap(to: Acronym.self,
                           req.parameters.next(Acronym.self),
                           req.content.decode(Acronym.self)) {
                            acronym, updateAcronym in
                            
                            // 3. Update the acronym’s properties with the new values.
                            acronym.short = updateAcronym.short
                            acronym.long = updateAcronym.long
                            
                            // 4. Save the acronym and return the result.
                            return acronym.save(on: req)
        }
    }
    
    
    // 1. Register a route for a DELETE request to /api/acronyms/<ID> that returns Future<HTTPStatus>.
    router.delete("api", "acronyms", Acronym.parameter) { req -> Future<HTTPStatus> in
        
        // 2. Extract the acronym to delete from the request’s parameters.
        return try req.parameters.next(Acronym.self)
            
            // 3. Delete the acronym using delete(on:). Instead of requiring you to unwrap the returned Future, Fluent allows you to call delete(on:) directly on that Future. This helps tidy up code and reduce nesting. Fluent provides convenience functions for delete, update, create and save.
            .delete(on: req)
            
            // 4. Transform the result into a 204 No Content response. This tells the client the request has successfully completed but there’s no content to return.
            .transform(to: .noContent)
    }
    
    // 1. Register a new route handler for /api/acronyms/search that returns Future<[Acronym]>.
    router.get("api", "acronyms", "search") { req -> Future<[Acronym]> in
        
        // 2. Retrieve the search term from the URL query string. If this fails, throw a 400 Bad Request error.
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        // 3. Use filter(_:) to find all acronyms whose short property matches the searchTerm. Because this uses key paths, the compiler can enforce type-safety on the properties and filter terms. This prevents run-time issues caused by specifying an invalid column name or invalid type to filter on.
        return Acronym.query(on: req)
            .filter(\.short == searchTerm)
            .all()
    }
    
    // MARK: - GPSInfo API
    router.post("api", "gpsinfos") { req -> Future<GPSARInfo> in
        return try req.content.decode(GPSARInfo.self)
            .flatMap(to: GPSARInfo.self) { gpsinfo in
                return gpsinfo.save(on: req)
            }
    }
    
    router.get("api", "gpsinfos") { req -> Future<[GPSARInfo]> in
        return GPSARInfo.query(on: req).all()
    }
    
    router.get("api", "gpsinfos", GPSARInfo.parameter) { req -> Future<GPSARInfo> in
        return try req.parameters.next(GPSARInfo.self)
    }
    

    router.put("api", "gpsinfos", GPSARInfo.parameter) { req -> Future<GPSARInfo> in
        return try flatMap(to: GPSARInfo.self,
                           req.parameters.next(GPSARInfo.self),
                           req.content.decode(GPSARInfo.self)) {
                            info, updateInfo in
                            info.name = updateInfo.name
                            info.photoName = updateInfo.photoName
                            info.area = updateInfo.area
                            info.price = updateInfo.price
                            return info.save(on: req)
        }
    }
    
    router.delete("api", "gpsinfos", GPSARInfo.parameter) { req -> Future<HTTPStatus> in
        return try req.parameters.next(GPSARInfo.self)
            .delete(on: req)
            .transform(to: .noContent)
    }

    
    
    

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
