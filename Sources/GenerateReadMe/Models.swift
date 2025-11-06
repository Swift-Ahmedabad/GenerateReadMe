//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 06/11/25.
//

import Foundation

struct Speaker: Codable {
    struct Socials: Codable {
        var linkedIn: String?
        var github: String?
        var portfolio: String?
        var twitter: String?
        
        enum CodingKeys: String, CodingKey {
            case linkedIn = "LinkedIn"
            case github = "Github"
            case portfolio = "Portfolio"
            case twitter = "Twitter"
        }
    }
    
    var speaker: String
    var socials: Socials?
    var about: String?
    
    enum CodingKeys: String, CodingKey {
        case speaker = "Speaker"
        case socials = "Socials"
        case about = "About"
    }
}

extension Speaker.Socials: CustomStringConvertible {
    var description: String {
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
    var description: String {
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

struct Speakers: Codable {
    var speakers: [Speaker]
    
    enum CodingKeys: String, CodingKey {
        case speakers = "Speakers"
    }
}

extension Speakers: CustomStringConvertible {
    var description: String {
        var string = ""
        string.append(speakers.map { $0.description }.joined(separator: "\n"))
        return string
    }
}

struct Talk: Codable {
    var title: String
    var speakers: Speakers
}

extension Talk: CustomStringConvertible {
    var description: String {
        """
        ## \(title.description)
        \(speakers.description)
        """
    }
}

struct Event: Codable {
    var title: String
    var talks: [Talk]
}

extension Event: CustomStringConvertible {
    var description: String {
        """
        # \(title)
        \(talks.map { $0.description }.joined(separator: "\n") )
        """
    }
}
