//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 06/11/25.
//

import Foundation

public struct Speaker: Codable, Sendable {
    public struct Socials: Codable, Sendable {
        public var linkedIn: String?
        public var github: String?
        public var portfolio: String?
        public var twitter: String?
        
        enum CodingKeys: String, CodingKey {
            case linkedIn = "LinkedIn"
            case github = "Github"
            case portfolio = "Portfolio"
            case twitter = "Twitter"
        }
        
        public init(linkedIn: String? = nil, github: String? = nil, portfolio: String? = nil, twitter: String? = nil) {
            self.linkedIn = linkedIn
            self.github = github
            self.portfolio = portfolio
            self.twitter = twitter
        }
    }
    
    public var speaker: String
    public var socials: Socials?
    public var about: String?
    
    enum CodingKeys: String, CodingKey {
        case speaker = "Speaker"
        case socials = "Socials"
        case about = "About"
    }
    
    public init(speaker: String, socials: Socials? = nil, about: String? = nil) {
        self.speaker = speaker
        self.socials = socials
        self.about = about
    }
}

extension Speaker.Socials: CustomStringConvertible {
    public var description: String {
        var strings: [String] = []
        if let linkedIn {
            strings.append("[LinkedIn](\(linkedIn))")
        }
        if let github {
            strings.append("[Github](\(github))")
        }
        if let portfolio {
            strings.append("[Portfolio](\(portfolio))")
        }
        if let twitter {
            strings.append("[Twitter](\(twitter))")
        }
        return strings.joined(separator: ", ")
    }
}

extension Speaker: CustomStringConvertible {
    public var description: String {
        var string = """
        ### By: **\(speaker)**
        """
        if let about = about {
            string.append("\n\(about)")
        }
        if let socialDescription = socials?.description {
            string.append("\n\nFollow on: \(socialDescription)")
        }
        return string
    }
}

public struct Talk: Codable {
    public var title: String
    public var speakers: [Speaker]
    
    public init(title: String, speakers: [Speaker]) {
        self.title = title
        self.speakers = speakers
    }
}

extension Talk: CustomStringConvertible {
    public var description: String {
        """
        ## \(title.description)
        \(speakers.map { $0.description }.joined(separator: "\n"))
        """
    }
}

public struct Event: Codable, Identifiable {
    public var title: String
    public var date: Date
    public var id: String
    public var talks: [Talk]
    
    public init(title: String, date: Date, talks: [Talk]) {
        self.title = title
        self.date = date
        self.talks = talks
        self.id = StableID(title, date).id
    }
}

extension Event: CustomStringConvertible {
    public var description: String {
        """
        # \(title)
        \(talks.map { $0.description }.joined(separator: "\n") )
        """
    }
}
