//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 20/03/26.
//

import Foundation

public struct TalkInfo: Codable, Equatable {
    public var title: String
    public var about: String
    
    public init(title: String, about: String) {
        self.title = title
        self.about = about
    }
}

public struct TalkInfoRecord: Codable, Equatable {
    public var talkID: String
    public var title: String
    public var about: String
    
    public init(talkID: String, title: String, about: String) {
        self.talkID = talkID
        self.title = title
        self.about = about
    }
}
