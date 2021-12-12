import Foundation
import Parsing
import Overture

enum Day12 {
    typealias Path = (String, String)
    typealias Route = [String]
    typealias RouteMap = [String: [String]]
    
    static let cave = Prefix<Substring> { $0 != "-" && $0 != "\n" }
        .map(String.init)
    
    static let path = cave
        .skip("-")
        .take(cave)
    
    static let paths = Many(path, separator: "\n")
    
    static func parseInput(_ input: String) -> [Path] {
        var input = input[...]
        guard let result = paths.parse(&input) else {
            fatalError("Could not parse input!")
        }
        return result
    }
    
    static func calculateRoutes(map: RouteMap) -> Set<Route> {
        plotRoute(
            on: map,
            to: "end",
            currentRoute: ["start"],
            possibleDestinations: map["start", default: []]
        )
    }
    
    static func plotRoute(
        on map: RouteMap,
        to end: String,
        currentRoute: Route,
        possibleDestinations: [String],
        foundRoutes: Set<Route> = []
    ) -> Set<Route> {
        guard possibleDestinations.count > 0 else { return foundRoutes }
        
        return possibleDestinations.reduce(into: foundRoutes) { foundRoutes, destination in
            if destination == end {
                foundRoutes.insert(currentRoute + [destination])
            } else {
                guard canVisitCave(destination, currentRoute: currentRoute)
                else { return }
                
                foundRoutes = plotRoute(
                    on: map,
                    to: end,
                    currentRoute: currentRoute + [destination],
                    possibleDestinations: map[destination, default: []],
                    foundRoutes: foundRoutes
                )
            }
        }
    }
    
    static func calculateRoutes2(map: RouteMap) -> Set<Route> {
        smallCaves(in: map).reduce(into: Set<Route>()) { foundRoutes, cave in
            foundRoutes = plotRoute2(
                on: map,
                to: "end",
                currentRoute: ["start"],
                possibleDestinations: map["start", default: []],
                smallCaveMayVisitTwice: cave,
                foundRoutes: foundRoutes
            )
        }
    }
    
    static func plotRoute2(
        on map: RouteMap,
        to end: String,
        currentRoute: Route,
        possibleDestinations: [String],
        smallCaveMayVisitTwice: String,
        foundRoutes: Set<Route> = []
    ) -> Set<Route> {
        guard possibleDestinations.count > 0 else { return foundRoutes }
        
        return possibleDestinations.reduce(into: foundRoutes) { foundRoutes, destination in
            if destination == end {
                foundRoutes.insert(currentRoute + [destination])
            } else {
                guard canVisitCave2(
                    destination,
                    smallCaveMayVisitTwice: smallCaveMayVisitTwice,
                    currentRoute: currentRoute
                ) else { return }
                
                foundRoutes = plotRoute2(
                    on: map,
                    to: end,
                    currentRoute: currentRoute + [destination],
                    possibleDestinations: map[destination, default: []],
                    smallCaveMayVisitTwice: smallCaveMayVisitTwice,
                    foundRoutes: foundRoutes
                )
            }
        }
    }
    
    static func isSmallCave(_ string: String) -> Bool {
        string.lowercased() == string
    }
    
    static func canVisitCave(_ string: String, currentRoute: Route) -> Bool {
        isSmallCave(string)
            ? !currentRoute.contains(string)
            : true
    }
    
    static func canVisitCave2(
        _ cave: String,
        smallCaveMayVisitTwice: String,
        currentRoute: Route
    ) -> Bool {
        if isSmallCave(cave) {
            if cave == smallCaveMayVisitTwice {
                return currentRoute.filter { $0 == smallCaveMayVisitTwice }.count < 2
            } else {
                return !currentRoute.contains(cave)
            }
        } else {
            return cave != "start"
        }
    }
    
    static func mapPaths(_ paths: [Path]) -> RouteMap {
        let map: RouteMap = [:]
        return paths.reduce(into: map) { partialResult, connection in
            partialResult[connection.0, default: []].append(connection.1)
            partialResult[connection.1, default: []].append(connection.0)
        }
    }
    
    static func smallCaves(in map: RouteMap) -> Set<String> {
        Set(map.keys.filter(isSmallCave).filter { cave in
            cave != "start" && cave != "end"
        })
    }
    
    static let partOne = pipe(
        parseInput,
        mapPaths,
        calculateRoutes,
        get(\.count)
    )
    
    static let partTwo = pipe(
        parseInput,
        mapPaths,
        calculateRoutes2,
        get(\.count)
    )
}
