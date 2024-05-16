//
//  Cricket.Commentary.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/5/16.
//

import Foundation

extension Cricket {
    struct Commentary {
        
        var balls = [Ball]()
        
        var last: Int {
            balls.first?.id ?? 0
        }
        
        struct Ball {
            var id: Int
            var over: Over
            var runs: Int = 0
            var extras: Int = 0
            var boundary: Bool = false
            var wicket: String?
            var text: String = ""
        }
        
        func balls(since: Int) -> [Ball] {
            balls.filter { $0.id > since }
        }
        
        func wickets(since: Int) -> [String] {
            balls.filter { $0.id > since}.compactMap { $0.wicket }
        }
        
    }
}
