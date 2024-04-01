//
//  SettingView.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(Basher.self) var basher
    
    var body: some View {
        Form {
            FixtureList()
            MatchPick()
            Button {
                Task {
                    await basher.fetch()
                }
            } label: {
                Label("Reload", systemImage: "arrow.uturn.down")
            }
            
        }
        .padding()
        .task {
            await basher.fetch()
        }
    }
   

}

#Preview {
    SettingView()
        .environment(Basher.dummy())
}
