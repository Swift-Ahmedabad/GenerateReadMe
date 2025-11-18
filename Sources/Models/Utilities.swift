//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation

/// A namespace for reusable `Foundation` formatters used across the project.
///
/// The `Formatter` enum provides shared, lazily-initialized formatter instances
/// to avoid the overhead of repeatedly creating and configuring formatters,
/// which can be relatively expensive. Centralizing formatters also ensures
/// consistent formatting behavior throughout the codebase.
///
/// - Note: Formatters are not inherently thread-safe. If you plan to access
///   these shared instances from multiple threads concurrently, consider
///   adding synchronization or using per-thread instances as needed.
public enum Formatter {
    public static let dateFormatter = DateFormatter()
}

/// A namespace for shared encoder/decoder utilities used across the project.
///
/// The `Coder` enum centralizes reusable instances of encoding/decoding tools
/// to promote consistency and avoid the overhead of repeatedly creating them.
/// Keeping these in one place also makes it easy to apply common configuration
/// (such as date strategies or key encoding strategies) in a single location.
///
/// - Important: Foundation’s coders (e.g., `JSONEncoder`/`JSONDecoder`) are not
///   inherently thread-safe when mutated. If you customize the shared instances,
///   avoid concurrent mutation or provide synchronization. Alternatively, prefer
///   per-call instances when using different configurations.
///
/// - Usage:
///   - Use `Coder.jsonEncoder` to encode Swift types to JSON with a shared encoder.
///   - Consider extending `Coder` with additional encoders/decoders or
///     preconfigured strategies as your project’s needs grow.
public enum Coder {
    public static let jsonEncoder = JSONEncoder()
}

extension String {
    /// Parses a date from the string by extracting the substring after the last ". "
    /// and interpreting it with the "MMM dd, yyyy" format (e.g., "Nov 18, 2025").
    /// - Returns: A `Date` if the substring can be parsed using the expected format; otherwise, `nil`.
    public var date: Date? {
        if let last = self.split(separator: ". ").last {
            let dateString = String(last)
            let formatter = Formatter.dateFormatter
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter.date(from: dateString)
        }
        return nil
    }
}
