//
//  ContentView.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var basher: Basher
    
    var body: some View {
        
        TabView(selection: $basher.tab) {
            
            SettingView()
                .tag(Basher.Tab.setting)
                .tabItem { Label("Settings", systemImage: "gear") }
            
            ForEach(basher.games) { game in
                GameView(game: game)
                    .tag(Basher.Tab.cricket(game.id))
                    .tabItem { Text(game.initials) }
            }
            
            
        }
        .padding()
        .frame(minWidth: 480)
        .toolbar {
            Toolbar()
        }
        .onAppear {
            basher.tock()
        }

    }
    
    
}

#Preview {
    ContentView()
        .environmentObject(Basher.dummy())
}
