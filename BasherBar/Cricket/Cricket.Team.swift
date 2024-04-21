//
//  Team.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import Foundation

extension Cricket {
    struct Team: Identifiable {
        
        var id: Int = UUID().hashValue
        
        var name: String = ""
        var logo: String = ""
        var inns = [Score]()
        
        var score: String {
            inns.map { $0.text }.joined(separator: "&")
        }
    }
}
