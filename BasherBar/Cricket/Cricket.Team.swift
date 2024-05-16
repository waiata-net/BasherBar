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
        
        init() { }
        
        init?(name: String?) {
            guard let name, !name.isEmpty else { return nil }
            self.name = name
        }
        
        var score: String {
            inns.map { $0.text }.joined(separator: "&")
        }
        
        var initials: String {
            let words = name.split(separator: " ")
            let inits = words.compactMap { String($0.prefix(1)) }
            let join = inits.joined()
            return join
        }
    }
}
