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
        VStack {
            ForEach(basher.fixtures.indices, id: \.self) { index in
                FixtureItem(fixture: $basher.fixtures[index] )
            }
            
            HStack {
                
                Button {
                    adding = true
                } label: {
                    Label ("Add Fixture", systemImage: "plus.square")
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
        .padding()
        .sheet(isPresented: $adding) {
            AddFixture()
        }
    }
}


struct AddFixture: View {
    
    @EnvironmentObject var basher: Basher
    @Environment(\.dismiss) var dismiss
    
    @State var fixture = Fixture()
    
    var body: some View {
        Form {
            TextField("URL:", text: $fixture.page.address)
        }
        .frame(width: 480)
        .padding()
        .onSubmit {
            guard let url = fixture.page.url else {
                dismiss()
                return
            }
            basher.addFixture(fixture)
            dismiss()
            return
        }
    }
}

struct FixtureItem: View {
    
    @EnvironmentObject var basher: Basher
    @Binding var fixture: Fixture
    
    var body: some View {
        Text(fixture.page.address)
            .contextMenu {
                Button("Visit") {
                    basher.visit(fixture)
                }
                Button("Delete") {
                    basher.trash(fixture)
                }
            }
            .textContentType(.URL)
    }
    
}


#Preview {
    FixtureList()
        .environmentObject(Basher.dummy())
}
