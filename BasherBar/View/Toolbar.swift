//
//  Toolbar.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/22.
//

import SwiftUI

struct Toolbar: View {
    
    @EnvironmentObject var basher: Basher
    
    @State var countdown: String = ""
    
    let tick = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        Button {
            refresh()
        } label: {
            Label(countdown, systemImage: "arrow.clockwise")
        }
        .onReceive(tick) { _ in
            if basher.ticker.isValid {
                countdown = "\(Int(basher.ticker.fireDate.timeIntervalSinceNow))"
            } else {
                countdown = "Refresh"
            }
        }
    }
    
    
    func refresh() {
        basher.tock()
    }
}

#Preview {
    Toolbar()
}
