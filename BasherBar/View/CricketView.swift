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
    
    @State var refreshing = false
    
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
                refreshing = true
                Task {
                    await basher.refresh(id: game.id)
                    refreshing = false
                }
            } label: {
                if refreshing {
                    ProgressView()
                } else {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
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

struct LiveView: View {
    
    @EnvironmentObject var basher: Basher
    var live: Cricket.Live
    
    var body: some View {
        VStack {
            if let bat = live.striker {
                BatterView(batter: bat)
            }
            if let bat = live.nonStriker {
                BatterView(batter: bat)
            }
            if let part = live.partnership {
                PartnershipView(partnership: part)
            }
            if let bowl = live.bowler {
                Divider()
                BowlerView(bowler: bowl)
                Divider()
            }
            RecentView(recent: live.recent)
                .font(.title3)
            Text(live.blurb)
                .font(.headline)
            Spacer()
        }
    }
}

struct BatterView: View {
    
    var batter: Cricket.Batter
    
    var body: some View {
        HStack {
            PlayerLabel(player: batter.player)
            Spacer()
            VStack {
                Text("Fours").font(.caption2)
                Text(batter.fours, format: .number).font(.callout)
            }
            VStack {
                Text("Sixes").font(.caption2)
                Text(batter.sixes, format: .number).font(.callout)
            }
            VStack {
                Text("Runs").font(.caption2)
                Text(batter.runs, format: .number).font(.callout).bold()
            }
            VStack {
                Text("Balls").font(.caption2)
                Text(batter.balls, format: .number).font(.callout)
            }
        }
    }
}


struct PartnershipView: View {
    
    var partnership: Cricket.Partnership
    
    var body: some View {
        HStack {
            Text("Partnership:")
            Text(partnership.runs, format: .number).font(.callout)
            Text("runs")
            Text(partnership.balls, format: .number)
            Text("balls.")
            if let rr = partnership.runRate {
                Text("Run rate:")
                Text(rr, format: .number)
            }
        }
    }
}

struct BowlerView: View {
    
    var bowler: Cricket.Bowler
    
    var body: some View {
        HStack {
            Text(bowler.player.name)
            Spacer()
            VStack {
                Text("Overs").font(.caption2)
                Text(bowler.overs.text).font(.callout)
            }
            VStack {
                Text("Maidens").font(.caption2)
                Text(bowler.maidens, format: .number).font(.callout)
            }
            VStack {
                Text("Runs").font(.caption2)
                Text(bowler.runs, format: .number).font(.callout)
            }
            VStack {
                Text("Wickets").font(.caption2)
                Text(bowler.wickets, format: .number).font(.callout)
            }
        }
    }
}

struct PlayerLabel: View {
    
    var player: Cricket.Player
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: player.face)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 24, height: 24)
            Text(player.name)
        }
    }
}

struct RecentView: View {
    
    var recent: String
    
    var body: some View {
        let balls = recent.split(separator: " ")
        VStack {
            HStack {
                ForEach(balls.indices, id: \.self) { index in
                    blob(balls[index])
                }
                .frame(maxHeight: 36)
            }
        }
    }
    
    @ViewBuilder
    func blob(_ ball: String.SubSequence ) -> some View {
        let b = String(ball)
        let c = tint(b)
        Label(
            title: { Text(b) },
            icon: { Image(b).resizable().scaledToFit() }
        )
        .labelStyle(.iconOnly)
        .foregroundStyle(c)
    }
    
    func tint(_ ball: String) -> Color {
        switch ball {
        case "4", "6": return .green
        case _ where ball.hasSuffix("wd") : return .brown
        case _ where ball.hasSuffix("nb") : return .orange
        case _ where ball.hasSuffix("lb") : return .cyan
        case _ where ball.hasSuffix("b") : return .blue
        case "W" : return .red
        case "|", "I" : return .secondary
        default: return .primary
        }
    }
}



struct CricketPreview: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .environmentObject(Basher.dummy())
            .frame(width: 600, height: 600)
        
        VStack {
            RecentView(recent: " 0 . 1 2 3 4 5 6 |")
            RecentView(recent: " I W |")
            RecentView(recent: "wd 0wd 1wd 2wd 3wd 4wd 5wd 6wd ")
            RecentView(recent: "0nb 1nb 2nb 3nb 4nb 5nb 6nb")
            RecentView(recent: "1b 2b 3b 4b 5b 6b")
            RecentView(recent: "1lb 2lb 3lb 4lb 5lb 6lb")
        }
        .padding()
    }
}

