//
//  SettingView.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var basher: Basher
    
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
        .environmentObject(Basher.dummy())
}
