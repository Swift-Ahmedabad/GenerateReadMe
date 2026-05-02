//
//  TalkResource.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 02/05/26.
//

import Foundation

public struct TalkResource: Codable, Sendable {
    public var talkID: Talk.ID
    public var links: [Link]
    
    public init(talkID: Talk.ID, links: [Link]) {
        self.talkID = talkID
        self.links = links
    }
}
