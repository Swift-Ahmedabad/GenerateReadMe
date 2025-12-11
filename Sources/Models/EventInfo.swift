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

public struct Sponsors: Codable {
    public var vanue: Sponsor
    public var food: Sponsor?
    
    public init(vanue: Sponsor, food: Sponsor? = nil) {
        self.vanue = vanue
        self.food = food
    }
}

public struct EventInfo: Identifiable, Codable {
    
    public var id: String
    public var eventID: Event.ID
    public var date: Date
    public var about: String
    public var location: Location
    public var sponsors: Sponsors
    public var photoURL: URL?
    
    public enum CodingKeys: CodingKey {
        case id
        case eventID
        case date
        case about
        case location
        case sponsors
        case photoURL
    }
    
    public init(about: String, eventID: Event.ID, date: Date, location: Location, sponsors: Sponsors, photoURL: URL?) {
        self.id = StableID(using: about, date, eventID).id
        self.eventID = eventID
        self.about = about
        self.date = date
        self.location = location
        self.sponsors = sponsors
        self.photoURL = photoURL
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
    }
}

public struct SponsorIDs: Codable {
    public var vanueSponsorID: Sponsor.ID
    public var foodSponsorID: Sponsor.ID?
}
extension SponsorIDs {
    init(from sponsors: Sponsors) {
        self.init(vanueSponsorID: sponsors.vanue.id, foodSponsorID: sponsors.food?.id)
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
        public var map: URL
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
        let sponsors = try eventInfoContainer.decode(Sponsors.self, forKey: .sponsors)
        let photoURL = try eventInfoContainer.decodeIfPresent(URL.self, forKey: .photoURL)
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
            self.eventInfo = .init(about: about, eventID: eventID, date: date, location: location, sponsors: sponsors, photoURL: photoURL)
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
        let agendas = try agendaContainer.decode([Agenda].self, forKey: .agenda, configuration: dateString)
        self.agenda = agendas
    }
}
