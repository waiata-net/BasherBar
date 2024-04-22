//
//  Dummy.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import Foundation

extension Basher {
    static func dummy() -> Basher {
        Basher()
    }
}

extension Fixture {
    static func dummy() async -> Fixture {
        await Fixture(
            page: Web.Page(address: "https://cricheroes.com/tournament/921383/scc-t20-2024-d1/matches/past-matches")
        )
    }
}

extension Match {
    
    static let link = "http://localhost/data/cricheroes.html"
    
    static func dummy() -> Match {
        Match(link: link)
    }
}
