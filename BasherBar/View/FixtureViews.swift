//
//  FixtureViews.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct FixtureList: View {
    
    @EnvironmentObject var basher: Basher
    
    @State var adding = false
    
    
    var body: some View {
        List {
            ForEach(basher.fixtures.indices, id: \.self) { index in
                FixtureItem(fixture: $basher.fixtures[index] )
            }
            
        }
    }
}

struct FixtureButts: View {
    @EnvironmentObject var basher: Basher
    
    @State var adding = false
    
    @State var newFixture = Fixture()
    
    var body: some View {
        HStack {
            if adding {
                TextField("URL:", text: $newFixture.page.address)
                    .onSubmit {
                        basher.addFixture(newFixture)
                        newFixture = Fixture()
                        adding = false
                        return
                    }
            } else {
                Button {
                    adding = true
                } label: {
                    Label ("Add Fixture", systemImage: "plus.square")
                }
            }
            Spacer()
            
            Button {
                Task {
                    await basher.fetchMatches()
                }
            } label: {
                Label("Reload", systemImage: "arrow.uturn.down")
            }
        }
    }
}

struct FixtureItem: View {
    
    @EnvironmentObject var basher: Basher
    @Binding var fixture: Fixture
    @State var editing = ""
    
    var body: some View {
        if editing.isEmpty {
            Text(fixture.page.address)
                .textContentType(.URL)
                .onTapGesture {
                    editing = fixture.page.address
                }
                .contextMenu {
                    Button("Visit") {
                        basher.visit(fixture)
                    }
                    Button("Delete") {
                        basher.trash(fixture)
                    }
                }
        } else {
            TextField("", text: $editing)
                .textFieldStyle(.squareBorder)
                .onSubmit {
                    fixture.page.address = editing
                    editing = ""
                }
        }
    }
}


#Preview {
    FixtureList()
        .environmentObject(Basher.dummy())
}
