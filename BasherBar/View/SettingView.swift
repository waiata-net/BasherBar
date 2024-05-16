//
//  SettingView.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var basher: Basher
    
    @AppStorage(Default.key(.gameRate)) var gameRate: TimeInterval = 0
    @AppStorage(Default.key(.barRate)) var barRate: TimeInterval = 0
    @AppStorage(Default.key(.refreshActive)) var refreshing = true
    
    var body: some View {
        VStack {
            
            FixtureList()
                .frame(minHeight: 69)
            FixtureButts()
            MatchList()
            
            Divider()
            
            Form {
                RefreshPick(label: "Refresh Matches:", rate: $gameRate)
                    .onSubmit { basher.tock() }
                
                RefreshPick(label: "Refresh Bar:", rate: $barRate)
                    .onSubmit { basher.tock() }
                
                Divider()
                HStack {
                    Toggle("Auto Refresh", systemImage: "arrow.clockwise", isOn: $refreshing)
                    Spacer()
                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Label("Quit", systemImage: "power")
                    }
                    .keyboardShortcut("q")
                }
            }
        }
        .padding()
        .task {
            await basher.fetchMatches()
        }
    }
    
    
    struct RefreshPick: View {
        
        var label: String = "Refresh:"
        @Binding var rate: TimeInterval
        
        var body: some View {
            HStack {
                Picker(label, selection: $rate) {
                    Text("Off").tag(0.0)
                    Text("5 seconds").tag(5.0)
                    Text("10 seconds").tag(10.0)
                    Text("15 seconds").tag(15.0)
                    Text("30 seconds").tag(30.0)
                    Text("1 minute").tag(60.0)
                    Text("5 minutes").tag(300.0)
                    Text("15 minutes").tag(900.0)
                }
            }
        }
    }
   

}

#Preview {
    SettingView()
        .environmentObject(Basher.dummy())
}
