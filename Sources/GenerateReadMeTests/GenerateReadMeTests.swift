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
                (
                  [
                    [0]: Event(
                      id: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3",
                      title: "1. Jan 01 2025",
                      date: Date(2024-12-31T18:30:00.000Z),
                      talks: [
                        [0]: Talk(
                          id: "ecaf03a399ff924b2c962d82ae28d002702232cae8c5cfd0f607a9ba44a7c688",
                          title: "Talk1",
                          speakers: [
                            [0]: Speaker(
                              id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
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
                  ],
                  Set([
                    Speaker(
                      id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                      speaker: "Johny Appleseed",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                        github: "https://github.com/johny-appleseed",
                        portfolio: "https://johny-appleseed.github.io",
                        twitter: nil
                      ),
                      about: "Apple Engineer"
                    )
                  ])
                )
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
                (
                  [
                    [0]: Event(
                      id: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3",
                      title: "1. Jan 01 2025",
                      date: Date(2024-12-31T18:30:00.000Z),
                      talks: [
                        [0]: Talk(
                          id: "b140ffb160d2d8f87d8f1f5a22dfb9b3f06814a2c06c7727820ee86f399838b6",
                          title: "Talk1",
                          speakers: [
                            [0]: Speaker(
                              id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
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
                              id: "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2",
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
                  ],
                  Set([
                    Speaker(
                      id: "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2",
                      speaker: "Linus Torvalds",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/linus-torvalds-0a0123456/",
                        github: nil,
                        portfolio: nil,
                        twitter: nil
                      ),
                      about: "Git Inventor"
                    ),
                    Speaker(
                      id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                      speaker: "Johny Appleseed",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                        github: "https://github.com/johny-appleseed",
                        portfolio: "https://johny-appleseed.github.io",
                        twitter: nil
                      ),
                      about: "Apple Engineer"
                    )
                  ])
                )
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
                (
                  [
                    [0]: Event(
                      id: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b",
                      title: "3. Jan 3 2025",
                      date: Date(2025-01-02T18:30:00.000Z),
                      talks: [
                        [0]: Talk(
                          id: "fd277e6495fb0caa568c5cbaaedaad60808a177d4ae01da450d914c31ee8e4f0",
                          title: "Talk1",
                          speakers: [
                            [0]: Speaker(
                              id: "0efb512fe5ae1b65c754b900a68a440ce733b440f386c30fd40f302e5f7d07b6",
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
                          id: "248f1e066d8a922f98877bc46a84a5b889354b7492160da74675a3f6af857842",
                          title: "Talk2",
                          speakers: [
                            [0]: Speaker(
                              id: "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497",
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
                          id: "c5e1f68fff5427250156c030f63f120dbde292176f7e92d6323d30c332ac03ae",
                          title: "Talk3",
                          speakers: [
                            [0]: Speaker(
                              id: "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079",
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
                      id: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c",
                      title: "1. Jan 1 2025",
                      date: Date(2024-12-31T18:30:00.000Z),
                      talks: [
                        [0]: Talk(
                          id: "b723e00e91c334d00a79241b2e84bb101b73c6e23fa35de36392fe91133709f1",
                          title: "Talk1",
                          speakers: [
                            [0]: Speaker(
                              id: "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
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
                          id: "5d126bf89442bb1e045b1b55d89756613b435015c4749d04a18001e64d47ae4d",
                          title: "Talk2",
                          speakers: [
                            [0]: Speaker(
                              id: "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
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
                          id: "25e69df417cf2a68c2134716e8393f972b374439a75aefccaf3bfe8db39723ee",
                          title: "Talk3",
                          speakers: [
                            [0]: Speaker(
                              id: "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32",
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
                      id: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa",
                      title: "2. Jan 2 2025",
                      date: Date(2025-01-01T18:30:00.000Z),
                      talks: [
                        [0]: Talk(
                          id: "a387ae1b54aa05b3127e6514065a9a3b58aa00565622fbf929273b84b328c376",
                          title: "Talk1",
                          speakers: [
                            [0]: Speaker(
                              id: "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
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
                          id: "d280611d7a9fca10514d8ad2cd6f1d5698e5ec916e8277edc19c05ec9dc40017",
                          title: "Talk2",
                          speakers: [
                            [0]: Speaker(
                              id: "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
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
                          id: "d5cdb6edc90b5968dfbb8ce5ade731a4eca9e8ae18bf7c5fc9ee71b8700df8a4",
                          title: "Talk3",
                          speakers: [
                            [0]: Speaker(
                              id: "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c",
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
                  ],
                  Set([
                    Speaker(
                      id: "0efb512fe5ae1b65c754b900a68a440ce733b440f386c30fd40f302e5f7d07b6",
                      speaker: "Event3 Speaker 1",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                        github: "https://github.com/speaker1",
                        portfolio: "https://speaker-1.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-1"
                    ),
                    Speaker(
                      id: "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
                      speaker: "Event1 Speaker 1",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                        github: "https://github.com/speaker1",
                        portfolio: "https://speaker-1.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-1"
                    ),
                    Speaker(
                      id: "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
                      speaker: "Event2 Speaker 1",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                        github: "https://github.com/speaker1",
                        portfolio: "https://speaker-1.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-1"
                    ),
                    Speaker(
                      id: "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
                      speaker: "Event2 Speaker 2",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                        github: "https://github.com/speaker2",
                        portfolio: "https://speaker-2.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-2"
                    ),
                    Speaker(
                      id: "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c",
                      speaker: "Event2 Speaker 3",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                        github: "https://github.com/speaker3",
                        portfolio: "https://speaker-3.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-3"
                    ),
                    Speaker(
                      id: "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32",
                      speaker: "Event1 Speaker 3",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                        github: "https://github.com/speaker3",
                        portfolio: "https://speaker-3.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-3"
                    ),
                    Speaker(
                      id: "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079",
                      speaker: "Event3 Speaker 3",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                        github: "https://github.com/speaker3",
                        portfolio: "https://speaker-3.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-3"
                    ),
                    Speaker(
                      id: "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
                      speaker: "Event1 Speaker 2",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                        github: "https://github.com/speaker2",
                        portfolio: "https://speaker-2.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-2"
                    ),
                    Speaker(
                      id: "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497",
                      speaker: "Event3 Speaker 2",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                        github: "https://github.com/speaker2",
                        portfolio: "https://speaker-2.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-2"
                    )
                  ])
                )
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
            let events = try GenerateReadMeCommand.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"]).0
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
            let events = try GenerateReadMeCommand.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"]).0
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
            let events = try GenerateReadMeCommand.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"]).0
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
