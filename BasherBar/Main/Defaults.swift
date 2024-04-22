//
//  Defaults.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import SwiftUI
import Combine

struct Default {
    
    static var fixtures: [Fixture] {
        get {
            guard let links = get(.fixtures) as? [String] else { return [] }
            return links.compactMap { Fixture(rawValue: $0) }
        }
        set {
            let links = newValue.map { $0.page.address }
            set(.fixtures, links)
        }
    }
    
    static var refreshRate: TimeInterval? {
        get {
            get(.refresh) as? TimeInterval
        }
        set {
            set(.refresh, newValue)
        }
    }
    
    
    static func get(_ key: Key) -> Any? {
        UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    static func set(_ key: Key, _ value: Any?) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func key(_ key: Key) -> String {
        key.rawValue
    }
    
    enum Key: String {
        
        case fixtures
        case refresh
        
    }
}

