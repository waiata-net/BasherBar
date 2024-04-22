//
//  Match.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/22.
//

import Foundation

struct Match: Identifiable {
    
    var id = UUID()
    
    var title = ""
    
    var link = ""
    
    var page: Web.Page {
        Web.Page(address: link)
    }
    
    var game: Cricket.Game?
}
