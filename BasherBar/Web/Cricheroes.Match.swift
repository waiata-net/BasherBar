//
//  Cricheroes.Match.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/21.
//

import Foundation
import Fuzi

typealias JSONObject = [AnyHashable: Any]

extension CricHeroes {
    
    static let jsonData = Web.Part(css: "#__NEXT_DATA__")
    
    static let tourny = "tournament_name"
    static let venue = "ground_name"
    static let teamA = "team_a"
    static let teamB = "team_b"
    static let teamID = "id"
    static let teamName = "name"
    static let teamLogo = "logo"
    static let innings = "innings"
    static let inningsNumber = "current_inning"
    static let inningsOrder = "inning"
    static let inningsTeam = "team_id"
    static let totalRuns = "total_run"
    static let totalOuts = "total_wicket"
    static let totalOver = "overs_played"
    static let summary = "match_summary"
    static let blurb = "summary"
    static let playerID = "player_id"
    static let playerName = "name"
    static let playerFace = "profile_photo"
    static let batters = "batsmen"
    static let batRuns = "runs"
    static let batBalls = "balls"
    static let batFours = "4s"
    static let batSixes = "6s"
    static let bowlers = "bowlers"
    static let bowlOver = "overs"
    static let bowlMaidens = "maidens"
    static let bowlRuns = "runs"
    static let bowlWickets = "wickets"
    static let role = "wickets"
    static let onStrike = "sb"
    static let offStrike = "nsb"
    static let partnership = "current_partnership_data"
    static let partnershipRuns = "runs"
    static let partnershipBalls = "balls"
    
    static func fetch(_ match: Cricket.Match) async throws -> Cricket.Match? {
        guard
            let doc = try await Web.Page(address: match.link).doc(),
            let json = json(from: doc)
        else { return nil }
        var game = match
        game.league = json[tourny] as? String
        game.venue = json[venue] as? String
        game.teams = [teamA, teamB].compactMap {
            guard let j = json[$0] as? JSONObject else { return nil }
            return team(from: j)
        }
        game.innNo = json[inningsNumber] as? Int ?? 0
        game.live = live(from: json)
        return game
    }
    
    static func json(from doc: HTMLDocument) -> JSONObject? {
        guard let data = CricHeroes.jsonData.datum(in: doc),
              let root = try? JSONSerialization.jsonObject(with: data) as? JSONObject,
              let prop = root["props"] as? JSONObject,
              let page = prop["pageProps"] as? JSONObject,
              let mini = page["miniScorecard"] as? JSONObject,
              let json = mini["data"] as? JSONObject
        else { return nil }
        return json
    }
    
    static func team(from json: JSONObject) -> Cricket.Team {
        var team = Cricket.Team()
        team.id = json[teamID] as? Int ?? 0
        team.name = json[teamName] as? String ?? ""
        team.logo = json[teamLogo] as? String ?? ""
        team.inns = innings(from: json)
        return team
    }
    
    static func innings(from json: JSONObject) -> [Cricket.Score] {
        guard let innings = json[innings] as? [JSONObject] else { return [] }
        return innings.compactMap {
            score(from: $0)
        }
    }
    
    static func score(from json: JSONObject) -> Cricket.Score {
        let order = json[inningsOrder] as? Int ?? 0
        let team = json[inningsTeam] as? Int
        let runs = json[totalRuns] as? Int ?? 0
        let outs = json[totalOuts] as? Int ?? 0
        let ob = json[totalOver] as? String ?? "0"
        let over = Cricket.Over[ob]
        return Cricket.Score(order: order, team: team, over: over, runs: runs, outs: outs)
    
    }
    
    
    
    static func live(from json: JSONObject) -> Cricket.Live {
        var live = Cricket.Live()
        if let summary = json[summary] as? JSONObject {
            live.blurb = summary[blurb] as? String ?? ""
        }
        if let batters = json[batters] as? JSONObject {
            if let bat = batters[onStrike] as? JSONObject {
                live.striker = batter(from: bat)
            }
            if let bat = batters[offStrike] as? JSONObject {
                live.nonStriker = batter(from: bat)
            }
        }
        if let bowlers = json[bowlers] as? JSONObject {
            if let bowl = bowlers[onStrike] as? JSONObject {
                live.bowler = bowler(from: bowl)
            }
        }
        if let part = json[partnership] as? JSONObject {
            live.partnership = partnership(from: part)
        }
        
        return live
    
    }
    
    static func player(from json: JSONObject) -> Cricket.Player {
        let id = json[playerID] as? Int ?? 0
        let name = json[playerName] as? String ?? ""
        let face = json[playerFace] as? String ?? ""
        return Cricket.Player(id: id, name: name, face: face)
    
    }
    
    
    static func batter(from json: JSONObject) -> Cricket.Batter {
        let player = player(from: json)
        let runs = json[batRuns] as? Int ?? 0
        let balls = json[batBalls] as? Int ?? 0
        let fours = json[batFours] as? Int ?? 0
        let sixes = json[batSixes] as? Int ?? 0
        return Cricket.Batter(player: player, runs: runs, balls: balls, fours: fours, sixes: sixes)
    }
    
    static func bowler(from json: JSONObject) -> Cricket.Bowler {
        let player = player(from: json)
        let ob = json[bowlOver] as? Double ?? 0
        let over = Cricket.Over[ob]
        let maidens = json[batBalls] as? Int ?? 0
        let runs = json[batFours] as? Int ?? 0
        let wickets = json[batSixes] as? Int ?? 0
        return Cricket.Bowler(player: player, overs: over, maidens: maidens, runs: runs, wickets: wickets)
    }
    
    
    static func partnership(from json: JSONObject) -> Cricket.Partnership {
        var part = Cricket.Partnership()
        part.runs = json[partnershipRuns] as? Int ?? 0
        part.balls = json[partnershipBalls] as? Int ?? 0
        return part
    }

    
}
