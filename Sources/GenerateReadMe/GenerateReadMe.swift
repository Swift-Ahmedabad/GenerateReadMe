import ArgumentParser
import Foundation
import Yams

@main
struct GenerateReadMe: ParsableCommand {
    @Argument
    var path: String
    
    var skipFileWithExtensions: [String] = [
        "md",
        "json",
        "sh"
    ]
    var readMeFileName: String = "README.md"
    var jsonFileName: String = "talks.json"
    
    mutating func run() throws {
        let allEvents: [Event] = try GenerateReadMeCommand.events(
            from: path,
            skipFileWithExtensions: skipFileWithExtensions
        )
        .sorted(by: {$0.title > $1.title })
        
        try GenerateReadMeCommand.generateReadMe(for: allEvents, at: URL(filePath: path).appending(path: readMeFileName))
        
        try GenerateReadMeCommand.generateJson(for: allEvents, at: URL(filePath: path).appending(path: jsonFileName))
    }
}

enum GenerateReadMeCommand {
    enum GeneratorError: LocalizedError {
        case noSpeakerFile
    }
    
    static func events(from path: String, skipFileWithExtensions: [String]) throws -> [Event] {
        let decoder = YAMLDecoder()
        var allEvents: [Event] = []
        
        for eventURL in try validContentsOfDirectory(at: URL(filePath: path), skipping: skipFileWithExtensions) {
            debugPrint(eventURL.lastPathComponent)
            var parsedTalks: [Talk] = []
            
            for talkURL in try validContentsOfDirectory(at: eventURL, skipping: skipFileWithExtensions) {
                debugPrint("\t", talkURL.lastPathComponent)
                
                for talkContentURL in try validContentsOfDirectory(at: talkURL, skipping: skipFileWithExtensions) {
                    debugPrint("\t\t", talkContentURL.lastPathComponent)
                    if talkContentURL.lastPathComponent.contains("Speaker") {
                        if let contentData = FileManager.default.contents(atPath: talkContentURL.path(percentEncoded: false)) {
                            let speakers = try decoder.decode([Speaker].self, from: contentData)
                            let parsedTalk = Talk(title: talkURL.lastPathComponent, speakers: speakers)
                            parsedTalks.append(parsedTalk)
                        } else {
                            throw GeneratorError.noSpeakerFile
                        }
                    }
                }
                
            }
            
            let parsedEvent = Event(title: eventURL.lastPathComponent, talks: parsedTalks)
            allEvents.append(parsedEvent)
        }
        
        return allEvents
    }
    
    static func validContentsOfDirectory(at url: URL, skipping skipFilesWithExtensions: [String]) throws -> [URL] {
        let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return contents.filter({ !skipFilesWithExtensions.contains($0.pathExtension) })
    }
    
    static func generateReadMe(for events: [Event], at path: URL) throws {
        if FileManager.default.fileExists(atPath: path.path(percentEncoded: false)) {
            try FileManager.default.removeItem(at: path)
        }
        let content = events.map { $0.description }.joined(separator: "\n")
        try content.write(to: path, atomically: true, encoding: .utf8)
    }
    
    static func generateJson(for events: [Event], at path: URL) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(events)
        try data.write(to: path)
    }
}
