//
//  MatchViews.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI


//struct MatchPick: View {
//    
//    @EnvironmentObject var basher: Basher
//    
//    var body: some View {        
//        Picker("Select a Match", selection: $basher.match) {
//            ForEach($basher.matches.indices, id: \.self) { index in
//                MatchItem(match: $basher.matches[index] )
//            }
//        }
//    }
//}

struct MatchList: View {
    
    @EnvironmentObject var basher: Basher
    
    var body: some View {
        List(selection: $basher.matchIDs) {
            ForEach($basher.matches.indices, id: \.self) { index in
                MatchItem(match: $basher.matches[index] )
            }
        }
    }
}

struct MatchItem: View {
    
    @EnvironmentObject var basher: Basher
    @Binding var match: Match
    
    var body: some View {
        HStack {
            Text(match.title)
        }
        .tag(match.id)
    }
}


#Preview {
    MatchList()
        .environmentObject(Basher.dummy())
}
