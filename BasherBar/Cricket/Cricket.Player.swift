//
//  Cricket.Player.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/21.
//

import Foundation

extension Cricket {
    struct Player: Identifiable {
        
        var id: Int = UUID().hashValue
        
        var name: String = ""
        var face: String = ""
        
    }
    
    struct Batter: Identifiable {
        
        var id: Int { player.id }
        
        var player: Player
        var runs: Int = 0
        var balls: Int = 0
        var fours: Int = 0
        var sixes: Int = 0
        
    }
    
    
    struct Bowler: Identifiable {
        
        var id: Int { player.id }
        
        var player: Player
        var overs = Over()
        var maidens: Int = 0
        var runs: Int = 0
        var wickets: Int = 0
        
    }
    
    struct Partnership {
        var runs: Int = 0
        var balls: Int = 0
        
        var runRate: Double? {
            guard balls > 0 else { return nil }
            return Double(runs) / Double(balls) * 100
        }
    }
    
}
