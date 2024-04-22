//
//  CricketView.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct CricketView: View {
    
    @EnvironmentObject var basher: Basher
    
    @State var countdown: String = ""
    
    let tick = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            
            MatchView()
            
            Divider()
            
            if let game = basher.match.game {
                
                GameView(game: game)
                
                Divider()
            }
            
            Button {
                refresh()
            } label: {
                Label(countdown, systemImage: "arrow.clockwise")
            }
            
        }
        .padding()
        .onAppear {
            refresh()
        }
        .onReceive(tick) { _ in
            if basher.ticker.isValid {
                countdown = "\(Int(basher.ticker.fireDate.timeIntervalSinceNow))"
            } else {
                countdown = "Refresh"
            }
        }
        
    }
    
    func refresh() {
        basher.tock()
    }
    
    struct MatchView: View {
        
        @EnvironmentObject var basher: Basher
        
        var body: some View {
            HStack {
                Button {
                    basher.match = .dummy()
                } label: {
                    Label("Dummy", systemImage: "arrow.right")
                }
                TextField("Match Address:", text: $basher.match.link)
                
            }
            
        }
    }
    struct GameView: View {
        
        var game: Cricket.Game
        
        var body: some View {
            VStack {
                Text(game.versus)
                    .font(.title)
                HStack {
                    Text(game.league ?? "")
                    Text("@")
                    Text(game.venue ?? "")
                }
                .font(.subheadline)
                
                Divider()
                
                ForEach(game.innings, id: \.score.order) {
                    InningsView(team: $0.team, score: $0.score)
                }
                .font(.title2)
                
                Divider()
                
                LiveView(live: game.live)
            }
            
        }
    }
    
    struct InningsView: View {
        
        var team: Cricket.Team
        var score: Cricket.Score
        
        var body: some View {
            HStack {
                TeamLabel(team: team)
                Spacer()
                ScoreView(score: score)
            }
        }
    }
    
    struct TeamLabel: View {
        
        var team: Cricket.Team
        
        var body: some View {
            HStack {
                AsyncImage(url: URL(string: team.logo)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 36, height: 36)
                Text(team.name)
            }
        }
    }
    
    struct ScoreView: View {
        
        var score: Cricket.Score
        
        var body: some View {
            Text(score.text)
        }
    }
}

#Preview {
    CricketView()
        .environmentObject(Basher.dummy())
        .frame(width: 600, height: 600)
}
