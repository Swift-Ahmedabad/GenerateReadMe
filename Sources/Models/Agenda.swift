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
    
    public enum CodingKeys: CodingKey {
        case id
        case eventID
        case time
        case title
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
        self.id = StableID(using: title, time, eventID).id
    }
}
