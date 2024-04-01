//
//  Match.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import Foundation

extension Cricket {
    struct Match: Identifiable {
        
        let id = UUID()
        
        var link: String?
        var title = ""
        var league: String?
        var teams = [Team]()
        
    }
}
