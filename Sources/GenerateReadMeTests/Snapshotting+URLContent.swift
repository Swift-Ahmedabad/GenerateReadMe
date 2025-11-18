//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 11/11/25.
//

import Foundation
@preconcurrency import SnapshotTesting

extension Snapshotting where Value == URL, Format == String {
    static let urlContent = Snapshotting(pathExtension: "md", diffing: .lines) { value in
        (try? String(contentsOf: value, encoding: .utf8)) ?? ""
    }
    
    static let jsonURLContent = Snapshotting(pathExtension: "json", diffing: .lines) { value in
        if let json = try? JSONSerialization.jsonObject(with: Data(contentsOf: value)),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]) {
            return String(decoding: jsonData, as: UTF8.self)
        }
        return ""
    }
}
