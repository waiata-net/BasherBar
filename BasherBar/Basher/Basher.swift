//
//  Basher.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

@Observable
class Basher: ObservableObject {
    
    // MARK: - Fixtures
    
    var fixturePages = Default.fixturePages {
        didSet { Default.fixturePages = fixturePages }
    }
    
    var matches = [Cricket.Match]()
    
    var selectedMatchID: UUID?
    
    var match: Cricket.Match? {
        get {
            matches.first(where: { $0.id == selectedMatchID }) ?? matches.first
        }
        set {
            selectedMatchID = newValue?.id
        }
    }
    
    func addFixturePage() {
        let new = Web.Page()
        fixturePages.append(new)
    }
    
    func trash(_ fixturePage: Web.Page) {
        guard let index = fixturePages.firstIndex(where: { $0.id == fixturePage.id }) else { return }
        fixturePages.remove(at: index)
    }

    func fetch() async {
        var fixtures = [Fixture]()
        for page in fixturePages {
            async let fixture = Fixture(page: page)
            if let fix = await fixture {
                fixtures.append(fix)
            }
        }
        matches = fixtures.flatMap { $0.matches }
    }
    
    
    // MARK: - Bar
    
    var bar: String {
        matches.first?.title ?? "Bashers!"
    }
    
    // MARK: - Pagination
    
    var page = Page.setting
    
    enum Page {
        case setting
        case cricket
    }
}
