//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 15/05/26.
//

import Foundation

public struct CommunityPublicationStatus: Codable, Equatable, Sendable {
    public var id: Community.ID
    public var publicationStatus: PublicationStatus
    public var minVersion: String
    
    public init(id: Community.ID, publicationStatus: PublicationStatus, minVersion: String) {
        self.id = id
        self.publicationStatus = publicationStatus
        self.minVersion = minVersion
    }
}
