//
//  BasherBarApp.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

@main
struct BasherBarApp: App {
    
    @StateObject var basher = Basher()
    
    var body: some Scene {
        Window("Cricket", id: "Cricket") {
            ContentView()
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
