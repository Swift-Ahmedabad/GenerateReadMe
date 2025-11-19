//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation

public struct Sponsors: Codable {
    public var vanue: String
    public var food: String?
    
    public init(vanue: String, food: String? = nil) {
        self.vanue = vanue
        self.food = food
    }
}

public struct EventInfo: Identifiable, Codable {
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
        guard let eventID = decoder.userInfo[CodingUserInfoKey(rawValue: EventInfo.CodingKeys.eventID.stringValue)!] as? Event.ID else {
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
        let agendas = try agendaContainer.decode([Agenda].self, forKey: .agenda)
        self.agenda = agendas
    }
}
