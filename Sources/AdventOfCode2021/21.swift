import Foundation
import Parsing
import Overture

enum Day21 {
    typealias Player = (name: String, position: UInt, score: UInt)
    typealias Roll = () -> UInt
    typealias GameResult = (winner: Player, losers: [Player], rolls: UInt)
    
    // MARK: - Parsing
    
    static let player = StartsWith("Player ")
        .take(UInt.parser().map(String.init))
        .skip(" starting position: ")
        .take(UInt.parser())
        .map { Player(name: $0.0, position: $0.1, score: 0) }
    
    static let players = Many(player, separator: "\n")
    
    static func parseInput(_ inputString: String) -> [Player] {
        guard let result = players.parse(inputString) else {
            fatalError("Could not parse input")
        }
        return result
    }
    
    // MARK: - Calculations
    
    static func move(player: Player, rolls: [UInt]) -> Player {
        let advanceBy = UInt(rolls.reduce(0, +))
        var position = (player.position + advanceBy) % 10
        position = position == 0 ? 10 : position
        return (player.name, position, player.score + position)
    }
    
    static func deterministicRoll() -> Roll {
        var nextValue: UInt = 1
        return {
            let roll = nextValue
            nextValue = (nextValue == 100) ? 1 : nextValue + 1
            return roll
        }
    }
    
    static func playGame(players: [Player], roll: Roll) -> GameResult {
        precondition(players.count > 0)
        var players = players
        var nextPlayerIndex = 0
        var rolls: UInt = 0
        while true {
            let player = players[nextPlayerIndex]
            let updatedPlayer = move(
                player: player,
                rolls: [roll(), roll(), roll()]
            )
            players[nextPlayerIndex] = updatedPlayer
            rolls += 3
            if updatedPlayer.score >= 1000 {
                let losers = players.filter { $0.name != updatedPlayer.name }
                return (winner: updatedPlayer, losers: losers, rolls: rolls)
            } else {
                nextPlayerIndex += 1
                if nextPlayerIndex >= players.count {
                    nextPlayerIndex = 0
                }
            }
        }
    }
    
    static func evaluateGameResult(_ result: GameResult) -> UInt {
        let sortedLosers = result.losers.sorted(by: { $0.score < $1.score })
        guard let lowestScoringLoser = sortedLosers.first else {
            preconditionFailure("There must be a loser!")
        }
        return lowestScoringLoser.score * result.rolls
    }
    
    // MARK: - Solutions
    
    static let partOne = pipe(
        parseInput,
        with(deterministicRoll(), flip(curry(playGame))),
        evaluateGameResult
    )
}
