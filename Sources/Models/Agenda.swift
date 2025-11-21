//
//  Agenda.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 19/11/25.
//

import Foundation

public struct Agenda: Identifiable, Codable {
    public var id: String
    public var eventID: Event.ID
    public var time: Date
    public var title: String
    public var speakers: [String]?
    
    public enum CodingKeys: CodingKey {
        case id
        case eventID
        case time
        case title
        case speakers
    }
    
    public init(time: Date, title: String, eventID: Event.ID) {
        self.id = StableID(using: title, time, eventID).id
        self.eventID = eventID
        self.time = time
        self.title = title
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.eventID = decoder.userInfo[CodingUserInfoKey(rawValue: CodingKeys.eventID.stringValue)!] as! Event.ID
        let timeString = try container.decode(String.self, forKey: .time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        guard let time = dateFormatter.date(from: timeString) else {
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
        self.id = StableID(using: title, time, eventID).id
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.eventID, forKey: .eventID)
        try container.encode(self.time, forKey: .time)
        try container.encode(self.title, forKey: .title)
        //NOTE: Will not encode speakers array since we have AgendaSpeakerID to retrieve from
    }
}

public struct AgendaSpeakerID: Codable {
    public var agendaID: Agenda.ID
    public var speakerID: Speaker.ID
    
    public init(agendaID: Agenda.ID, speakerID: Speaker.ID) {
        self.agendaID = agendaID
        self.speakerID = speakerID
    }
}
