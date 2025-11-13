//
//  HashID.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 13/11/25.
//

import CryptoKit
import Foundation

public struct StableID: Identifiable, Hashable, CustomStringConvertible {
    
    public var id: String
    
    public init(_ fields: any Encodable...) {
        let data = fields.compactMap { try? JSONEncoder().encode($0) }.joined()
        let digest = SHA256.hash(data: Data(data))
        self.id = digest.map { String(format: "%02x", $0) }.joined()
    }
    
    public var description: String { self.id }
}
