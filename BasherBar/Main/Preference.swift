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
            
            if let A = T.self as? [any RawRepresentable].Type,
               let raws = store.array(forKey: key),
               let E = A.Element as? (any RawRepresentable).Type
            {
                return raws.map { $0 } as! T
            } else {
                return store.value(forKey: key) as? T ?? def
            }
        }
        set {
            if let raw = newValue as? (any RawRepresentable) {
                let raw = raw.rawValue
                store.set(raw, forKey: key)
            } else if let array = newValue as? [(any RawRepresentable)] {
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
    
    var kind: Kind? {
        switch T.self {
        case is UserDefaultable : return .value
        case is UserDefaultableArray : return .array
        case is any RawRepresentable : return .raw
        case is RawRepresentableArray.Type : return .rawArray
        case is Codable : return .codable
        default: return nil
        }
    }
    

    
    enum Kind: CaseIterable {
        case value
        case array
        case raw
        case rawArray
        case codable
        
        var types: [Any.Type] {
            switch self {
            case .value: return [Data.self, String.self, Date.self, Bool.self, Int.self, Double.self, Float.self, URL.self]
            case .array: return [[Data].self, [String].self, [Date].self, [Bool].self, [Int].self, [Double].self, [Float].self, [URL].self]
            case .raw: return [(any RawRepresentable).self]
            case .rawArray: return [([any RawRepresentable]).self]
            case .codable: return [(any Codable).self]
            }
        }
        
    }
    
}



protocol UserDefaultable { }

extension Int: UserDefaultable { }

protocol UserDefaultableArray { }

extension Array: UserDefaultableArray where Element: UserDefaultable { }

protocol RawRepresentableArray { }

extension Array: RawRepresentableArray where Element: RawRepresentable { }



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
