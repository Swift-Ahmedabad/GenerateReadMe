//
//  Socials.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 26/11/25.
//

import Foundation

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

extension Socials: CustomStringConvertible {
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
