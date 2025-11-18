//
//  HashID.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 13/11/25.
//

import CryptoKit
import Foundation

/// A stable, deterministic identifier generated from a set of encodable fields.
///
/// StableID produces a repeatable SHA-256–based string identifier by hashing the
/// JSON-encoded representation of one or more input values. Given the same set and
/// order of inputs, the resulting `id` will always be identical across runs and
/// processes, making it suitable for caching keys, deduplication, or stable
/// identifiers in persisted data.
///
/// Conforms to:
/// - `CustomStringConvertible`: Returns the hash string via `description`.
/// - `Codable`: Supports encoding and decoding of the identifier.
/// - `Identifiable`: Exposes the computed hash as its `id`.
/// - `Hashable`: Can be used in sets and as dictionary keys.
/// - `Sendable`: Safe to use across concurrency domains.
///
/// Notes:
/// - The stability of the identifier depends on the JSON encoding of each field.
///   Any changes to the encoding strategy or to the structure of the inputs will
///   change the resulting identifier.
/// - The order of the provided fields matters; different orders produce different
///   identifiers.
/// - Fields that fail to encode are skipped; only successfully encoded fields
///   contribute to the final hash.
///
/// Example:
/// ```swift
/// let userID = StableID(using: "user", 42, ["role": "admin"])
/// print(userID.id) // A deterministic SHA-256 hex string
/// ```
///
/// - SeeAlso: `SHA256` in CryptoKit, `JSONEncoder`
public struct StableID: CustomStringConvertible, Codable, Identifiable, Hashable, Sendable {
    
    public var id: String
    
    public init(using fields: any Encodable...) {
        let data = fields.compactMap { try? JSONEncoder().encode($0) }.joined()
        let digest = SHA256.hash(data: Data(data))
        self.id = digest.map { String(format: "%02x", $0) }.joined()
    }
    
    public var description: String { self.id }
}
