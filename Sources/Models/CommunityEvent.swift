//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 17/02/26.
//

import Foundation

public struct Community: Codable, Identifiable {
    public var id: String
    public var name: String
    public var resourcePath: String
    public var logo: String
    
    public init(id: String, name: String, resourcePath: String, logo: String) {
        self.id = id
        self.name = name
        self.resourcePath = resourcePath
        self.logo = logo
    }
}

public struct CommunityEvent: Codable {
    public var id: String
    public var communityID: Community.ID
    public var eventID: Event.ID
    
    public init(communityID: Community.ID, eventID: Event.ID) {
        self.id = StableID(using: communityID, eventID).id
        self.communityID = communityID
        self.eventID = eventID
    }
}
