//
//  Talk.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation

/// Creates a new `Talk`.
///
/// - Parameters:
///   - title: The human‑readable title of the talk.
///   - eventID: The identifier of the event that hosts this talk.
/// - Note: The `id` is deterministically generated from `title` and `eventID`
///   using `StableID`, providing a consistent, stable identifier.
public struct Talk: Codable, Hashable, Identifiable {
    public var id: String
    public var title: String
    public var eventID: Event.ID
    
    public init(title: String, eventID: Event.ID) {
        self.title = title
        self.eventID = eventID
        self.id = StableID(using: title, eventID).id
    }
}

extension Talk: CustomStringConvertible {
    /// A Markdown-formatted textual representation of the talk.
    ///
    /// This implementation returns a level‑2 Markdown heading containing the talk’s title.
    /// It can be used when generating README files or other Markdown documents to
    /// display the talk prominently.
    ///
    /// Example output:
    /// ## Building Fast and Stable Apps
    ///
    /// - Returns: A `String` with the talk’s title formatted as a Markdown H2 heading.
    public var description: String {
        """
        ## \(title.description)
        """
    }
}
