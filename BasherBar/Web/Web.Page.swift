//
//  Page.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/4/1.
//

import Foundation
import Fuzi

extension Web {
    struct Page: Identifiable {
        
        enum CodingKeys: String, CodingKey {
            case address
        }
        
        let id = UUID()
        
        var address: String = ""
        
        var url: URL? {
            URL(string: address)
        }
        
        func data() async throws -> Data? {
            guard let url else { return nil }
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        }
        
        func html() async throws -> String? {
            guard let data = try await data() else { return nil }
            return String(data: data, encoding: .utf8)
        }
        
        func doc() async throws -> HTMLDocument? {
            guard let data = try await data() else { return nil }
            return try HTMLDocument(data: data)
        }
        
    }
}

extension Web.Page: RawRepresentable {
    
    typealias RawValue = String
    
    var rawValue: String {
        address
    }
    
    init?(rawValue: String) {
        self.address = rawValue
    }
    
}
    

