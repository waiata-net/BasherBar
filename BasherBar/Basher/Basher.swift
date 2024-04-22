//
//  Basher.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

@MainActor
class Basher: ObservableObject {
    
    // MARK: - Fixtures
    
    @Published var fixtures: [Fixture] = Default.fixtures {
        didSet { updateFixtures() }
    }
        
    func updateFixtures() {
        Task {
            Default.fixtures = self.fixtures
            await fetchMatches()
        }
    }
    
    func newFixture() {
        let new = Fixture()
        self.fixtures.append(new)
    }
    
    func trash(_ fixture: Fixture) {
        guard let index = self.fixtures.firstIndex(where: { $0.id == fixture.id }) else { return }
        self.fixtures.remove(at: index)
    }
    
    // MARK: - Matches
    
    @Published var matches = [Match]()
    
    @Published var match = Match()
    
    // MARK: - Fetch
    
    /// Get matches from fixtures
    func fetchMatches() async {
        matches = []
        Task {
        for fixture in fixtures {
            let more = await fixture.matches()
                self.matches.append(contentsOf: more)
            }
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
