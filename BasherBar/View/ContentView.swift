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
        switch basher.tab {
        case .setting: SettingView()
        case .cricket: CricketView()
        }
    }
    
}

#Preview {
    ContentView()
}
