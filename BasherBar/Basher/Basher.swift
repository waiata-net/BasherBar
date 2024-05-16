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
        Default.fixtures = self.fixtures
        Task {
            await fetchMatches()
        }
    }
    
    func addFixture(_ new: Fixture = Fixture()) {
        self.fixtures.append(new)
    }
    
    func trash(_ fixture: Fixture) {
        guard let index = self.fixtures.firstIndex(where: { $0.id == fixture.id }) else { return }
        self.fixtures.remove(at: index)
    }
    
    func visit(_ fixture: Fixture) {
        guard let url = fixture.page.url else { return }
        NSWorkspace.shared.open(url)
    }
    
    // MARK: - Matches
    
    @Published var matches = [Match]()
    
    @Published var matchIDs = Set<Match.ID>() {
        didSet { tock() }
    }
    
    func match(_ id: Match.ID) -> Match? {
        matches.first { $0.id == id }
    }
    
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
    
    typealias Bar = (text: String, icon: String?)
    
    func bar() -> Bar {
        guard let game = games.randomElement() else { return Basher.defaultBar }
        let text = game.text()
        let icon = game.icon()
        return (text: text, icon: icon)
    }
    
    static let defaultBar: Bar = (text: "Bashers!", icon: nil)
    
    
    // MARK: - Pagination
    
    var tab = Tab.setting
    
    enum Tab: Hashable {
        case setting
        case cricket(Cricket.Game.ID)
    }
    
    // MARK: - Timer
    
    var ticker = Timer()
    
    func tick() {
        let refresh = Default.gameRate
        guard refresh > 0 else { return }
        ticker = Timer.scheduledTimer(withTimeInterval: refresh, repeats: false) { _ in
            DispatchQueue.main.async {
                self.tock()
            }
        }
    }
    
    func tock()  {
        ticker.invalidate()
        Task {
            await update()
        }
        
        self.tick()
    }
    
    func following() -> [Match.ID] {
        if matchIDs.isEmpty { return matches.map { $0.id } } // follow all by default
        return matchIDs.map{ $0 }
    }
    
    func update() async {
        purge()
        for id in following() {
            await refresh(id: id)
        }
    }
    
    func refresh(id: Match.ID) async {
        guard let match = match(id) else { return }
        if let game = try? await gameTask(for: match).value {
            update(game)
        }
    }
    
    func index(of game: Cricket.Game) -> Int? {
        games.firstIndex { $0.id == game.id }
    }
    
    func insert(_ game: Cricket.Game) -> Int? {
        if let index = index(of: game) { return index }
        games.append(game)
        return index(of: game)
    }
    
    func update(_ game: Cricket.Game) {
        guard let index = insert(game) else { return }
        games[index] = game
    }
    
    func purge() {
        if matchIDs.isEmpty { return }
        games = games.filter { following($0) }
    }
    
    func following(_ game: Cricket.Game) -> Bool {
        following().contains(game.id)
    }

    // MARK: - Games
    
    @Published var games = [Cricket.Game]()
    
    typealias GameTask = Task<Cricket.Game?, any Error>
    
    func gameTask(for match: Match) -> GameTask {
        Task { () -> Cricket.Game? in
            let game = try await CricHeroes.fetch(match)
            return game
        }
    }
    
}
