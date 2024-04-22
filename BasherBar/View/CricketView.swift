//
//  CricketView.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI


struct GameView: View {
    
    @EnvironmentObject var basher: Basher
    
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
            
            Button {
                Task {
                    await basher.refresh(id: game.id)
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
        }
        .padding()
        
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


#Preview {
    ContentView()
        .environmentObject(Basher.dummy())
        .frame(width: 600, height: 600)
}
