//
//  CricketView.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct CricketView: View {
    
    @Environment(Basher.self) var basher
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CricketView()
        .environment(Basher.dummy())
}
