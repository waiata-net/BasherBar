//
//  Preference.swift
//
//  Created by Neal Watkins on 2020/10/14.
//  Copyright © 2020 Waiata. All rights reserved.
//

import Foundation


@propertyWrapper 
public struct Preference<T> {
    
    public var key: String
    public var def: T
    var store: UserDefaults = .standard

    public var wrappedValue: T {
        get {
            return store.value(forKey: key) as? T ?? def
        }
        set {
            if let raw = newValue as? (any RawRepresentable) {
                let raw = raw.rawValue
                store.set(raw, forKey: key)
            } else if let array = newValue as? ([any RawRepresentable]) {
                let raws = array.map { $0.rawValue }
                store.set(raws, forKey: key)
            } else if let codable = newValue as? (any Codable) {
                guard let data = try? PropertyListEncoder().encode(codable) else { return }
                store.set(data, forKey: key)
            } else {
                store.set(newValue, forKey: key)
            }
        }
    }

}

extension Preference where T: ExpressibleByNilLiteral {
    init(key: String, store: UserDefaults = .standard) {
        self.init(key: key, def: nil, store: store)
    }
}

extension Preference {
    
    init(key: Key, def: T, store: UserDefaults = .standard) {
        self.init(key: key.rawValue, def: def, store: store)
    }
    
}
