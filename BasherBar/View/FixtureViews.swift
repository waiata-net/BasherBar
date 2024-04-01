//
//  FixtureViews.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct FixtureList: View {
    
    @Environment(Basher.self) var basher
    
    var body: some View {
        @Bindable var basher = basher
        List {
            ForEach(basher.fixturePages.indices, id: \.self) { index in
                FixtureItem(page: $basher.fixturePages[index] )
            }
            Button(action: basher.addFixturePage) {
                Label ("Add Fixture", systemImage: "plus.square")
            }
            
        }
    }
}

struct FixtureItem: View {
    
    @Environment(Basher.self) var basher
    @Binding var page: Web.Page
    @State var editing = false
    
    var body: some View {
        HStack {
            if editing {
                TextField("", text: $page.address)
                    .textFieldStyle(.plain)
            } else {
                Text(page.url?.lastPathComponent ?? page.address)
                    .onTapGesture {
                        editing = true
                    }
            }
            Spacer()
            Button {
                basher.trash(page)
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    FixtureList()
    .environment(Basher.dummy())
}
