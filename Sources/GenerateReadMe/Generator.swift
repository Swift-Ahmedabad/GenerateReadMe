//
//  Generator.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation
import Models

/// A utility namespace responsible for generating output artifacts for the project,
/// such as a README file and JSON files.
///
/// The `Generator` provides two main operations:
/// - Creating a README by aggregating formatted descriptions of events and their talks.
/// - Serializing arbitrary `Encodable` models to JSON and writing them to disk.
///
/// All functions are synchronous and throw on I/O or encoding failures.

/// Generates a README-style text file for a collection of events.
///
/// This function:
/// - Removes any existing file at the destination URL to ensure a clean write.
/// - Transforms each `EventWithTalks` into its textual `description`.
/// - Joins the descriptions with a single newline separator.
/// - Writes the resulting UTF‑8 text to disk.
///
/// - Parameters:
///   - events: The list of events (with their talks) to be rendered into the README.
///   - path: The file URL where the README should be written.
/// - Throws: An error if the file removal, content encoding, or file write operation fails.
/// - Important: The file at `path` will be removed if it already exists.
///
/// Generates a JSON file for any `Encodable` value.
///
/// - Parameters:
///   - item: The encodable value to serialize as JSON.
///   - path: The destination file URL for the JSON output.
///   - encoder: The `JSONEncoder` to use. Defaults to `JSONEncoder()`.
/// - Throws: An error if encoding fails or if writing the data to disk fails.
/// - Note: This function does not pretty‑print unless the provided encoder is configured to do so.
enum Generator {
    static func generateReadMe(for events: [EventWithTalks], at path: URL) throws {
        if FileManager.default.fileExists(atPath: path.path(percentEncoded: false)) {
            try FileManager.default.removeItem(at: path)
        }
        let content = events.map { $0.description }.joined(separator: "\n")
        try content.write(to: path, atomically: true, encoding: .utf8)
    }
    
    static func generateJson<T: Encodable>(for item: T, at path: URL, encoder: JSONEncoder = JSONEncoder()) throws {
        let data = try encoder.encode(item)
        try data.write(to: path)
    }
}
