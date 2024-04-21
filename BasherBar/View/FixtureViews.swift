//
//  FixtureViews.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct FixtureList: View {
    
    @EnvironmentObject var basher: Basher
    
    var body: some View {
        List {
            ForEach(basher.fixtures.indices, id: \.self) { index in
                FixtureItem(fixture: $basher.fixtures[index] )
            }
            Button(action: basher.addFixture) {
                Label ("Add Fixture", systemImage: "plus.square")
            }
        }
    }
}

struct FixtureItem: View {
    
    @EnvironmentObject var basher: Basher
    @Binding var fixture: Fixture
    
    var body: some View {
        HStack {
            TextField("", text: $fixture.page.address)
                    .textFieldStyle(.plain)
            
            Spacer()
            Button {
                basher.trash(fixture)
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    FixtureList()
    .environmentObject(Basher.dummy())
}
