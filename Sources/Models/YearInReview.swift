//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 29/12/25.
//

import Foundation

public struct YearInReview: Codable, Identifiable, Equatable {
    public struct EventStats: Codable, Equatable {
        public var totalEvents: Int
        public var totalParticipants: Int
        public var averageParticipants: Int
        public var totalSpeakers: Int
        public var topicsCovered: Int
        public var totalVenues: Int
        public var totalSponsors: Int
        
        public init(totalEvents: Int, totalParticipants: Int, averageParticipants: Int, totalSpeakers: Int, topicsCovered: Int, totalVenues: Int, totalSponsors: Int) {
            self.totalEvents = totalEvents
            self.totalParticipants = totalParticipants
            self.averageParticipants = averageParticipants
            self.totalSpeakers = totalSpeakers
            self.topicsCovered = topicsCovered
            self.totalVenues = totalVenues
            self.totalSponsors = totalSponsors
        }
    }
    
    public var id: String
    public var year: Int
    public var org: String
    public var eventStats: EventStats
    public var url: URL?
    public var photos: [String]?
    
    public init(year: Int, org: String, eventStats: EventStats, url: URL? = nil, photos: [String]? = nil) {
        self.id = StableID(using: year, org).id
        self.year = year
        self.org = org
        self.eventStats = eventStats
        self.url = url
        self.photos = photos
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.year = try container.decode(Int.self, forKey: .year)
        self.org = try container.decode(String.self, forKey: .org)
        self.eventStats = try container.decode(YearInReview.EventStats.self, forKey: .eventStats)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)
        self.photos = try container.decodeIfPresent([String].self, forKey: .photos)
        self.id = StableID(using: year, org).id
    }
}
