//
//  Event.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation

/// A model representing an event, such as a meetup, conference, or workshop.
///
/// The `Event` encapsulates core metadata:
/// - A stable `id` derived deterministically from the `title` and `date`.
/// - A human-readable `title`.
/// - The event `date`.
///
/// Conforms to:
/// - `Codable` for easy encoding/decoding to and from JSON or other formats.
/// - `Identifiable` for use in SwiftUI lists and other identity-aware collections.
/// - `CustomStringConvertible` to produce a Markdown-formatted description.
///
/// Initialization:
/// - Use `init(title:date:)` to create an event. The `id` is computed
///   using a stable hashing mechanism via `StableID(using:)`, ensuring consistent
///   identity across launches as long as the `title` and `date` remain the same.
///
/// Description format:
/// - The `description` renders a Markdown string including:
///   - A level-1 heading with the event title
///   - The `about` text on a new line, if provided
///   - A "Photos" link section on a new line, if `photos` is provided
///
/// Usage notes:
/// - Because the `id` is derived from `title` and `date`, changing either will produce
///   a new identity for the event.
public struct Event: Codable, Identifiable {
    public var id: String
    public var title: String
    public var date: Date
    
    public init(title: String, date: Date) {
        self.title = title
        self.date = date
        self.id = StableID(using: title, date).id
    }
}

extension Event: CustomStringConvertible {
    /// A Markdown-formatted representation of the event.
    ///
    /// Format:
    /// - A level-1 heading containing the event `title`.
    /// - If `about` is provided, it appears on the next line.
    /// - If `photos` is provided, a "Photos" link is appended on a new line in the form:
    ///   "##[Photos](<photos-URL>)".
    ///
    /// Example output:
    /// # Swift Community Meetup
    /// Learn about Swift Concurrency
    /// ##[Photos](https://example.com/album)
    ///
    /// - Note: Newlines are conditionally inserted only when the corresponding optional
    ///   values (`about`, `photos`) exist, ensuring a compact output when they are absent.
    public var description: String {
        """
        # \(title)
        """
    }
}

/// A composite model that groups an `Event` with its associated talks.
///
/// Purpose:
/// - Represents a single event and the collection of talks scheduled for it.
/// - Useful for rendering event pages, exporting to Markdown, or organizing data in lists.
///
/// Components:
/// - `event`: The core event metadata (title, date, description, photos).
/// - `talks`: The list of talks for the event, each enriched with speaker information.
///
/// Identity:
/// - Conforms to `Identifiable` by forwarding `id` from the underlying `event`.
///   This ensures stable identity derived from the event’s title and date.
///
/// Conformance:
/// - `Identifiable` for use in SwiftUI lists and other identity-aware collections.
/// - `CustomStringConvertible` (via extension) to produce a Markdown-formatted
///   description that includes the event followed by the talks.
///
/// Initialization:
/// - Initialize with `init(event:talks:)` to provide the base event and its talks.
///
/// Usage examples:
/// - Group event and talks for display in a single SwiftUI view.
/// - Encode to JSON for README file.
/// - Generate Markdown output for README-style summaries or event pages.
public struct EventWithTalks: Identifiable {
    public var event: Event
    public var talks: [TalkWithSpeakers]
    public var photoURL: URL?
    
    public var id: Event.ID { event.id }
    
    public init(event: Event, talks: [TalkWithSpeakers], photoURL: URL?) {
        self.event = event
        self.talks = talks
        self.photoURL = photoURL
    }
}

extension EventWithTalks: CustomStringConvertible {
    /// A Markdown-formatted representation of the event and its talks.
    ///
    /// Format:
    /// - Begins with the event’s Markdown description (`event.description`), which includes:
    ///   - A level-1 heading with the event title
    ///   - Optional about text
    ///   - An optional "Photos" link
    /// - Followed by the list of talks, each rendered using their own Markdown description,
    ///   joined by newline separators.
    ///
    /// Example output:
    /// # Swift Community Meetup
    /// Learn about Swift Concurrency
    /// ## Talk Title 1
    /// Speaker: Jane Doe
    ///
    /// ## Talk Title 2
    /// Speaker: John Smith
    /// ##[Event Photos](https://example.com/album)
    ///
    /// - Note: If there are no talks, only the event’s description is rendered.
    /// - Returns: A single Markdown string that concatenates the event’s description
    ///   and the talk descriptions separated by newlines.
    public var description: String {
        """
        \(event.description)
        \(talks.map { $0.description }.joined(separator: "\n") )
        \(photoURL.map {"[Event Photos](\($0))"}, default: "")
        """
    }
}
