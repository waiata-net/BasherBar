//
//  Match.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import Foundation

extension Cricket {
    struct Match: Identifiable {
        
        var id = UUID()
        
        var link = ""
        
        var page: Web.Page {
            Web.Page(address: link)
        }
        
        var league: String?
        var venue: String?
        
        var teams = [Team]()
        var innNo: Int?
        
        var live = Live()
        
        var scores: [Cricket.Score] {
            teams.flatMap { $0.inns }
                .sorted { $0.order < $1.order }
        }
        
        typealias Innings = (team: Team, score: Score)
        
        var innings: [Innings] {
            scores.compactMap { innings($0.order) }
        }
        
        var current: Innings? {
            guard let order = innNo ?? scores.last?.order else { return nil }
            return innings(order)
        }
        
        func innings(_ order: Int) -> Innings? {
            let scores = self.scores
            guard let score = scores.first(where: { $0.order == order }),
                  let team = team(id: score.team)
            else { return nil }
            return (team: team, score: score)
        }
        
        func team(id: Team.ID?) -> Team? {
            teams.first { $0.id == id }
        }
        
        var versus: String {
            teams.map(\.name).joined(separator: " v ")
        }
        
        
    }
}
