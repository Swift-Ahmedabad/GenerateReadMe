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
        let allEvents: [Event] = try GenerateReadMeCommand.events(from: path, skipFileWithExtensions: skipFileWithExtensions)
        
        let destinationPath = self.path.appending("/\(readMeFileName)")
        let destinationContent = allEvents.sorted(by: {$0.title > $1.title}).map { $0.description }.joined(separator: "\n")
        if !FileManager.default.fileExists(atPath: destinationPath) {
            FileManager.default.createFile(atPath: destinationPath, contents: nil)
        }
        try destinationContent.data(using: .utf8)?.write(to: URL(fileURLWithPath: destinationPath))
        
        let jsonDestinationPath = self.path.appending("/\(jsonFileName)")
        let jsonEncoder = JSONEncoder()
        let encoded = try jsonEncoder.encode(allEvents)
        try encoded.write(to: URL(fileURLWithPath: jsonDestinationPath))
    }
}

enum GenerateReadMeCommand {
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
                            debugPrint("Can not get the speakers from: \(talkContentURL.path)")
                        }
                    }
                }
                
                let parsedEvent = Event(title: eventURL.lastPathComponent, talks: parsedTalks)
                allEvents.append(parsedEvent)
            }
        }
        
        return allEvents
    }
    
    static func validContentsOfDirectory(at url: URL, skipping skipFilesWithExtensions: [String]) throws -> [URL] {
        let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return contents.filter({ !skipFilesWithExtensions.contains($0.pathExtension) })
    }
}
