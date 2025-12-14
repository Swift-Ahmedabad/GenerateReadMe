//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 14/12/25.
//

import Foundation

public struct UpdatedAt: Codable, Equatable {
    public var date: Date
    
    public init(date: Date = .now) {
        self.date = date
    }
}
