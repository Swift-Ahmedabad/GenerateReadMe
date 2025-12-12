//
//  Agenda.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 19/11/25.
//

import Foundation

public enum AgendaType: String, Codable {
    case registration
    case talk
    case sponsorTalk
    case `break`
    case networking
}

public struct Agenda: Identifiable, Codable, DecodableWithConfiguration {
    public var id: String
    public var eventID: Event.ID
    public var time: Date
    public var title: String
    public var speakers: [String]?
    public var type: AgendaType
    
    public enum CodingKeys: CodingKey {
        case id
        case eventID
        case time
        case title
        case speakers
        case type
    }
    
    public init(time: Date, title: String, eventID: Event.ID, type: AgendaType) {
        self.id = StableID(using: title, time, eventID).id
        self.eventID = eventID
        self.time = time
        self.title = title
        self.type = type
    }
    
    public init(from decoder: any Decoder, configuration: String) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.eventID = decoder.userInfo[Self.eventIDUserInfoKey] as! Event.ID
        let timeString = try container.decode(String.self, forKey: .time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
        guard let time = dateFormatter.date(from: "\(configuration) \(timeString)") else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: [Agenda.CodingKeys.time],
                    debugDescription: "Invalid time format, it should be of \"hh:mm a\""
                )
            )
        }
        self.time = time
        self.title = try container.decode(String.self, forKey: .title)
        self.speakers = try container.decodeIfPresent([String].self, forKey: .speakers)
        self.type = try container.decode(AgendaType.self, forKey: .type)
        self.id = StableID(using: title, time, eventID).id
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.eventID, forKey: .eventID)
        try container.encode(self.time, forKey: .time)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.type, forKey: .type)
        //NOTE: Will not encode speakers array since we have AgendaSpeakerID to retrieve from
    }
}

extension Agenda {
    public static var eventIDUserInfoKey: CodingUserInfoKey {
        CodingUserInfoKey(rawValue: CodingKeys.eventID.stringValue)!
    }
}

public struct AgendaSpeakerID: Codable {
    public var id: String
    public var agendaID: Agenda.ID
    public var speakerID: Speaker.ID
    
    public init(agendaID: Agenda.ID, speakerID: Speaker.ID) {
        self.id = StableID(using: agendaID, speakerID).id
        self.agendaID = agendaID
        self.speakerID = speakerID
    }
}
