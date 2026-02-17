//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 09/01/26.
//

import Foundation

public struct PodcastSource: Codable, Equatable {
    public var id: String
    public var name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}


public struct PodcastSourceResponse: Codable {
    public var podcasts: [PodcastSource]
    
    public init(podcasts: [PodcastSource]) {
        self.podcasts = podcasts
    }
}
