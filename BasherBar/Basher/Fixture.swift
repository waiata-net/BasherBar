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
        self.title = doc.title ?? page.address
    }
    
    func matches() async -> [Match] {
        guard let doc = try? await page.doc() else { return [] }
        let boxes = doc.elements(CricHeroes.fixtureMatches)
        return boxes.compactMap {
            match(in: $0)
        }
    }
    
    func match(in box: Fuzi.XMLElement) -> Match {
        var match = Match()
        let teams = box.elements(CricHeroes.fixtureTeams).compactMap {
            let name = $0.string(CricHeroes.fixtureTeamName) ?? ""
            return Cricket.Team(name: name)
        }
        match.title = teams.map { $0.name }.joined(separator: " v ")
        match.link = box.string(CricHeroes.fixtureLink) ?? ""
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
