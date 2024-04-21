//
//  Defaults.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI
import Combine

struct Default {
    
    
    @Preference(key: .numbers, def: [1,2,3])
    static var numbers: [Int]
    
    
    @Preference(key: .fixtures, def: [])
    static var fixtures: [Fixture]
    
    @Preference(key: .matchPage, def: Web.Page())
    static var matchPage: Web.Page
    
    
}

extension Preference {
    
    enum Key: String {
        case numbers
        case fixtures
        case matchPage
    }
    
}
