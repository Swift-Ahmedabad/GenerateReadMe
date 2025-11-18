import ArgumentParser
import Foundation
import Models

/// A command-line utility that parses a directory of talk-related files and generates a README along with JSON exports.
///
/// This tool scans a given path for event, speaker, and talk information, skipping specified file extensions,
/// and produces:
/// - A README.md (or custom filename) summarizing events and talks.
/// - JSON files for events, speakers, talks, and talk-speaker relationships.
///
/// Usage:
/// - Provide the path to the talks directory.
/// - Optionally customize filenames and skipped file extensions via options.
///
/// Arguments:
/// - `path`: The filesystem path to the directory containing talk data to parse.
///
/// Options:
/// - `skipFileWithExtensions`: File extensions to ignore during parsing. Defaults to ["md", "json", "sh"].
/// - `readMeFileName`: Output filename for the generated README. Default: "README.md".
/// - `eventsjsonFileName`: Output filename for the events JSON. Default: "events.json".
/// - `speakersJsonFileName`: Output filename for the speakers JSON. Default: "speakers.json".
/// - `talksJsonFileName`: Output filename for the talks JSON. Default: "talks.json".
/// - `talkSpeakersFileName`: Output filename for the talk-speaker relationships JSON. Default: "talkspeakers.json".
///
/// Behavior:
/// - Parses events using `Parser.events(from:skipFileWithExtensions:)`.
/// - Sorts events by date before generating the README using `Generator.generateReadMe(for:at:)`.
/// - Writes JSON files for events, speakers, talks, and talk-speaker mappings using `Generator.generateJson(for:at:)`.
///
/// Throws:
/// - Rethrows any parsing or file I/O errors encountered during generation.
///
/// Notes:
/// - The command relies on the `Models` module for domain types and the `Parser`/`Generator` utilities for processing.
/// - Paths are resolved relative to the provided `path` argument using `URL(filePath:)`.
@main
struct GenerateReadMe: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "GenerateReadMe")
    }
    
    @Argument(help: "Path of the Talks Directory")
    var path: String
    
    @Option(help: "file extension that needs to skip parsing. Default: md, json, sh")
    var skipFileWithExtensions: [String] = [
        "md",
        "json",
        "sh"
    ]
    
    @Option(help: "Name of the Read me file. Default: README.md")
    var readMeFileName: String = "README.md"
    
    @Option(help: "Name of the events json file. Default: events.json")
    var eventsjsonFileName: String = "events.json"
    
    @Option(help: "Name of the speakers json file. Default: speakers.json")
    var speakersJsonFileName: String = "speakers.json"
    
    @Option(help: "Name of the talks json file. Default: talks.json")
    var talksJsonFileName: String = "talks.json"
    
    @Option(help: "Name of the talkspeakers json file. default: talkspeakers.json")
    var talkSpeakersFileName: String = "talkspeakers.json"
    
    mutating func run() throws {
        let allEvents = try Parser.events(
            from: path,
            skipFileWithExtensions: skipFileWithExtensions
        )
        
        try Generator.generateReadMe(for: allEvents.eventsWithTalks.sorted(by: {$0.event.date < $1.event.date}), at: URL(filePath: path).appending(path: readMeFileName))
        
        let pathURL = URL(filePath: path)
        
        try Generator.generateJson(for: allEvents.events, at: pathURL.appending(path: eventsjsonFileName))
        try Generator.generateJson(for: allEvents.speakers, at: pathURL.appending(path: speakersJsonFileName))
        try Generator.generateJson(for: allEvents.talks, at: pathURL.appending(path: talksJsonFileName))
        try Generator.generateJson(for: allEvents.talkSpeakers, at: pathURL.appending(path: talkSpeakersFileName))
    }
}
