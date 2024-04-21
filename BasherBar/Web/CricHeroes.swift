//
//  CricHeroes.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import Foundation

struct CricHeroes {
    
    static let fixtureMatches = Web.Part(css: "section.currentTab .row a")
    
    static let fixtureLink = Web.Part(attribute: "href")
    static let fixtureLeague = Web.Part(css: "i")
    
    static let fixtureTeams = Web.Part(css: ".dDmbeZ")
    static let fixtureTeamName = Web.Part(css: "div")
    
    
    
    
}
