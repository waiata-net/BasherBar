//
//  Basher.Cricket.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/21.
//

import Foundation

extension Basher {
    
    /// load data
    func follow() async throws {
        guard 
            let game = try await CricHeroes.fetch(match)
        else { return }
        DispatchQueue.main.async {
            self.match = game
        }
    }
    
}
