//
//  Fixture.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import Foundation
import Fuzi

struct Fixture {
    
    var title: String = ""
    var matches = [Cricket.Match]()
    
    init?(page: Web.Page) async {
        guard let doc = try? await page.doc() else { return nil }
        read(doc: doc)
    }
    
    mutating func read(doc: HTMLDocument) {
        self.title = doc.title ?? "?"
        matches = doc.elements(CricHeroes.fixtureMatches).compactMap {
            match(in: $0)
        }
    }
    
    func match(in box: Fuzi.XMLElement) -> Cricket.Match? {
        var match = Cricket.Match()
        match.link = box.string(CricHeroes.fixtureLink)
        match.league = box.string(CricHeroes.fixtureLeague)
        match.teams = box.elements(CricHeroes.fixtureTeams).compactMap {
            let name = $0.string(CricHeroes.fixtureTeamName) ?? ""
            return Cricket.Team(name: name)
        }
        match.title = match.teams.map{ $0.name }.joined(separator: " v ")
        return match
    }
    
    
}
