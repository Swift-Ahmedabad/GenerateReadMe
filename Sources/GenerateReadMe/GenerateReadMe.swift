import ArgumentParser
import Foundation
import Yams

@main
struct GenerateReadMe: ParsableCommand {
    @Argument
    var path: String
    
    var skipPaths: [String] = [".DS_Store", "README.md", "talks.json", ".scripts", "generate-readme.sh"]
    
    mutating func run() throws {
        let decoder = YAMLDecoder()
        
        let contents = try FileManager.default.contentsOfDirectory(atPath: path).sorted()
        let filtered = contents.filter { !skipPaths.contains($0) }
        
        var allEvents: [Event] = []
        
        for event in filtered {
            let subcontents = try FileManager.default.contentsOfDirectory(atPath: path.appending("/\(event)"))
            let talks = subcontents.filter { !skipPaths.contains($0) }
            
            var parsedTalks: [Talk] = []
            
            for talk in talks {
                let subcontents = try FileManager.default.contentsOfDirectory(atPath: path.appending("/\(event)/\(talk)"))
                let items = subcontents.filter { !skipPaths.contains($0) }
                
                if let speaker = items.first(where: { $0.contains("Speaker") }) {
                    if let contentsData = FileManager.default.contents(atPath: path.appending("/\(event)/\(talk)/\(speaker)")) {
                        let speakers = try decoder.decode(Speakers.self, from: contentsData)
                        let parsedTalk = Talk(title: talk, speakers: speakers)
                        parsedTalks.append(parsedTalk)
                    }
                }
            }
            
            let parsedEvent = Event(title: event, talks: parsedTalks)
            allEvents.append(parsedEvent)
        }
        
        let destinationPath = self.path.appending("/README.md")
        let destinationContent = allEvents.sorted(by: {$0.title > $1.title}).map { $0.description }.joined(separator: "\n").data(using: .utf8)
        if !FileManager.default.fileExists(atPath: destinationPath) {
            FileManager.default.createFile(atPath: destinationPath, contents: nil)
        }
        try destinationContent?.write(to: URL(fileURLWithPath: destinationPath))
        
        let jsonDestinationPath = self.path.appending("/talks.json")
        let jsonEncoder = JSONEncoder()
        let encoded = try jsonEncoder.encode(allEvents)
        try encoded.write(to: URL(fileURLWithPath: jsonDestinationPath))
    }
}
