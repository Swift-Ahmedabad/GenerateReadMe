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

@Suite(.snapshots(record: .never))
struct GenerateReadMeTests {

    @Test
    func eventsParsing() async throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        let fileURL = testURL.appending(path: "Events")
        let event1URL = fileURL.appending(path: "1. Jan 01 2025/Talk1")
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
        
        try withSnapshotTesting {
            let events = try GenerateReadMeCommand.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"])
            assertInlineSnapshot(of: events, as: .customDump) {
                """
                [
                  [0]: Event(
                    title: "1. Jan 01 2025",
                    date: Date(2024-12-31T18:30:00.000Z),
                    id: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3",
                    talks: [
                      [0]: Talk(
                        title: "Talk1",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Johny Appleseed",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                              github: "https://github.com/johny-appleseed",
                              portfolio: "https://johny-appleseed.github.io",
                              twitter: nil
                            ),
                            about: "Apple Engineer"
                          )
                        ]
                      )
                    ]
                  )
                ]
                """
            }
         }
    }
    
    @Test
    func eventsParsingWithMultipleSpeakers() async throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }

        let fileURL = testURL.appending(path: "Events")
        let event1URL = fileURL.appending(path: "1. Jan 01 2025/Talk1")
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
            let events = try GenerateReadMeCommand.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"])
            assertInlineSnapshot(of: events, as: .customDump) {
                """
                [
                  [0]: Event(
                    title: "1. Jan 01 2025",
                    date: Date(2024-12-31T18:30:00.000Z),
                    id: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3",
                    talks: [
                      [0]: Talk(
                        title: "Talk1",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Johny Appleseed",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                              github: "https://github.com/johny-appleseed",
                              portfolio: "https://johny-appleseed.github.io",
                              twitter: nil
                            ),
                            about: "Apple Engineer"
                          ),
                          [1]: Speaker(
                            speaker: "Linus Torvalds",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/linus-torvalds-0a0123456/",
                              github: nil,
                              portfolio: nil,
                              twitter: nil
                            ),
                            about: "Git Inventor"
                          )
                        ]
                      )
                    ]
                  )
                ]
                """
            }
         }
    }
    
    @Test
    func multipleEvents() throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }

        let fileURL = testURL.appending(path: "Events")
        for e in 1...3 {
            for t in 1...3 {
                let event1URL = fileURL.appending(path: "\(e). Jan \(e) 2025/Talk\(t)")
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
            let events = try GenerateReadMeCommand.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"])
            assertInlineSnapshot(of: events, as: .customDump) {
                """
                [
                  [0]: Event(
                    title: "3. Jan 3 2025",
                    date: Date(2025-01-02T18:30:00.000Z),
                    id: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b",
                    talks: [
                      [0]: Talk(
                        title: "Talk1",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Event3 Speaker 1",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                              github: "https://github.com/speaker1",
                              portfolio: "https://speaker-1.github.io",
                              twitter: nil
                            ),
                            about: "Talented Speaker-1"
                          )
                        ]
                      ),
                      [1]: Talk(
                        title: "Talk2",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Event3 Speaker 2",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                              github: "https://github.com/speaker2",
                              portfolio: "https://speaker-2.github.io",
                              twitter: nil
                            ),
                            about: "Talented Speaker-2"
                          )
                        ]
                      ),
                      [2]: Talk(
                        title: "Talk3",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Event3 Speaker 3",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                              github: "https://github.com/speaker3",
                              portfolio: "https://speaker-3.github.io",
                              twitter: nil
                            ),
                            about: "Talented Speaker-3"
                          )
                        ]
                      )
                    ]
                  ),
                  [1]: Event(
                    title: "1. Jan 1 2025",
                    date: Date(2024-12-31T18:30:00.000Z),
                    id: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c",
                    talks: [
                      [0]: Talk(
                        title: "Talk1",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Event1 Speaker 1",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                              github: "https://github.com/speaker1",
                              portfolio: "https://speaker-1.github.io",
                              twitter: nil
                            ),
                            about: "Talented Speaker-1"
                          )
                        ]
                      ),
                      [1]: Talk(
                        title: "Talk2",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Event1 Speaker 2",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                              github: "https://github.com/speaker2",
                              portfolio: "https://speaker-2.github.io",
                              twitter: nil
                            ),
                            about: "Talented Speaker-2"
                          )
                        ]
                      ),
                      [2]: Talk(
                        title: "Talk3",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Event1 Speaker 3",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                              github: "https://github.com/speaker3",
                              portfolio: "https://speaker-3.github.io",
                              twitter: nil
                            ),
                            about: "Talented Speaker-3"
                          )
                        ]
                      )
                    ]
                  ),
                  [2]: Event(
                    title: "2. Jan 2 2025",
                    date: Date(2025-01-01T18:30:00.000Z),
                    id: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa",
                    talks: [
                      [0]: Talk(
                        title: "Talk1",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Event2 Speaker 1",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                              github: "https://github.com/speaker1",
                              portfolio: "https://speaker-1.github.io",
                              twitter: nil
                            ),
                            about: "Talented Speaker-1"
                          )
                        ]
                      ),
                      [1]: Talk(
                        title: "Talk2",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Event2 Speaker 2",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                              github: "https://github.com/speaker2",
                              portfolio: "https://speaker-2.github.io",
                              twitter: nil
                            ),
                            about: "Talented Speaker-2"
                          )
                        ]
                      ),
                      [2]: Talk(
                        title: "Talk3",
                        speakers: [
                          [0]: Speaker(
                            speaker: "Event2 Speaker 3",
                            socials: Speaker.Socials(
                              linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                              github: "https://github.com/speaker3",
                              portfolio: "https://speaker-3.github.io",
                              twitter: nil
                            ),
                            about: "Talented Speaker-3"
                          )
                        ]
                      )
                    ]
                  )
                ]
                """
            }
        }
    }
    
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
            let events = try GenerateReadMeCommand.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"])
            let readMeURL = fileURL.appending(path: "README.md")
            try GenerateReadMeCommand.generateReadMe(for: events, at: readMeURL)
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
            let events = try GenerateReadMeCommand.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"])
            let readMeURL = fileURL.appending(path: "README.md")
            try GenerateReadMeCommand.generateReadMe(for: events, at: readMeURL)
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
            let events = try GenerateReadMeCommand.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"])
            let readMeURL = fileURL.appending(path: "README.md")
            try GenerateReadMeCommand.generateReadMe(for: events, at: readMeURL)
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
