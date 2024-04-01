//
//  BasherBarApp.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

@main
struct BasherBarApp: App {
    
    @State var basher = Basher()
    
    var body: some Scene {
        Window("Settings", id: "Settings") {
            SettingView()
                .environmentObject(basher)
        }
        MenuBarExtra {
            ContentView()
                .environmentObject(basher)
        } label: {
            BarLabel()
                .environmentObject(basher)
        }
        .menuBarExtraStyle(.window)
       
    }
}
