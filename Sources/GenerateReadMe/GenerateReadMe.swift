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
/// - `eventInfosFileName`: Output filename for the eventInfos JSON. Default: "eventInfos.json".
/// - `sponsorsFileName`: Output filename for the sponsors JSON. Default: "sponsors.json".
/// - `agendasFileName`: Output filename for the agendas JSON. Default: "agendas.json".
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
    var skipFileWithExtensions: [String] = .defaultSkippingExtensions
    
    @Option(help: "Name of the Read me file. Default: README.md")
    var readMeFileName: String = "README.md"
    
    @Option(help: "Name of the events json file. Default: events.json")
    var eventsjsonFileName: String = "events.json"
    
    @Option(help: "Name of the speakers json file. Default: speakers.json")
    var speakersJsonFileName: String = "speakers.json"
    
    @Option(help: "Name of the talks json file. Default: talks.json")
    var talksJsonFileName: String = "talks.json"
    
    @Option(help: "Name of the talkspeakers json file. Default: talkspeakers.json")
    var talkSpeakersFileName: String = "talkspeakers.json"
    
    @Option(help: "Name of the eventInfos json file. Default: eventInfos.json")
    var eventInfosFileName: String = "eventInfos.json"
    
    @Option(help: "Name of the sponsors json file. Default: sponsors.json")
    var sponsorsFileName: String = "sponsors.json"
    
    @Option(help: "Name of the agendas json file, Default: agandas.json")
    var agendasFileName: String = "agandas.json"
    
    @Option(help: "Name of the agenda speaker id json file. Default: agendaSpeakerIDs.json")
    var agendaSpeakerIDsFileName: String = "agendaSpeakerIDs.json"
    
    @Option(help: "Name of the about file. Default: about.json")
    var aboutFileName: String = "about.json"
    
    @Option(help: "Name of the last updated at file for auto refresh. Default: lastUpdatedAt.json")
    var lastUpdatedAtFileName: String = "lastUpdatedAt.json"
    
    @Option(help: "Name of news source file. Default: newsSource.json")
    var newsSourceFileName: String = "newsSource.json"
    
    @Option(help: "Name of year in review file. Default: yearsInReview.json")
    var yearsInReviewFileName: String = "yearsInReview.json"
    
    func run() throws {
        let allEvents = try Parser.events(
            from: path,
            skipFileWithExtensions: skipFileWithExtensions
        )
        
        try Generator.generateReadMe(for: allEvents.eventsWithTalks.sorted(by: {$0.event.date > $1.event.date}), at: URL(filePath: path).appending(path: readMeFileName))
        
        let pathURL = URL(filePath: path).appending(path: ".generated")
        try? FileManager.default.createDirectory(at: pathURL, withIntermediateDirectories: true)
        
        try Generator.generateJson(for: allEvents.events, at: pathURL.appending(path: eventsjsonFileName))
        try Generator.generateJson(for: allEvents.speakers, at: pathURL.appending(path: speakersJsonFileName))
        try Generator.generateJson(for: allEvents.talks, at: pathURL.appending(path: talksJsonFileName))
        try Generator.generateJson(for: allEvents.talkSpeakers, at: pathURL.appending(path: talkSpeakersFileName))
        try Generator.generateJson(for: allEvents.eventInfos, at: pathURL.appending(path: eventInfosFileName))
        try Generator.generateJson(for: allEvents.sponsors, at: pathURL.appending(path: sponsorsFileName))
        try Generator.generateJson(for: allEvents.agendas, at: pathURL.appending(path: agendasFileName))
        try Generator.generateJson(for: allEvents.agendaSpeakerIDs, at: pathURL.appending(path: agendaSpeakerIDsFileName))
        if let about = allEvents.about {
            try Generator.generateJson(for: about, at: pathURL.appending(path: aboutFileName))
        }
        try Generator.generateJson(for: allEvents.newsSources, at: pathURL.appending(path: newsSourceFileName))
        try Generator.generateJson(for: UpdatedAt(), at: pathURL.appending(path: lastUpdatedAtFileName))
        try Generator.generateJson(for: allEvents.yearsInReview, at: pathURL.appending(path: yearsInReviewFileName))
    }
}

extension [String] {
    static var defaultSkippingExtensions: [String] {
        [
            "md",
            "json",
            "sh"
        ]
    }
}
