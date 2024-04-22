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
        didSet { Default.fixtures = self.fixtures }
    }
    
    func newFixture() {
        let new = Fixture()
        fixtures.append(new)
    }
    
    func trash(_ fixture: Fixture) {
        guard let index = fixtures.firstIndex(where: { $0.id == fixture.id }) else { return }
        fixtures.remove(at: index)
    }
    
    // MARK: - Matches
    
    var matches = [Match]()
    
    @Published var selectedMatchID: UUID?
    
    @Published var match = Match()
    
    // MARK: - Fetch
    
    /// Get matches from fixtures
    func fetch() async {
        matches = []
        for fixture in fixtures {
            let more = await fixture.matches()
            matches.append(contentsOf: more)
        }
    }
    
    
    // MARK: - Bar
    
    var bar: String {
        matches.first?.title ?? "Bashers!"
    }
    
    // MARK: - Pagination
    
    var tab = Tab.cricket
    
    enum Tab {
        case setting
        case cricket
    }
    
    // MARK: - Timer
    
    var ticker = Timer()
    
    func tick() {
        guard let refresh = Default.refreshRate else { return }
        ticker = Timer.scheduledTimer(withTimeInterval: refresh, repeats: false) { _ in
            self.tock()
        }
    }
    
    func tock()  {
        ticker.invalidate()
        Task {
            await update()
        }
        
        self.tick()
    }
    
    func update() async {
        if let game = try? await gameTask.value {
            DispatchQueue.main.async {
                self.match.game = game
            }
        }
    }
    
    // MARK: - Game
    
    
    
    typealias GameTask = Task<Cricket.Game?, any Error>
    
    var gameTask: GameTask {
        Task { () -> Cricket.Game? in
            let game = try await CricHeroes.fetch(match)
            return game
        }
    }
    
}
