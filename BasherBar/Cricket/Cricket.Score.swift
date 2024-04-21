//
//  Score.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import Foundation

extension Cricket {
    
    struct Score {
        var order: Int = 0
        var team: Int?
        var over = Over()
        var runs: Int = 0
        var outs: Int = 0
        
        var rpo: Double {
            Double(runs) / Double(over.balls) * 6
        }
        
        var text: String {
            var score = "\(runs)/\(outs)"
            let over = over.text
            if !over.isEmpty { score += " (\(over))" }
            return score
        }
    }
    
    struct Over {
        var over: Int = 0
        var ball: Int = 0
        
        var balls: Int {
            over * 6 + ball
        }
        
        var text: String {
            if balls == 0 {
                return ""
            } else if ball == 0 {
                return "\(over)"
            } else {
                return "\(over).\(ball)"
            }
        }
        
        static subscript(_ string: String) -> Over {
            var ob = string.split(separator: ".")
            let o = ob.isEmpty ? 0 : Int(ob.removeFirst()) ?? 0
            let b = ob.isEmpty ? 0 : Int(ob.removeFirst()) ?? 0
            return Over(over: o, ball: b)
        }
        
        
        static subscript(_ double: Double) -> Over {
            let o = Int(double)
            let b = Int((double - Double(o)) * 10)
            return Over(over: o, ball: b)
        }
    }
}
