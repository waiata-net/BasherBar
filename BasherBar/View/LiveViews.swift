//
//  LiveViews.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/21.
//

import SwiftUI

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
        let chars = recent.split(separator: " ")
        HStack {
            ForEach(chars.indices, id: \.self) { index in
                Text(chars[index])
            }
        }
    }
    
}

#Preview {
    CricketView()
        .environmentObject(Basher.dummy())
        .frame(height: 600)
}
