//
//  ContentView.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(Basher.self) var basher
    
    var body: some View {
        switch basher.page {
        case .setting: SettingView()
        case .cricket: CricketView()
        }
    }
    
}

#Preview {
    ContentView()
}
