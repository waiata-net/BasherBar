//
//  BarLabel.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct BarLabel: View {
    
    @Environment(Basher.self) var basher
    
    var body: some View {
        Label(basher.bar, systemImage: "cricket.ball.fill")
    }
}

#Preview {
    BarLabel()
        .environment(Basher.dummy())
}
