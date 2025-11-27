//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 26/11/25.
//

import Foundation

public struct Volunteer: Codable, Equatable, Identifiable, Sendable {
    public var id: String
    public var name: String
    public var image: String?
    public var socials: Socials?
    
    public init(name: String, image: String? = nil, socials: Socials? = nil) {
        self.name = name
        self.image = image
        self.socials = socials
        self.id = StableID(using: name, image).id
    }
}
