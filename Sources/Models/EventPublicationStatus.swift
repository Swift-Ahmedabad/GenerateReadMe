//
//  EventPublicationStatus.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 04/05/26.
//

import Foundation

public struct EventPublicationStatus: Codable, Equatable, Identifiable, Sendable {
    public var id: Event.ID
    public var publicationStatus: PublicationStatus
    
    public init(id: Event.ID, publicationStatus: PublicationStatus) {
        self.id = id
        self.publicationStatus = publicationStatus
    }
}
