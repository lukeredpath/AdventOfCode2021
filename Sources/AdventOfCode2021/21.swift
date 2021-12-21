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
    
    typealias WinCounts = (one: UInt, two: UInt)
    
    static func diracRolls() -> [[UInt]] {
        let sides: [UInt] = [1, 2, 3]
        var rolls: [[UInt]] = []
        for roll1 in sides {
            for roll2 in sides {
                for roll3 in sides {
                    rolls.append([roll1, roll2, roll3])
                }
            }
        }
        return rolls
    }
    
    static func performDiracMove(
        currentPlayer: Player,
        playerIndex: Int,
        players: [Player],
        rolls: [UInt],
        winCounts: inout WinCounts
    ) {
        print("Universe split, win counts: \(winCounts.0), 2: \(winCounts.1)")
        
        var players = players
        let updatedPlayer = move(player: currentPlayer, rolls: rolls)
        players[playerIndex] = updatedPlayer
        
        if updatedPlayer.score >= 21 {
            if playerIndex == 0 {
                winCounts.0 += 1
            } else {
                winCounts.1 += 1
            }
        } else {
            playDiracGame(
                players: players,
                nextPlayerIndex: playerIndex == 0 ? 1 : 0,
                winCounts: &winCounts
            )
        }
    }
    
    static func playDiracGame(
        players: [Player],
        nextPlayerIndex: Int = 0,
        winCounts: inout WinCounts
    ) {
        // Every move of 3 die rolls creates 27 new universes
        for roll in diracRolls() {
            performDiracMove(
                currentPlayer: players[nextPlayerIndex],
                playerIndex: nextPlayerIndex,
                players: players,
                rolls: roll,
                winCounts: &winCounts
            )
        }
    }
    
    static func playDiracGame(players: [Player]) -> WinCounts {
        var winCounts: WinCounts = (0, 0)
        playDiracGame(players: players, winCounts: &winCounts)
        return winCounts
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
