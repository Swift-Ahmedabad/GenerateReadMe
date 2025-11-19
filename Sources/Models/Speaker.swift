//
//  Speaker.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation

/// A model representing a presenter/speaker with identity, biography, and social links.
/// 
/// Speaker is Codable, Hashable, Identifiable, and Sendable, making it suitable for:
/// - Serialization to and from JSON or other encodings
/// - Use in Sets, Dictionaries, and diffable data sources
/// - Concurrency-safe transfer across actor boundaries
/// - Identification in SwiftUI lists and other UI components
///
/// Identity:
/// - The `id` is deterministically generated using the speaker's name and LinkedIn URL (if provided)
///   via `StableID`, ensuring stable, reproducible identifiers across runs.
///
/// Coding:
/// - Custom CodingKeys map to capitalized keys commonly found in external JSON:
///   - "Speaker", "Socials", and "About".
/// - The `id` is not decoded from input; it is re-computed to remain stable and trustworthy.
///
/// Display:
/// - Conforms to `CustomStringConvertible` producing a Markdown-ready description, including:
///   - A title with the speaker’s name
///   - Optional "about" text
///   - Optional "Follow on:" line with formatted social links
///
/// Nested type: `Speaker.Socials`
/// - Holds optional URLs/handles for LinkedIn, GitHub, Portfolio, and Twitter.
/// - Codable with custom keys: "LinkedIn", "Github", "Portfolio", "Twitter".
/// - Conforms to `CustomStringConvertible` to produce a comma-separated Markdown link list.
///
/// Initialization:
/// - `init(speaker:socials:about:)`
///   - Computes a stable `id` using the speaker’s name and LinkedIn URL (if available).
///
/// Decoding:
/// - `init(from:)`
///   - Decodes `speaker`, `socials`, and `about`.
///   - Recomputes `id` using the same stable algorithm.
///
/// Thread-safety:
/// - Marked `Sendable` to allow safe usage across concurrency domains.
///
/// Use cases:
/// - Rendering speaker bios in README generation or documentation
/// - Populating UI components with consistent identity and display-ready descriptions
/// - Interoperating with external JSON sources using the provided key mapping
public struct Speaker: Codable, Hashable, Identifiable, Sendable {
    
    /// A collection of optional social profile links for a speaker/presenter.
    /// 
    /// Purpose:
    /// - Encapsulates common social/contact endpoints that can be rendered as Markdown links
    ///   or encoded/decoded from external JSON sources.
    /// - Used by `Speaker` to provide follow/contact information.
    ///
    /// Properties:
    /// - linkedIn: Optional URL string to the speaker's LinkedIn profile.
    /// - github: Optional URL string to the speaker's GitHub profile.
    /// - portfolio: Optional URL string to the speaker's personal website or portfolio.
    /// - twitter: Optional URL string to the speaker's Twitter/X profile.
    ///
    /// Coding:
    /// - Conforms to `Codable` with custom keys matching common external payloads:
    ///   - "LinkedIn", "Github", "Portfolio", "Twitter".
    /// - All properties are optional, allowing partial data without decoding failures.
    ///
    /// Initialization:
    /// - Designated initializer accepts any combination of the four properties, defaulting to nil.
    ///
    /// Thread-safety:
    /// - Marked `Sendable` to enable safe transfer across concurrency domains.
    ///
    /// Display:
    /// - Conforms to `CustomStringConvertible` (see extension) to produce a comma-separated
    ///   Markdown-formatted link list suitable for README or documentation output.
    public struct Socials: Codable, Hashable, Sendable {
        public var linkedIn: String?
        public var github: String?
        public var portfolio: String?
        public var twitter: String?
        
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
    public var image: String?
    
    public init(speaker: String, socials: Socials? = nil, about: String? = nil, image: String? = nil) {
        self.speaker = speaker
        self.socials = socials
        self.about = about
        self.image = image
        self.id = StableID(using: speaker, socials?.linkedIn ?? "").id
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speaker = try container.decode(String.self, forKey: .speaker)
        self.socials = try container.decodeIfPresent(Speaker.Socials.self, forKey: .socials)
        self.about = try container.decodeIfPresent(String.self, forKey: .about)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.id = StableID(using: speaker, socials?.linkedIn ?? "").id
    }
}

extension Speaker.Socials: CustomStringConvertible {
    /// A comma-separated Markdown-formatted list of available social links.
    /// 
    /// - Returns: A string where each present social handle is represented as a Markdown link:
    ///   - `[LinkedIn](<url>)` if `linkedIn` is non-nil
    ///   - `[Github](<url>)` if `github` is non-nil
    ///   - `[Portfolio](<url>)` if `portfolio` is non-nil
    ///   - `[Twitter](<url>)` if `twitter` is non-nil
    /// 
    /// The links are ordered as LinkedIn, GitHub, Portfolio, then Twitter, and
    /// are joined by ", ". If none are present, the result is an empty string.
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
    /// A Markdown-formatted summary of the speaker suitable for README or documentation output.
    ///
    /// Format:
    /// - Title line: "### By: **<name>**"
    /// - Optional about paragraph: appended on the next line if `about` is present
    /// - Optional socials line: appended as "Follow on: <links>" with a comma-separated list
    ///   generated by `Speaker.Socials.description`
    ///
    /// Examples:
    /// - With about and socials:
    ///
    ///     "### By: **Jane Doe**\nA short bio...\n\nFollow on: [LinkedIn](...), [Github](...)"
    ///
    /// - With only name:
    ///
    ///     "### By: **Jane Doe**"
    ///
    /// Thread-safety:
    /// - Purely derived from stored properties; no side effects.
    ///
    /// - Returns: A single string containing the formatted Markdown representation.
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
