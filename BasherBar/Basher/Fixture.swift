//
//  Fixture.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import Foundation
import Fuzi

struct Fixture: Identifiable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case page
    }
    
    let id = UUID()
    
    var page = Web.Page()
    var title = ""
    
    
    init() { }
    
    init(page: Web.Page) async {
        self.page = page
        await load()
    }
    
    mutating func load() async {
        if let doc = try? await page.doc() {
            read(doc: doc)
        }
    }
    
    mutating func read(doc: HTMLDocument) {
        self.title = doc.title ?? "?"
    }
    
    func matches() async -> [Cricket.Match] {
        guard let doc = try? await page.doc() else { return [] }
        return doc.elements(CricHeroes.fixtureMatches).compactMap {
            match(in: $0)
        }
    }
    
    func match(in box: Fuzi.XMLElement) -> Cricket.Match? {
        var match = Cricket.Match()
        match.league = box.string(CricHeroes.fixtureLeague)
        match.teams = box.elements(CricHeroes.fixtureTeams).compactMap {
            let name = $0.string(CricHeroes.fixtureTeamName) ?? ""
            return Cricket.Team(name: name)
        }
        return match
    }
    
    
}


extension Fixture: RawRepresentable {
    
    typealias RawValue = String
    
    var rawValue: String {
        page.address
    }
    
    init?(rawValue: String) {
        self.page = Web.Page(address: rawValue)
    }
    
}
