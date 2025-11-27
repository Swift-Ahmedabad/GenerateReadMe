//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 27/11/25.
//

import Foundation

public struct AboutPage: Codable {
    public var name: String
    public var description: String
    public var organizers: [Organizer]
    public var volunteers: [String]
    public var socialMedias: Socials
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
}
