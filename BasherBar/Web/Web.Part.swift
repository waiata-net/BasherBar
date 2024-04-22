//
//  Path.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import Foundation
import Fuzi

extension Web {
    
    
    struct Part {
        
        var css: String?
        var xpath: String?
        var attribute: String?
        var prefix: String?

        
        typealias Node = Fuzi.XMLNode
        typealias Element = Fuzi.XMLElement
        typealias Box = Fuzi.Queryable
        
        func elements(in box: Box) -> [Element] {
            if let css {
                return box.css(css).map{ $0 }
            } else if let xpath {
                return box.xpath(xpath).map{ $0 }
            } else {
                return []
            }
        }
        
        func first(in box: Box) -> Element? {
            if let css {
                return box.firstChild(css: css)
            } else if let xpath {
                return box.firstChild(xpath: xpath)
            } else {
                return nil
            }
        }
        
        func strings(in box: Box) -> [String] {
            return elements(in: box).compactMap {
                string($0)
            }
        }
        
        func string(in box: Box) -> String? {
            guard let first = first(in: box) else { return nil }
            return string(first)
        }
        
        func string(_ element: Element?) -> String? {
            guard let element else { return nil }
            if let a = attribute {
              return pre(element.attr(a))
            } else {
                return pre(element.stringValue)
            }
        }
        
        func pre(_ plus: String?) -> String? {
            guard let plus else { return nil }
            return (prefix ?? "") + plus
        }
        
        func datum(in box: Box) -> Data? {
            guard let string = string(in: box) else { return nil }
            return string.data(using: .utf8)
        }
        
        
    }
}

extension Fuzi.Queryable {
    
    func elements(_ part: Web.Part) -> [Fuzi.XMLElement] {
        part.elements(in: self)
    }
    
    func element(_ part: Web.Part) -> Fuzi.XMLElement? {
        part.first(in: self)
    }
    
    func strings(_ part: Web.Part) -> [String] {
        part.strings(in: self)
    }
    
    func string(_ part: Web.Part) -> String? {
        part.string(in: self)
    }
    
}

