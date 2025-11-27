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
    public var luma: String?
    public var whatsApp: String?
    public var instagram: String?
    public var arattai: String?
    public var discord: String?

    public init(linkedIn: String? = nil, github: String? = nil, portfolio: String? = nil, twitter: String? = nil, luma: String? = nil, whatsApp: String? = nil, instagram: String? = nil, arattai: String? = nil, discord: String? = nil) {
        self.linkedIn = linkedIn
        self.github = github
        self.portfolio = portfolio
        self.twitter = twitter
        self.luma = luma
        self.whatsApp = whatsApp
        self.instagram = instagram
        self.arattai = arattai
        self.discord = discord
    }
}

extension Socials: CustomStringConvertible {
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
        if let luma {
            strings.append("[Luma](\(luma)")
        }
        if let whatsApp {
            strings.append("[WhatsApp](\(whatsApp)")
        }
        if let instagram {
            strings.append("[Instagram](\(instagram)")
        }
        if let arattai {
            strings.append("[Arattai](\(arattai)")
        }
        if let discord {
            strings.append("[Discord](\(discord)")
        }
        return strings.joined(separator: ", ")
    }
}
