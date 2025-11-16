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
        ).0
        .sorted(by: {$0.title > $1.title })
        
        try GenerateReadMeCommand.generateReadMe(for: allEvents, at: URL(filePath: path).appending(path: readMeFileName))
        
        try GenerateReadMeCommand.generateJson(for: allEvents, at: URL(filePath: path).appending(path: jsonFileName))
    }
}

enum GenerateReadMeCommand {
    enum GeneratorError: LocalizedError {
        case noSpeakerFile
    }
    
    static func events(from path: String, skipFileWithExtensions: [String]) throws -> ([Event], Set<Speaker>) {
        let decoder = YAMLDecoder()
        var allEvents: [Event] = []
        var speakers: Set<Speaker> = []
        
        for eventURL in try validContentsOfDirectory(at: URL(filePath: path), skipping: skipFileWithExtensions) {
            debugPrint(eventURL.lastPathComponent)
            guard let date = eventURL.lastPathComponent.date else { continue }
            var parsedTalks: [Talk] = []
            
            for talkURL in try validContentsOfDirectory(at: eventURL, skipping: skipFileWithExtensions) {
                debugPrint("\t", talkURL.lastPathComponent)
                
                for talkContentURL in try validContentsOfDirectory(at: talkURL, skipping: skipFileWithExtensions) {
                    debugPrint("\t\t", talkContentURL.lastPathComponent)
                    if talkContentURL.lastPathComponent.contains("Speaker") {
                        if let contentData = FileManager.default.contents(atPath: talkContentURL.path(percentEncoded: false)) {
                            let decodedSpeakers = try decoder.decode([Speaker].self, from: contentData)
                            let parsedTalk = Talk(title: talkURL.lastPathComponent, speakers: decodedSpeakers)
                            parsedTalks.append(parsedTalk)
                            speakers.insert(contentsOf: decodedSpeakers)
                        } else {
                            throw GeneratorError.noSpeakerFile
                        }
                    }
                }
                
            }
            
            let parsedEvent = Event(title: eventURL.lastPathComponent, date: date, talks: parsedTalks)
            allEvents.append(parsedEvent)
        }
        
        return (allEvents, speakers)
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

enum Formatter {
    static let dateFormatter = DateFormatter()
}

extension String {
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

extension Set {
    mutating func insert(contentsOf elements: Array<Element>) {
        for element in elements {
            self.insert(element)
        }
    }
}
