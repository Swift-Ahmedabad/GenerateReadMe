//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 06/11/25.
//

import Foundation

public struct Speaker: Codable, Hashable, Sendable {
    public struct Socials: Codable, Hashable, Sendable {
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
    
    public var id: String
    public var speaker: String
    public var socials: Socials?
    public var about: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case speaker = "Speaker"
        case socials = "Socials"
        case about = "About"
    }
    
    public init(speaker: String, socials: Socials? = nil, about: String? = nil) {
        self.speaker = speaker
        self.socials = socials
        self.about = about
        self.id = StableID(speaker, socials?.linkedIn ?? "").id
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speaker = try container.decode(String.self, forKey: .speaker)
        self.socials = try container.decodeIfPresent(Speaker.Socials.self, forKey: .socials)
        self.about = try container.decodeIfPresent(String.self, forKey: .about)
        self.id = StableID(speaker, socials?.linkedIn ?? "").id
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
    public var id: String
    public var title: String
    public var speakers: [Speaker]
    
    public init(title: String, speakers: [Speaker]) {
        self.title = title
        self.speakers = speakers
        self.id = StableID(title, speakers.map { $0.id }.joined(separator: "-")).id
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
    public var id: String
    public var title: String
    public var date: Date
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
