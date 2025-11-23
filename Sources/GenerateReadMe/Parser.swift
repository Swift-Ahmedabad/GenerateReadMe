//
//  Parser.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation
import Models
import Yams

/// A namespace encapsulating functionality for parsing event-related content from a file system structure.
/// 
/// Parser is responsible for traversing a directory hierarchy, decoding YAML-based data into strongly typed
/// models, and aggregating them into a cohesive set of domain objects. It supports discovery of events,
/// talks, speakers, and the relationships between them, producing an `EventsInfo` value that can be used to
/// generate artifacts such as a README.
///
/// Error types produced by this parser.
/// - GeneratorError.noSpeakerFile: Indicates that a talk directory is missing a required speaker file.
///
/// A container aggregating all parsed models and their relationships:
/// - events: All discovered Event values.
/// - eventsWithTalks: Event values paired with their associated talks.
/// - speakers: All discovered Speaker values across all events.
/// - talksWithSpeakers: Talk values paired with their associated speakers.
/// - talks: All discovered Talk values.
/// - talkSpeakers: Relationship entities linking talks to speakers.
///
/// Parse events and related data from a directory path.
/// - Parameters:
///   - path: The root directory path containing event folders. Each event folder name is expected to contain a date that can be parsed via `String.date`.
///   - skipFileWithExtensions: File extensions that should be ignored during traversal (e.g., ["md", "png"]).
/// - Returns: An `EventsInfo` object containing all parsed entities and relationships.
/// - Throws:
///   - `GeneratorError.noSpeakerFile` if a talk directory does not contain a speaker file.
///   - Errors thrown by `FileManager` while enumerating directories.
///   - Errors thrown by `YAMLDecoder` while decoding YAML content.
///
/// - Discussion:
///   The expected directory layout is:
///     ```
///     path/EventFolderIndex-with-date/TalkFolderName/Speaker.yml
///     ```
///   For each event folder, the folder name is parsed into a date. Within each talk folder, any file whose
///   name contains "Speaker" is treated as a YAML list of Speaker objects. A Talk is created per talk folder,
///   and TalkSpeaker relationships are created to link talks and speakers.
///
/// List valid (non-hidden) contents of a directory, skipping files with specified extensions.
/// - Parameters:
///   - url: The directory URL to enumerate.
///   - skipFilesWithExtensions: A list of file extensions that will be filtered out (case-sensitive match).
/// - Returns: An array of URLs representing directory contents that are not hidden and do not have a skipped extension.
/// - Throws: Errors thrown by FileManager when reading directory contents.
/// - Note: Hidden files are skipped using `.skipsHiddenFiles`.
enum Parser {
    enum GeneratorError: LocalizedError {
        case noSpeakerFile
    }
    
    struct EventsInfo {
        var events: [Event] = []
        var eventsWithTalks: [EventWithTalks] = []
        var speakers: [Speaker] = []
        var talksWithSpeakers: [TalkWithSpeakers] = []
        var talks: [Talk] = []
        var talkSpeakers: [TalkSpeaker] = []
        var eventInfos: [EventInfo] = []
        var agendas: [Agenda] = []
        var sponsors: [Sponsors] = []
        var agendaSpeakerIDs: [AgendaSpeakerID] = []
    }
    
    static func events(from path: String, skipFileWithExtensions: [String] = .defaultSkippingExtensions) throws -> EventsInfo {
        let decoder = YAMLDecoder()
        var info = EventsInfo()
        
        for eventURL in try validContentsOfDirectory(at: URL(filePath: path), skipping: skipFileWithExtensions) {
            debugPrint(eventURL.lastPathComponent)
            guard let date = eventURL.lastPathComponent.date else { continue }
            var parsedTalks: [TalkWithSpeakers] = []
            var parsedEvent = Event(title: eventURL.lastPathComponent, date: date)
            var parsedEventInfo: EventInfo?
            
            let infoYMLURL = eventURL.appending(path: "Info.yml")
            if let infoContent = FileManager.default.contents(atPath: infoYMLURL.path(percentEncoded: false)) {
                let eventInfo = try decoder.decode(EventInfoWithAgendas.self, from: infoContent, userInfo: [Models.EventInfo.eventIDUserInfoKey : parsedEvent.id])
                parsedEventInfo = eventInfo.eventInfo
                parsedEvent.date = eventInfo.eventInfo.date
                info.eventInfos.append(eventInfo.eventInfo)
                info.agendas.append(contentsOf: eventInfo.agenda)
                info.sponsors.append(eventInfo.eventInfo.sponsors)
            }
            
            for talkURL in try validContentsOfDirectory(at: eventURL, skipping: skipFileWithExtensions, additionalSkipFileNames: ["Info.yml"]) {
                debugPrint("\t", talkURL.lastPathComponent)
                
                for talkContentURL in try validContentsOfDirectory(at: talkURL, skipping: skipFileWithExtensions) {
                    debugPrint("\t\t", talkContentURL.lastPathComponent)
                    if talkContentURL.lastPathComponent.contains("Speaker") {
                        if let contentData = FileManager.default.contents(atPath: talkContentURL.path(percentEncoded: false)) {
                            let decodedSpeakers = try decoder.decode([Speaker].self, from: contentData)
                            info.speakers.append(contentsOf: decodedSpeakers)
                            
                            let parsedTalk = Talk(title: talkURL.lastPathComponent, eventID: parsedEvent.id)
                            info.talks.append(parsedTalk)
                            
                            let talkWithSpeakers = TalkWithSpeakers(talk: parsedTalk, speakers: decodedSpeakers)
                            info.talksWithSpeakers.append(talkWithSpeakers)
                            parsedTalks.append(talkWithSpeakers)
                            
                            for speaker in decodedSpeakers {
                                let talkSpeaker = TalkSpeaker(talkID: parsedTalk.id, speakerID: speaker.id)
                                info.talkSpeakers.append(talkSpeaker)
                            }
                        } else {
                            throw GeneratorError.noSpeakerFile
                        }
                    }
                }
                
            }
            
            let eventWithTalks = EventWithTalks(event: parsedEvent, talks: parsedTalks, eventInfo: parsedEventInfo)
            info.agendaSpeakerIDs.append(contentsOf: agendaSpeakerIDs(from: info.agendas, speakers: info.speakers))
            
            info.eventsWithTalks.append(eventWithTalks)
            info.events.append(parsedEvent)
        }
        
        return info
    }
    
    /// Lists the non-hidden contents of a directory, optionally skipping files by extension.
    /// 
    /// This helper wraps FileManager’s contentsOfDirectory API to:
    /// - Exclude hidden files and directories (using the `.skipsHiddenFiles` option).
    /// - Filter out any URLs whose path extension matches one of the provided extensions.
    /// 
    /// - Parameters:
    ///   - url: The directory URL whose contents should be enumerated.
    ///   - skipFilesWithExtensions: A list of file extensions to exclude from the results
    ///     (case-sensitive match, without leading dots; e.g., ["md", "png"]).
    /// 
    /// - Returns: An array of URLs representing the visible directory contents after filtering.
    /// 
    /// - Throws: An error if the directory cannot be read (propagated from FileManager).
    /// 
    /// - Note:
    ///   - The filter checks `URL.pathExtension` directly and compares it against the provided list.
    ///   - Hidden files are skipped via `.skipsHiddenFiles`; package-private or OS metadata entries will not be included.
    ///   - The order of returned URLs is the same as provided by FileManager and is not guaranteed to be sorted.
    static func validContentsOfDirectory(at url: URL, skipping skipFilesWithExtensions: [String], additionalSkipFileNames: [String] = []) throws -> [URL] {
        let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return contents.filter({ !skipFilesWithExtensions.contains($0.pathExtension) }).filter { !additionalSkipFileNames.contains($0.lastPathComponent) }
    }
    
    static private func agendaSpeakerIDs(from agendas: [Agenda], speakers: [Speaker]) -> [AgendaSpeakerID] {
        let agendaSpeakers = agendas.map { ($0.speakers, $0.id) }.reduce(into: [(String, String)]()) { partialResult, next in
            for item in (next.0 ?? []) {
                partialResult.append((item, next.1))
            }
        }
        let result = agendaSpeakers.compactMap { speakerName, agendaID in
            let speakerIDs: [String] = speakers.compactMap ({ speaker in
                if speakerName == speaker.name {
                    return speaker.id
                } else {
                    return nil
                }
            })
            return speakerIDs.map { AgendaSpeakerID(agendaID: agendaID, speakerID: $0)}
        }
        return result.flatMap({$0})
    }
}
