//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 27/11/25.
//

import Foundation

public struct AboutPage: Codable, Identifiable {
    public var id: String
    public var name: String
    public var description: String
    public var logo: String
    public var members: [Member]
    public var socialMedias: Socials
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.logo = try container.decode(String.self, forKey: .logo)
        self.members = try container.decode([AboutPage.Member].self, forKey: .members)
        self.socialMedias = try container.decode(Socials.self, forKey: .socialMedias)
        self.id = StableID(using: name).id
    }
    
    public init(name: String, description: String, logo: String, members: [Member], socialMedias: Socials) {
        self.id = StableID(using: name).id
        self.name = name
        self.description = description
        self.logo = logo
        self.members = members
        self.socialMedias = socialMedias
    }
}

extension AboutPage {
    public struct Organizer: Codable {
        public var name: String
        public var about: String
        public var socials: Socials
        
        public init(name: String, about: String, socials: Socials) {
            self.name = name
            self.about = about
            self.socials = socials
        }
    }
    
    public typealias Member = Self.Organizer
}
