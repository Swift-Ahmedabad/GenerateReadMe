//
//  Test.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 11/11/25.
//

import Foundation
@testable import GenerateReadMe
import InlineSnapshotTesting
@preconcurrency import SnapshotTesting
import SnapshotTestingCustomDump
import Testing

@Suite(.snapshots(record: .failed))
struct GenerateReadMeTests {
    
    @Test
    func generateReadMe() throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        let fileURL = testURL.appending(path: "Events")
        let event1URL = fileURL.appending(path: "1. Apr 20 2025/Talk1")
        try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
        let speakerYML =
        """
        - Speaker: Johny Appleseed
          Socials:
            LinkedIn: https://www.linkedin.com/in/johny-appleseed-0a0123456/
            Github: https://github.com/johny-appleseed
            Portfolio: https://johny-appleseed.github.io
          About: Apple Engineer
        """
        let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
        try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
        
        try withSnapshotTesting(record: .failed) {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false)).eventsWithTalks
            let readMeURL = fileURL.appending(path: "README.md")
            try Generator.generateReadMe(for: events, at: readMeURL)
            assertInlineSnapshot(of: readMeURL, as: .urlContent) {
                """
                # 1. Apr 20 2025
                ## Talk1
                ### By: **Johny Appleseed**
                Apple Engineer

                Follow on: [LinkedIn](https://www.linkedin.com/in/johny-appleseed-0a0123456/), [Github](https://github.com/johny-appleseed), [Portfolio](https://johny-appleseed.github.io)

                """
            }
        }
    }
    
    @Test
    func generateReadMeForMultipleSpeakers() throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }

        let fileURL = testURL.appending(path: "Events")
        let event1URL = fileURL.appending(path: "10. Dec 31 2025/Talk1")
        try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
        let speakerYML =
        """
        - Speaker: Johny Appleseed
          Socials:
            LinkedIn: https://www.linkedin.com/in/johny-appleseed-0a0123456/
            Github: https://github.com/johny-appleseed
            Portfolio: https://johny-appleseed.github.io
          About: Apple Engineer
        - Speaker: Linus Torvalds
          Socials:
            LinkedIn: https://www.linkedin.com/in/linus-torvalds-0a0123456/
          About: Git Inventor
        """
        let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
        try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
                
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false)).eventsWithTalks
            let readMeURL = fileURL.appending(path: "README.md")
            try Generator.generateReadMe(for: events, at: readMeURL)
            assertInlineSnapshot(of: readMeURL, as: .urlContent) {
                """
                # 10. Dec 31 2025
                ## Talk1
                ### By: **Johny Appleseed**
                Apple Engineer

                Follow on: [LinkedIn](https://www.linkedin.com/in/johny-appleseed-0a0123456/), [Github](https://github.com/johny-appleseed), [Portfolio](https://johny-appleseed.github.io)
                ### By: **Linus Torvalds**
                Git Inventor

                Follow on: [LinkedIn](https://www.linkedin.com/in/linus-torvalds-0a0123456/)

                """
            }
        }
    }
    
    @Test
    func generateReadMeForMultipleEvents() throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }

        let fileURL = testURL.appending(path: "Events")
        for e in 1...3 {
            for t in 1...3 {
                let event1URL = fileURL.appending(path: "\(e). Oct \(e) 2025/Talk\(t)")
                try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
                let speakerYML =
                """
                - Speaker: Event\(e) Speaker \(t)
                  Socials:
                    LinkedIn: https://www.linkedin.com/in/speaker-0a012345\(t)/
                    Github: https://github.com/speaker\(t)
                    Portfolio: https://speaker-\(t).github.io
                  About: Talented Speaker-\(t)
                """
                let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
                try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
            }
        }
        
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false)).eventsWithTalks
            let readMeURL = fileURL.appending(path: "README.md")
            try Generator.generateReadMe(for: events, at: readMeURL)
            assertInlineSnapshot(of: readMeURL, as: .urlContent) {
                """
                # 2. Oct 2 2025
                ## Talk1
                ### By: **Event2 Speaker 1**
                Talented Speaker-1

                Follow on: [LinkedIn](https://www.linkedin.com/in/speaker-0a0123451/), [Github](https://github.com/speaker1), [Portfolio](https://speaker-1.github.io)
                ## Talk2
                ### By: **Event2 Speaker 2**
                Talented Speaker-2

                Follow on: [LinkedIn](https://www.linkedin.com/in/speaker-0a0123452/), [Github](https://github.com/speaker2), [Portfolio](https://speaker-2.github.io)
                ## Talk3
                ### By: **Event2 Speaker 3**
                Talented Speaker-3

                Follow on: [LinkedIn](https://www.linkedin.com/in/speaker-0a0123453/), [Github](https://github.com/speaker3), [Portfolio](https://speaker-3.github.io)

                # 1. Oct 1 2025
                ## Talk1
                ### By: **Event1 Speaker 1**
                Talented Speaker-1

                Follow on: [LinkedIn](https://www.linkedin.com/in/speaker-0a0123451/), [Github](https://github.com/speaker1), [Portfolio](https://speaker-1.github.io)
                ## Talk2
                ### By: **Event1 Speaker 2**
                Talented Speaker-2

                Follow on: [LinkedIn](https://www.linkedin.com/in/speaker-0a0123452/), [Github](https://github.com/speaker2), [Portfolio](https://speaker-2.github.io)
                ## Talk3
                ### By: **Event1 Speaker 3**
                Talented Speaker-3

                Follow on: [LinkedIn](https://www.linkedin.com/in/speaker-0a0123453/), [Github](https://github.com/speaker3), [Portfolio](https://speaker-3.github.io)

                # 3. Oct 3 2025
                ## Talk1
                ### By: **Event3 Speaker 1**
                Talented Speaker-1

                Follow on: [LinkedIn](https://www.linkedin.com/in/speaker-0a0123451/), [Github](https://github.com/speaker1), [Portfolio](https://speaker-1.github.io)
                ## Talk2
                ### By: **Event3 Speaker 2**
                Talented Speaker-2

                Follow on: [LinkedIn](https://www.linkedin.com/in/speaker-0a0123452/), [Github](https://github.com/speaker2), [Portfolio](https://speaker-2.github.io)
                ## Talk3
                ### By: **Event3 Speaker 3**
                Talented Speaker-3

                Follow on: [LinkedIn](https://www.linkedin.com/in/speaker-0a0123453/), [Github](https://github.com/speaker3), [Portfolio](https://speaker-3.github.io)

                """
            }
        }
    }
}
