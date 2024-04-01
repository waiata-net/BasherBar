//
//  MatchViews.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI


struct MatchPick: View {
    
    @Environment(Basher.self) var basher
    
    var body: some View {
        @Bindable var basher = basher
        Picker("Select a Match", selection: $basher.selectedMatchID) {
            ForEach($basher.matches.indices, id: \.self) { index in
                MatchItem(match: $basher.matches[index] )
            }
        }
    }
}

struct MatchList: View {
    
    @Environment(Basher.self) var basher
    
    var body: some View {
        @Bindable var basher = basher
        List {
            ForEach($basher.matches.indices, id: \.self) { index in
                MatchItem(match: $basher.matches[index] )
            }
        }
    }
}

struct MatchItem: View {
    
    @Environment(Basher.self) var basher
    @Binding var match: Cricket.Match
    
    var body: some View {
        HStack {
            Text(match.title)
        }
        .tag(match.id)
    }
}


#Preview {
    MatchList()
        .environment(Basher.dummy())
}
