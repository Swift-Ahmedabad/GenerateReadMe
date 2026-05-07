//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation

public struct Sponsor: Codable, Identifiable, Hashable {
    public var id: String
    public var name: String
    public var website: URL
    public var image: String
    
    public init(name: String, website: URL, image: String) {
        self.id = StableID(using: name, website, image).id
        self.name = name
        self.website = website
        self.image = image
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.website = try container.decode(URL.self, forKey: .website)
        self.image = try container.decode(String.self, forKey: .image)
        self.id = StableID(using: name, website, image).id
    }
}

public struct SponsorItem: Codable {
    public var sponsor: Sponsor
    public var sponsoringFor: String
}

public struct EventInfo: Identifiable, Codable {
    
    public var id: String
    public var eventID: Event.ID
    public var date: Date
    public var about: String
    public var location: Location
    public var sponsors: [SponsorItem]
    public var photoURL: URL?
    public var registrationLink: URL?
    public var instructions: String?
    
    public enum CodingKeys: CodingKey {
        case id
        case eventID
        case date
        case about
        case location
        case sponsors
        case photoURL
        case registrationLink
        case instructions
    }
    
    public init(about: String, eventID: Event.ID, date: Date, location: Location, sponsors: [SponsorItem], photoURL: URL?, registrationLink: URL?, instructions: String?) {
        self.id = StableID(using: about, date, eventID).id
        self.eventID = eventID
        self.about = about
        self.date = date
        self.location = location
        self.sponsors = sponsors
        self.photoURL = photoURL
        self.registrationLink = registrationLink
        self.instructions = instructions
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.eventID, forKey: .eventID)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.about, forKey: .about)
        try container.encode(self.location, forKey: .location)
        try container.encode(SponsorIDs(from: self.sponsors), forKey: .sponsors)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.registrationLink, forKey: .registrationLink)
        try container.encodeIfPresent(self.instructions, forKey: .instructions)
    }
}

public struct SponsorID: Codable {
    public var sponsorID: Sponsor.ID
    public var sponsoringFor: String
}

typealias SponsorIDs = [SponsorID]

extension SponsorIDs {
    init(from sponsors: [SponsorItem]) {
        self = sponsors.map { SponsorID(sponsorID: $0.sponsor.id, sponsoringFor: $0.sponsoringFor) }
    }
}

extension EventInfo {
    public struct Location: Codable {
        public struct Coordinates: Codable {
            public var latitude: Double
            public var longitude: Double
            public var zoom: Double
            
            public init(latitude: Double, longitude: Double, zoom: Double) {
                self.latitude = latitude
                self.longitude = longitude
                self.zoom = zoom
            }
        }
        
        public var name: String
        public var map: URL?
        public var address: String
        public var coordinates: Coordinates
    }
}

extension EventInfo {
    public static var eventIDUserInfoKey: CodingUserInfoKey {
        CodingUserInfoKey(rawValue: CodingKeys.eventID.stringValue)!
    }
    
    public static var eventDateUserInfoKey: CodingUserInfoKey {
        CodingUserInfoKey(rawValue: "eventDate")!
    }
}

public struct EventInfoWithAgendas: Codable {
    public var eventInfo: EventInfo
    public var agenda: [Agenda]
    
    public init(eventInfo: EventInfo, agendas: [Agenda]) {
        self.eventInfo = eventInfo
        self.agenda = agendas
    }
    
    public init(from decoder: any Decoder) throws {
        let eventInfoContainer = try decoder.container(keyedBy: EventInfo.CodingKeys.self)
        let about = try eventInfoContainer.decode(String.self, forKey: .about)
        let dateString = try eventInfoContainer.decode(String.self, forKey: .date)
        let location = try eventInfoContainer.decode(EventInfo.Location.self, forKey: .location)
        let sponsors = try eventInfoContainer.decode([SponsorItem].self, forKey: .sponsors)
        let photoURL = try eventInfoContainer.decodeIfPresent(URL.self, forKey: .photoURL)
        let registrationLink = try eventInfoContainer.decodeIfPresent(URL.self, forKey: .registrationLink)
        let instructions = try eventInfoContainer.decodeIfPresent(String.self, forKey: .instructions)
        let dateFormatter = DateFormatter()
        guard let eventID = decoder.userInfo[EventInfo.eventIDUserInfoKey] as? Event.ID else {
            throw DecodingError.valueNotFound(
                Event.ID.self,
                .init(
                    codingPath: [EventInfo.CodingKeys.eventID],
                    debugDescription: "No Event ID from decoder userInfo"
                )
            )
        }
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        if let date = dateFormatter.date(from: dateString) {
            self.eventInfo = .init(about: about, eventID: eventID, date: date, location: location, sponsors: sponsors, photoURL: photoURL, registrationLink: registrationLink, instructions: instructions)
        } else {
            throw DecodingError.typeMismatch(
                Date.self,
                .init(
                    codingPath: [EventInfo.CodingKeys.date],
                    debugDescription: "Invalid date format, it should be of \"MMMM dd, yyyy\""
                )
            )
        }
        enum AgendasCodingKeys: String, CodingKey {
            case agendas
        }
        
        let agendaContainer = try decoder.container(keyedBy: CodingKeys.self)
        let agendas = try agendaContainer.decodeIfPresent([Agenda].self, forKey: .agenda, configuration: dateString)
        self.agenda = agendas ?? []
    }
}
