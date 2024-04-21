//
//  CricketView.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct CricketView: View {
    
    @EnvironmentObject var basher: Basher
    
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    basher.match = .dummy()
                } label: {
                    Label("Dummy", systemImage: "arrow.right")
                }
                TextField("Match Address:", text: $basher.match.link)
                Button {
                    refresh()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            Text(basher.match.versus)
                .font(.title)
            HStack {
                Text(basher.match.league ?? "")
                Text("@")
                Text(basher.match.venue ?? "")
            }
            .font(.subheadline)
            
            ForEach(basher.match.innings, id: \.score.order) {
                InningsView(team: $0.team, score: $0.score)
            }
            
            LiveView(live: basher.match.live)
            
        }
        .padding()
        .onAppear {
            Task {
                 
            }
        }
    }
    
    func refresh() {
        Task {
            try await basher.follow()
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
