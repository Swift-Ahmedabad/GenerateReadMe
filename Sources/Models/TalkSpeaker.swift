//
//  TalkSpeaker.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation

/// A linking model that associates a specific `Talk` with a `Speaker`.
/// 
/// This type represents the many-to-many relationship between talks and speakers,
/// allowing a talk to have multiple speakers and a speaker to participate in multiple talks.
/// It provides a stable, reproducible identifier derived from the combined `talkId` and `speakerID`,
/// ensuring consistent identity across runs and data sources.
///
/// - Note: The `id` is generated using a stable hashing strategy via `StableID`
///   to uniquely identify the talk–speaker pair.
///
/// Properties:
/// - `id`: A stable, unique identifier for the talk–speaker association.
/// - `talkId`: The identifier of the associated `Talk`.
/// - `speakerID`: The identifier of the associated `Speaker`.
///
/// Initializer:
/// - `init(talkId:speakerID:)`: Creates a new association between a talk and a speaker,
///   computing a stable `id` from the provided identifiers.
public struct TalkSpeaker: Codable, Identifiable {
    public var id: String
    public var talkID: Talk.ID
    public var speakerID: Speaker.ID
    
    public init(talkID: Talk.ID, speakerID: Speaker.ID) {
        self.id = StableID(using: talkID, speakerID).id
        self.talkID = talkID
        self.speakerID = speakerID
    }
}

/// A composite model that bundles a `Talk` with its associated `Speaker` records.
///
/// This type is useful when you need to present or process a talk together with all of
/// its speakers in a single, cohesive value (for example, when rendering detail pages,
/// exporting data, or generating README content).
///
/// Identity:
/// - Conforms to `Identifiable` by forwarding `id` to the underlying `talk.id`,
///   ensuring stable identity that matches the `Talk`.
///
/// Properties:
/// - `talk`: The primary `Talk` being described.
/// - `speakers`: The list of `Speaker` instances participating in the `talk`.
///
/// Initialization:
/// - `init(talk:speakers:)`: Creates a new instance from a given `Talk` and its `Speaker` array.
///
/// Usage:
/// - Group or display a talk alongside all of its speakers.
/// - Serialize/deserialize together via `Codable` for transport or persistence.
/// - Log or debug using `CustomStringConvertible` (see extension) to print a formatted summary.
public struct TalkWithSpeakers: Codable, Identifiable {
    public var talk: Talk
    public var speakers: [Speaker]
    
    public var id: Talk.ID { talk.id }
    
    public init(talk: Talk, speakers: [Speaker]) {
        self.talk = talk
        self.speakers = speakers
    }
}

extension TalkWithSpeakers: CustomStringConvertible {
    /// A multiline, human-readable summary of the talk and its speakers.
    /// 
    /// Format:
    /// - First line(s): The `Talk`'s own `description`.
    /// - Following lines: Each `Speaker`'s `description`, joined by newline characters.
    /// 
    /// Notes:
    /// - The output is intended for logging, debugging, or generating text content (e.g., README sections).
    /// - The order of speakers reflects the order in the `speakers` array.
    /// - If `speakers` is empty, only the talk's description is returned.
    public var description: String {
        """
        \(talk.description)
        \(speakers.map { $0.description }.joined(separator: "\n"))
        """
    }
}
