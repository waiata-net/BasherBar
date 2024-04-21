//
//  Basher.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

class Basher: ObservableObject {
    
    // MARK: - Fixtures
    
    @Published var fixtures: [Fixture] = Default.fixtures {
        didSet {
            Default.fixtures = self.fixtures
            
        }
    }

    
    func addFixture() {
        let new = Fixture()
        fixtures.append(new)
    }
    
    func trash(_ fixture: Fixture) {
        guard let index = fixtures.firstIndex(where: { $0.id == fixture.id }) else { return }
        fixtures.remove(at: index)
    }

    // MARK: - Matches
    
    var matches = [Cricket.Match]()
    
    @Published var selectedMatchID: UUID?
    
    @Published var match = Cricket.Match()
    
    // MARK: - Fetch
    
    func fetch() async {
        matches = []
        for fixture in fixtures {
            let more = await fixture.matches()
            matches.append(contentsOf: more)
        }
    }
    
    
    // MARK: - Bar
    
    var bar: String {
        matches.first?.versus ?? "Bashers!"
    }
    
    // MARK: - Pagination
    
    var tab = Tab.cricket
    
    enum Tab {
        case setting
        case cricket
    }
}
