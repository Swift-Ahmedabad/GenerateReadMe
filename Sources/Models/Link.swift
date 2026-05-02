//
//  Link.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 02/05/26.
//

import Foundation

public struct Link: Codable, Hashable, Identifiable, Sendable {
    public var id: UUID
    public var title: String
    public var url: URL
    
    public init(id: UUID = .init(), title: String, url: URL) {
        self.id = id
        self.title = title
        self.url = url
    }
}
