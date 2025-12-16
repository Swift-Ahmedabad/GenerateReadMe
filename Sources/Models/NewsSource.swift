//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 16/12/25.
//

import Foundation

public struct NewsSource: Codable, Identifiable, Sendable {
    public var id: String
    public var title: String
    public var url: URL
    
    public init(title: String, url: URL) {
        self.id = StableID(using: url).id
        self.title = title
        self.url = url
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(URL.self, forKey: .url)
        self.id = StableID(using: url).id
    }
}
