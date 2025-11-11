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
}
