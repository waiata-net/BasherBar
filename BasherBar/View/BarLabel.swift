//
//  BarLabel.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct BarLabel: View {
    
    @EnvironmentObject var basher: Basher
    
    @State var bar: Basher.Bar = Basher.defaultBar
    
    let tick = Timer.publish(every: Default.barRate, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Label(
            title: { Text(bar.text) },
            icon: { Icon(icon: bar.icon)}
        )
        Text(bar.text)
        .onReceive(tick) { input in
            bar = basher.bar()
        }
    }
    
    struct Icon: View {
        
        var icon: String?
        let ball = Image(systemName: "cricket.ball")
        
        var body: some View {
            let url = URL(string: icon ?? "")
            return AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ball
            }
        }
    }
}

#Preview {
    BarLabel()
        .environmentObject(Basher.dummy())
}
