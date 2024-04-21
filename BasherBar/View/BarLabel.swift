//
//  BarLabel.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct BarLabel: View {
    
    @EnvironmentObject var basher: Basher
    
    var body: some View {
        Label(basher.bar, systemImage: "cricket.ball.fill")
    }
}

#Preview {
    BarLabel()
        .environmentObject(Basher.dummy())
}
