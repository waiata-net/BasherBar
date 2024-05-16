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
    
    @Environment(\.openWindow) var openWindow

    @State var hide = true
    
    var body: some Scene {
        Window("Cricket", id: "Cricket") {
            ContentView()
                .environmentObject(basher)
        }
        MenuBarExtra {
            VStack {
                ContentView()
                Button {
                    openWindow(id: "Cricket")
                } label: {
                    Label("Open Window", systemImage: "macwindow")
                }
                .padding(.bottom)
            }
            .environmentObject(basher)
        } label: {
            BarLabel()
                .environmentObject(basher)
        }
        .menuBarExtraStyle(.window)
       
    }
    
}
