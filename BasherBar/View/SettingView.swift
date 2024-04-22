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
            
            MatchList()
            
            Button {
                Task {
                    await basher.fetchMatches()
                }
            } label: {
                Label("Reload", systemImage: "arrow.uturn.down")
            }
            
            RefreshPick()
                .onSubmit {
                    basher.tock()
                }
        }
        .padding()
        .task {
            await basher.fetchMatches()
        }
    }
    
    
    struct RefreshPick: View {
        
        @AppStorage(Default.key(.refresh)) var rate: TimeInterval?
        
        var body: some View {
            HStack {
                Picker("Refresh:", selection: $rate) {
                    Text("Off").tag(nil as TimeInterval?)
                    Text("10 seconds").tag(10 as TimeInterval?)
                    Text("15 seconds").tag(15 as TimeInterval?)
                    Text("30 seconds").tag(30 as TimeInterval?)
                    Text("1 minute").tag(60 as TimeInterval?)
                    Text("5 minutes").tag(300 as TimeInterval?)
                    Text("15 minutes").tag(900 as TimeInterval?)
                }
            }
        }
    }
   

}

#Preview {
    SettingView()
        .environmentObject(Basher.dummy())
}
