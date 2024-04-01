//
//  Defaults.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI

struct Default {
    
    @Preference(key: .fixturePages, def: [Web.Page.dummy()])
    static var fixturePages: [Web.Page]
    
    @Preference(key: .matchPage, def: Web.Page())
    static var matchPage: Web.Page
    
}

extension Preference {
    
    enum Key: String {
        case fixturePages
        case matchPage
    }
    
}
