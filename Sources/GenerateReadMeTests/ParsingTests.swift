//
//  Test.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation
@testable import GenerateReadMe
import InlineSnapshotTesting
@preconcurrency import SnapshotTesting
import SnapshotTestingCustomDump
import Testing


@Suite(.snapshots(record: .failed))
struct ParsingTests {

    @Test func eventsParsing() async throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        let fileURL = testURL.appending(path: "Events")
        let event1URL = fileURL.appending(path: "1. Jan 01 2025/Talk1")
        try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
        let speakerYML =
        """
        - name: Johny Appleseed
          socials:
            linkedIn: https://www.linkedin.com/in/johny-appleseed-0a0123456/
            github: https://github.com/johny-appleseed
            portfolio: https://johny-appleseed.github.io
          about: Apple Engineer
          image: johnyappleseed.jpeg 
        """
        let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
        try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
        
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false))
            assertInlineSnapshot(of: events, as: .customDump) {
                """
                Parser.EventsInfo(
                  events: [
                    [0]: Event(
                      id: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3",
                      title: "1. Jan 01 2025",
                      date: Date(2024-12-31T18:30:00.000Z)
                    )
                  ],
                  eventsWithTalks: [
                    [0]: EventWithTalks(
                      event: Event(
                        id: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3",
                        title: "1. Jan 01 2025",
                        date: Date(2024-12-31T18:30:00.000Z)
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "81c01356949a2310018218b6d0013b2b4209ae5b5facf123d279a7eec2fb8a9e",
                            title: "Talk1",
                            eventID: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                              name: "Johny Appleseed",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                                github: "https://github.com/johny-appleseed",
                                portfolio: "https://johny-appleseed.github.io",
                                twitter: nil
                              ),
                              about: "Apple Engineer",
                              image: "johnyappleseed.jpeg"
                            )
                          ]
                        )
                      ],
                      eventInfo: nil
                    )
                  ],
                  speakers: [
                    [0]: Speaker(
                      id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                      name: "Johny Appleseed",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                        github: "https://github.com/johny-appleseed",
                        portfolio: "https://johny-appleseed.github.io",
                        twitter: nil
                      ),
                      about: "Apple Engineer",
                      image: "johnyappleseed.jpeg"
                    )
                  ],
                  talksWithSpeakers: [
                    [0]: TalkWithSpeakers(
                      talk: Talk(
                        id: "81c01356949a2310018218b6d0013b2b4209ae5b5facf123d279a7eec2fb8a9e",
                        title: "Talk1",
                        eventID: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                          name: "Johny Appleseed",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                            github: "https://github.com/johny-appleseed",
                            portfolio: "https://johny-appleseed.github.io",
                            twitter: nil
                          ),
                          about: "Apple Engineer",
                          image: "johnyappleseed.jpeg"
                        )
                      ]
                    )
                  ],
                  talks: [
                    [0]: Talk(
                      id: "81c01356949a2310018218b6d0013b2b4209ae5b5facf123d279a7eec2fb8a9e",
                      title: "Talk1",
                      eventID: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3"
                    )
                  ],
                  talkSpeakers: [
                    [0]: TalkSpeaker(
                      id: "ce3e25fc078c362f895300696b827876c9e1f407bbb172257bef21f7910c6043",
                      talkID: "81c01356949a2310018218b6d0013b2b4209ae5b5facf123d279a7eec2fb8a9e",
                      speakerID: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173"
                    )
                  ],
                  eventInfos: [],
                  agendas: [],
                  sponsors: [],
                  agendaSpeakerIDs: []
                )
                """
            }
         }
    }
    
    @Test func eventsParsingWithMultipleSpeakers() async throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }

        let fileURL = testURL.appending(path: "Events")
        let event1URL = fileURL.appending(path: "1. Jan 01 2025/Talk1")
        try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
        let speakerYML =
        """
        - name: Johny Appleseed
          socials:
            linkedIn: https://www.linkedin.com/in/johny-appleseed-0a0123456/
            github: https://github.com/johny-appleseed
            portfolio: https://johny-appleseed.github.io
          about: Apple Engineer
          image: johnyappleseed.jpeg
        - name: Linus Torvalds
          socials:
            linkedIn: https://www.linkedin.com/in/linus-torvalds-0a0123456/
          about: Git Inventor
          image: linustorwards.jpeg
        """
        let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
        try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
                
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false))
            assertInlineSnapshot(of: events, as: .customDump) {
                """
                Parser.EventsInfo(
                  events: [
                    [0]: Event(
                      id: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3",
                      title: "1. Jan 01 2025",
                      date: Date(2024-12-31T18:30:00.000Z)
                    )
                  ],
                  eventsWithTalks: [
                    [0]: EventWithTalks(
                      event: Event(
                        id: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3",
                        title: "1. Jan 01 2025",
                        date: Date(2024-12-31T18:30:00.000Z)
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "81c01356949a2310018218b6d0013b2b4209ae5b5facf123d279a7eec2fb8a9e",
                            title: "Talk1",
                            eventID: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                              name: "Johny Appleseed",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                                github: "https://github.com/johny-appleseed",
                                portfolio: "https://johny-appleseed.github.io",
                                twitter: nil
                              ),
                              about: "Apple Engineer",
                              image: "johnyappleseed.jpeg"
                            ),
                            [1]: Speaker(
                              id: "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2",
                              name: "Linus Torvalds",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/linus-torvalds-0a0123456/",
                                github: nil,
                                portfolio: nil,
                                twitter: nil
                              ),
                              about: "Git Inventor",
                              image: "linustorwards.jpeg"
                            )
                          ]
                        )
                      ],
                      eventInfo: nil
                    )
                  ],
                  speakers: [
                    [0]: Speaker(
                      id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                      name: "Johny Appleseed",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                        github: "https://github.com/johny-appleseed",
                        portfolio: "https://johny-appleseed.github.io",
                        twitter: nil
                      ),
                      about: "Apple Engineer",
                      image: "johnyappleseed.jpeg"
                    ),
                    [1]: Speaker(
                      id: "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2",
                      name: "Linus Torvalds",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/linus-torvalds-0a0123456/",
                        github: nil,
                        portfolio: nil,
                        twitter: nil
                      ),
                      about: "Git Inventor",
                      image: "linustorwards.jpeg"
                    )
                  ],
                  talksWithSpeakers: [
                    [0]: TalkWithSpeakers(
                      talk: Talk(
                        id: "81c01356949a2310018218b6d0013b2b4209ae5b5facf123d279a7eec2fb8a9e",
                        title: "Talk1",
                        eventID: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                          name: "Johny Appleseed",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                            github: "https://github.com/johny-appleseed",
                            portfolio: "https://johny-appleseed.github.io",
                            twitter: nil
                          ),
                          about: "Apple Engineer",
                          image: "johnyappleseed.jpeg"
                        ),
                        [1]: Speaker(
                          id: "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2",
                          name: "Linus Torvalds",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/linus-torvalds-0a0123456/",
                            github: nil,
                            portfolio: nil,
                            twitter: nil
                          ),
                          about: "Git Inventor",
                          image: "linustorwards.jpeg"
                        )
                      ]
                    )
                  ],
                  talks: [
                    [0]: Talk(
                      id: "81c01356949a2310018218b6d0013b2b4209ae5b5facf123d279a7eec2fb8a9e",
                      title: "Talk1",
                      eventID: "f604f4a98f81a6c927d94bdf265c17f593680b9e18a4afa8aacea1c833ad82c3"
                    )
                  ],
                  talkSpeakers: [
                    [0]: TalkSpeaker(
                      id: "ce3e25fc078c362f895300696b827876c9e1f407bbb172257bef21f7910c6043",
                      talkID: "81c01356949a2310018218b6d0013b2b4209ae5b5facf123d279a7eec2fb8a9e",
                      speakerID: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173"
                    ),
                    [1]: TalkSpeaker(
                      id: "6b390aaefe4805bc5a34cf73a0abcef23b14cf23335fcf167e3ef14e2c155fc4",
                      talkID: "81c01356949a2310018218b6d0013b2b4209ae5b5facf123d279a7eec2fb8a9e",
                      speakerID: "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2"
                    )
                  ],
                  eventInfos: [],
                  agendas: [],
                  sponsors: [],
                  agendaSpeakerIDs: []
                )
                """
            }
         }
    }
    
    @Test func multipleEventsParsing() throws {
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
                - name: Event\(e) Speaker \(t)
                  socials:
                    linkedIn: https://www.linkedin.com/in/speaker-0a012345\(t)/
                    github: https://github.com/speaker\(t)
                    portfolio: https://speaker-\(t).github.io
                  about: Talented Speaker-\(t)
                  image: telentedspeaker\(t).png
                """
                let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
                try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
            }
        }
        
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false))
            assertInlineSnapshot(of: events, as: .customDump) {
                """
                Parser.EventsInfo(
                  events: [
                    [0]: Event(
                      id: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b",
                      title: "3. Jan 3 2025",
                      date: Date(2025-01-02T18:30:00.000Z)
                    ),
                    [1]: Event(
                      id: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c",
                      title: "1. Jan 1 2025",
                      date: Date(2024-12-31T18:30:00.000Z)
                    ),
                    [2]: Event(
                      id: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa",
                      title: "2. Jan 2 2025",
                      date: Date(2025-01-01T18:30:00.000Z)
                    )
                  ],
                  eventsWithTalks: [
                    [0]: EventWithTalks(
                      event: Event(
                        id: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b",
                        title: "3. Jan 3 2025",
                        date: Date(2025-01-02T18:30:00.000Z)
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "c5a8cd9a541fd0cd1cac0da14a7363d288b24a3f2ccc5f517bc6fbe52bd9237a",
                            title: "Talk1",
                            eventID: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "0efb512fe5ae1b65c754b900a68a440ce733b440f386c30fd40f302e5f7d07b6",
                              name: "Event3 Speaker 1",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                                github: "https://github.com/speaker1",
                                portfolio: "https://speaker-1.github.io",
                                twitter: nil
                              ),
                              about: "Talented Speaker-1",
                              image: "telentedspeaker1.png"
                            )
                          ]
                        ),
                        [1]: TalkWithSpeakers(
                          talk: Talk(
                            id: "3bcbfbf5c6467410768f83462c13a9228a7141e302f9587e0c019b83ae73db58",
                            title: "Talk2",
                            eventID: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497",
                              name: "Event3 Speaker 2",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                                github: "https://github.com/speaker2",
                                portfolio: "https://speaker-2.github.io",
                                twitter: nil
                              ),
                              about: "Talented Speaker-2",
                              image: "telentedspeaker2.png"
                            )
                          ]
                        ),
                        [2]: TalkWithSpeakers(
                          talk: Talk(
                            id: "5d7446e453a72bb684926b92dec42ad41899ad2bfeecacfffff25e2386b0ab59",
                            title: "Talk3",
                            eventID: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079",
                              name: "Event3 Speaker 3",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                                github: "https://github.com/speaker3",
                                portfolio: "https://speaker-3.github.io",
                                twitter: nil
                              ),
                              about: "Talented Speaker-3",
                              image: "telentedspeaker3.png"
                            )
                          ]
                        )
                      ],
                      eventInfo: nil
                    ),
                    [1]: EventWithTalks(
                      event: Event(
                        id: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c",
                        title: "1. Jan 1 2025",
                        date: Date(2024-12-31T18:30:00.000Z)
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "47bdf483b646f5ca943cb0861f275b0d33acfc8f7c68ff1d1b691b5af54c6129",
                            title: "Talk1",
                            eventID: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
                              name: "Event1 Speaker 1",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                                github: "https://github.com/speaker1",
                                portfolio: "https://speaker-1.github.io",
                                twitter: nil
                              ),
                              about: "Talented Speaker-1",
                              image: "telentedspeaker1.png"
                            )
                          ]
                        ),
                        [1]: TalkWithSpeakers(
                          talk: Talk(
                            id: "f6418a9a45c64c94ffd823671b6e8716be09773fc48edff5ff001b77ea89637a",
                            title: "Talk2",
                            eventID: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
                              name: "Event1 Speaker 2",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                                github: "https://github.com/speaker2",
                                portfolio: "https://speaker-2.github.io",
                                twitter: nil
                              ),
                              about: "Talented Speaker-2",
                              image: "telentedspeaker2.png"
                            )
                          ]
                        ),
                        [2]: TalkWithSpeakers(
                          talk: Talk(
                            id: "8ceb89592195b03eec29984b8c682e7dc6a2e4f8e865b4e744c861edecfd77d4",
                            title: "Talk3",
                            eventID: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32",
                              name: "Event1 Speaker 3",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                                github: "https://github.com/speaker3",
                                portfolio: "https://speaker-3.github.io",
                                twitter: nil
                              ),
                              about: "Talented Speaker-3",
                              image: "telentedspeaker3.png"
                            )
                          ]
                        )
                      ],
                      eventInfo: nil
                    ),
                    [2]: EventWithTalks(
                      event: Event(
                        id: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa",
                        title: "2. Jan 2 2025",
                        date: Date(2025-01-01T18:30:00.000Z)
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "40e94bd6795baaca8809b99359709187837df745a443ccb230cfe963a7c39723",
                            title: "Talk1",
                            eventID: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
                              name: "Event2 Speaker 1",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                                github: "https://github.com/speaker1",
                                portfolio: "https://speaker-1.github.io",
                                twitter: nil
                              ),
                              about: "Talented Speaker-1",
                              image: "telentedspeaker1.png"
                            )
                          ]
                        ),
                        [1]: TalkWithSpeakers(
                          talk: Talk(
                            id: "f60e59352020ec238691e7cdca3eefc614ee317a00d5cb1482f1dfdd70ffc59b",
                            title: "Talk2",
                            eventID: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
                              name: "Event2 Speaker 2",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                                github: "https://github.com/speaker2",
                                portfolio: "https://speaker-2.github.io",
                                twitter: nil
                              ),
                              about: "Talented Speaker-2",
                              image: "telentedspeaker2.png"
                            )
                          ]
                        ),
                        [2]: TalkWithSpeakers(
                          talk: Talk(
                            id: "b45986c47d464ede2b45b1708ac6b00c37a07c661534d5f1e133f5ac827c17d4",
                            title: "Talk3",
                            eventID: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c",
                              name: "Event2 Speaker 3",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                                github: "https://github.com/speaker3",
                                portfolio: "https://speaker-3.github.io",
                                twitter: nil
                              ),
                              about: "Talented Speaker-3",
                              image: "telentedspeaker3.png"
                            )
                          ]
                        )
                      ],
                      eventInfo: nil
                    )
                  ],
                  speakers: [
                    [0]: Speaker(
                      id: "0efb512fe5ae1b65c754b900a68a440ce733b440f386c30fd40f302e5f7d07b6",
                      name: "Event3 Speaker 1",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                        github: "https://github.com/speaker1",
                        portfolio: "https://speaker-1.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-1",
                      image: "telentedspeaker1.png"
                    ),
                    [1]: Speaker(
                      id: "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497",
                      name: "Event3 Speaker 2",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                        github: "https://github.com/speaker2",
                        portfolio: "https://speaker-2.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-2",
                      image: "telentedspeaker2.png"
                    ),
                    [2]: Speaker(
                      id: "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079",
                      name: "Event3 Speaker 3",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                        github: "https://github.com/speaker3",
                        portfolio: "https://speaker-3.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-3",
                      image: "telentedspeaker3.png"
                    ),
                    [3]: Speaker(
                      id: "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
                      name: "Event1 Speaker 1",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                        github: "https://github.com/speaker1",
                        portfolio: "https://speaker-1.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-1",
                      image: "telentedspeaker1.png"
                    ),
                    [4]: Speaker(
                      id: "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
                      name: "Event1 Speaker 2",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                        github: "https://github.com/speaker2",
                        portfolio: "https://speaker-2.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-2",
                      image: "telentedspeaker2.png"
                    ),
                    [5]: Speaker(
                      id: "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32",
                      name: "Event1 Speaker 3",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                        github: "https://github.com/speaker3",
                        portfolio: "https://speaker-3.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-3",
                      image: "telentedspeaker3.png"
                    ),
                    [6]: Speaker(
                      id: "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
                      name: "Event2 Speaker 1",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                        github: "https://github.com/speaker1",
                        portfolio: "https://speaker-1.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-1",
                      image: "telentedspeaker1.png"
                    ),
                    [7]: Speaker(
                      id: "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
                      name: "Event2 Speaker 2",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                        github: "https://github.com/speaker2",
                        portfolio: "https://speaker-2.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-2",
                      image: "telentedspeaker2.png"
                    ),
                    [8]: Speaker(
                      id: "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c",
                      name: "Event2 Speaker 3",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                        github: "https://github.com/speaker3",
                        portfolio: "https://speaker-3.github.io",
                        twitter: nil
                      ),
                      about: "Talented Speaker-3",
                      image: "telentedspeaker3.png"
                    )
                  ],
                  talksWithSpeakers: [
                    [0]: TalkWithSpeakers(
                      talk: Talk(
                        id: "c5a8cd9a541fd0cd1cac0da14a7363d288b24a3f2ccc5f517bc6fbe52bd9237a",
                        title: "Talk1",
                        eventID: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "0efb512fe5ae1b65c754b900a68a440ce733b440f386c30fd40f302e5f7d07b6",
                          name: "Event3 Speaker 1",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                            github: "https://github.com/speaker1",
                            portfolio: "https://speaker-1.github.io",
                            twitter: nil
                          ),
                          about: "Talented Speaker-1",
                          image: "telentedspeaker1.png"
                        )
                      ]
                    ),
                    [1]: TalkWithSpeakers(
                      talk: Talk(
                        id: "3bcbfbf5c6467410768f83462c13a9228a7141e302f9587e0c019b83ae73db58",
                        title: "Talk2",
                        eventID: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497",
                          name: "Event3 Speaker 2",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                            github: "https://github.com/speaker2",
                            portfolio: "https://speaker-2.github.io",
                            twitter: nil
                          ),
                          about: "Talented Speaker-2",
                          image: "telentedspeaker2.png"
                        )
                      ]
                    ),
                    [2]: TalkWithSpeakers(
                      talk: Talk(
                        id: "5d7446e453a72bb684926b92dec42ad41899ad2bfeecacfffff25e2386b0ab59",
                        title: "Talk3",
                        eventID: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079",
                          name: "Event3 Speaker 3",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                            github: "https://github.com/speaker3",
                            portfolio: "https://speaker-3.github.io",
                            twitter: nil
                          ),
                          about: "Talented Speaker-3",
                          image: "telentedspeaker3.png"
                        )
                      ]
                    ),
                    [3]: TalkWithSpeakers(
                      talk: Talk(
                        id: "47bdf483b646f5ca943cb0861f275b0d33acfc8f7c68ff1d1b691b5af54c6129",
                        title: "Talk1",
                        eventID: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
                          name: "Event1 Speaker 1",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                            github: "https://github.com/speaker1",
                            portfolio: "https://speaker-1.github.io",
                            twitter: nil
                          ),
                          about: "Talented Speaker-1",
                          image: "telentedspeaker1.png"
                        )
                      ]
                    ),
                    [4]: TalkWithSpeakers(
                      talk: Talk(
                        id: "f6418a9a45c64c94ffd823671b6e8716be09773fc48edff5ff001b77ea89637a",
                        title: "Talk2",
                        eventID: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
                          name: "Event1 Speaker 2",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                            github: "https://github.com/speaker2",
                            portfolio: "https://speaker-2.github.io",
                            twitter: nil
                          ),
                          about: "Talented Speaker-2",
                          image: "telentedspeaker2.png"
                        )
                      ]
                    ),
                    [5]: TalkWithSpeakers(
                      talk: Talk(
                        id: "8ceb89592195b03eec29984b8c682e7dc6a2e4f8e865b4e744c861edecfd77d4",
                        title: "Talk3",
                        eventID: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32",
                          name: "Event1 Speaker 3",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                            github: "https://github.com/speaker3",
                            portfolio: "https://speaker-3.github.io",
                            twitter: nil
                          ),
                          about: "Talented Speaker-3",
                          image: "telentedspeaker3.png"
                        )
                      ]
                    ),
                    [6]: TalkWithSpeakers(
                      talk: Talk(
                        id: "40e94bd6795baaca8809b99359709187837df745a443ccb230cfe963a7c39723",
                        title: "Talk1",
                        eventID: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
                          name: "Event2 Speaker 1",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                            github: "https://github.com/speaker1",
                            portfolio: "https://speaker-1.github.io",
                            twitter: nil
                          ),
                          about: "Talented Speaker-1",
                          image: "telentedspeaker1.png"
                        )
                      ]
                    ),
                    [7]: TalkWithSpeakers(
                      talk: Talk(
                        id: "f60e59352020ec238691e7cdca3eefc614ee317a00d5cb1482f1dfdd70ffc59b",
                        title: "Talk2",
                        eventID: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
                          name: "Event2 Speaker 2",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                            github: "https://github.com/speaker2",
                            portfolio: "https://speaker-2.github.io",
                            twitter: nil
                          ),
                          about: "Talented Speaker-2",
                          image: "telentedspeaker2.png"
                        )
                      ]
                    ),
                    [8]: TalkWithSpeakers(
                      talk: Talk(
                        id: "b45986c47d464ede2b45b1708ac6b00c37a07c661534d5f1e133f5ac827c17d4",
                        title: "Talk3",
                        eventID: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c",
                          name: "Event2 Speaker 3",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                            github: "https://github.com/speaker3",
                            portfolio: "https://speaker-3.github.io",
                            twitter: nil
                          ),
                          about: "Talented Speaker-3",
                          image: "telentedspeaker3.png"
                        )
                      ]
                    )
                  ],
                  talks: [
                    [0]: Talk(
                      id: "c5a8cd9a541fd0cd1cac0da14a7363d288b24a3f2ccc5f517bc6fbe52bd9237a",
                      title: "Talk1",
                      eventID: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b"
                    ),
                    [1]: Talk(
                      id: "3bcbfbf5c6467410768f83462c13a9228a7141e302f9587e0c019b83ae73db58",
                      title: "Talk2",
                      eventID: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b"
                    ),
                    [2]: Talk(
                      id: "5d7446e453a72bb684926b92dec42ad41899ad2bfeecacfffff25e2386b0ab59",
                      title: "Talk3",
                      eventID: "4993da9c25096119c9d83956b7b4d47e24930d202f7d30fe12f66e785887655b"
                    ),
                    [3]: Talk(
                      id: "47bdf483b646f5ca943cb0861f275b0d33acfc8f7c68ff1d1b691b5af54c6129",
                      title: "Talk1",
                      eventID: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c"
                    ),
                    [4]: Talk(
                      id: "f6418a9a45c64c94ffd823671b6e8716be09773fc48edff5ff001b77ea89637a",
                      title: "Talk2",
                      eventID: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c"
                    ),
                    [5]: Talk(
                      id: "8ceb89592195b03eec29984b8c682e7dc6a2e4f8e865b4e744c861edecfd77d4",
                      title: "Talk3",
                      eventID: "c2268d1cc36728db58a57e999430706d1557e8725c4160b11bad1a9665d4e11c"
                    ),
                    [6]: Talk(
                      id: "40e94bd6795baaca8809b99359709187837df745a443ccb230cfe963a7c39723",
                      title: "Talk1",
                      eventID: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa"
                    ),
                    [7]: Talk(
                      id: "f60e59352020ec238691e7cdca3eefc614ee317a00d5cb1482f1dfdd70ffc59b",
                      title: "Talk2",
                      eventID: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa"
                    ),
                    [8]: Talk(
                      id: "b45986c47d464ede2b45b1708ac6b00c37a07c661534d5f1e133f5ac827c17d4",
                      title: "Talk3",
                      eventID: "15c372e9de65d46e0e5ebbd66e23270b32360c7a07220a508f98b3a447cf33fa"
                    )
                  ],
                  talkSpeakers: [
                    [0]: TalkSpeaker(
                      id: "71c16e467e3b78bf145102c9fa26ba5ea3485abc0161847aa51ecfe25adc798c",
                      talkID: "c5a8cd9a541fd0cd1cac0da14a7363d288b24a3f2ccc5f517bc6fbe52bd9237a",
                      speakerID: "0efb512fe5ae1b65c754b900a68a440ce733b440f386c30fd40f302e5f7d07b6"
                    ),
                    [1]: TalkSpeaker(
                      id: "5f1d6e8070bb760bb90871ffd7000ee90d76f9dcf2aec9821855a4ef19e4ef10",
                      talkID: "3bcbfbf5c6467410768f83462c13a9228a7141e302f9587e0c019b83ae73db58",
                      speakerID: "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497"
                    ),
                    [2]: TalkSpeaker(
                      id: "1bc2ee3707423f7f435fe62afdd4f796351d30a0d5c8aa2f68d73022505990af",
                      talkID: "5d7446e453a72bb684926b92dec42ad41899ad2bfeecacfffff25e2386b0ab59",
                      speakerID: "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079"
                    ),
                    [3]: TalkSpeaker(
                      id: "182f84eb215bb89fe89124759a44100f279581319882a77f16bbfe65820f9ad7",
                      talkID: "47bdf483b646f5ca943cb0861f275b0d33acfc8f7c68ff1d1b691b5af54c6129",
                      speakerID: "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f"
                    ),
                    [4]: TalkSpeaker(
                      id: "f854361e5646184b1a155457f22d2e5ff9ae705927b518548ec876f36e89ea14",
                      talkID: "f6418a9a45c64c94ffd823671b6e8716be09773fc48edff5ff001b77ea89637a",
                      speakerID: "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3"
                    ),
                    [5]: TalkSpeaker(
                      id: "86ee1b9c2e0ce991ca05255cd5414eeeed8b9ece98946b358b9e3ea7bfec5772",
                      talkID: "8ceb89592195b03eec29984b8c682e7dc6a2e4f8e865b4e744c861edecfd77d4",
                      speakerID: "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32"
                    ),
                    [6]: TalkSpeaker(
                      id: "e251893fc52dd534b9e6e861d29bffafd9ff8090dc89fbdab374dd9982ea1fea",
                      talkID: "40e94bd6795baaca8809b99359709187837df745a443ccb230cfe963a7c39723",
                      speakerID: "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d"
                    ),
                    [7]: TalkSpeaker(
                      id: "dcc4ecf52ba0fb95187e3e0d80821c29e734eeaf70bfbea68528410d51673e2c",
                      talkID: "f60e59352020ec238691e7cdca3eefc614ee317a00d5cb1482f1dfdd70ffc59b",
                      speakerID: "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52"
                    ),
                    [8]: TalkSpeaker(
                      id: "15d416adc0d6bea91c292575bd886668931d61a827ecb4a9b140fc7cde3b778a",
                      talkID: "b45986c47d464ede2b45b1708ac6b00c37a07c661534d5f1e133f5ac827c17d4",
                      speakerID: "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c"
                    )
                  ],
                  eventInfos: [],
                  agendas: [],
                  sponsors: [],
                  agendaSpeakerIDs: []
                )
                """
            }
        }
    }
    
    @Test func parseEventInfo() throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        let fileURL = testURL.appending(path: "Events")
        let eventsURL = fileURL.appending(path: "1. Oct 11 2025")
        let event1URL = eventsURL.appending(path: "Talk1")
        try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
        let speakerYML =
        """
        - name: Johny Appleseed
          socials:
            linkedIn: https://www.linkedin.com/in/johny-appleseed-0a0123456/
            github: https://github.com/johny-appleseed
            portfolio: https://johny-appleseed.github.io
          about: Apple Engineer
          image: johnyappleseed.jpeg
        """
        let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
        try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
        
        let infoYML =
        """
        about: "Swift Ahmedabad October'25 MeetUp"
        date: "October 11, 2025"
        location:
            name: "CricHeroes Pvt. Ltd"
            map: "https://www.google.com/maps/search/?api=1&query=CricHeroes%20Pvt.%20Ltd.&query_place_id=ChIJWbxyziaFXjkRedJ8Zxm-gEk"
            address: "TF1 (3rd Floor, off Sindhu Bhavan Marg, near Avalon Hotel, Bodakdev, Ahmedabad, Gujarat 380059"
            coordinates:
                latitude: 23.0453052
                longitude: 72.5080271
                zoom: 17
        agenda:
            - time: "10:00 AM "
              title: "Welcome & Registration"
              type: "registration" 
            - time: "10:15 AM "
              title: "Talk 1"
              type: "talk"
            - time: "12:00 PM "
              title: "Networking & Refreshments"
              type: "networking"
        sponsors:
            vanue: "CricHeroes Pvt. Ltd"
            food: "CricHeroes Pvt. Ltd"
        photoURL: "https://photos.app.goo.gl/owW6Ef9U45Aj68Ha9"
        """
        let infoYMLURL = eventsURL.appending(path: "Info.yml")
        try infoYML.write(to: infoYMLURL, atomically: true, encoding: .utf8)
        
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false))
            assertInlineSnapshot(of: events, as: .customDump) {
                #"""
                Parser.EventsInfo(
                  events: [
                    [0]: Event(
                      id: "b1bf3292fb54ccb18ee3b28114e0a4bda6a83092bd1140e5af8bd411cd30917e",
                      title: "1. Oct 11 2025",
                      date: Date(2025-10-10T18:30:00.000Z)
                    )
                  ],
                  eventsWithTalks: [
                    [0]: EventWithTalks(
                      event: Event(
                        id: "b1bf3292fb54ccb18ee3b28114e0a4bda6a83092bd1140e5af8bd411cd30917e",
                        title: "1. Oct 11 2025",
                        date: Date(2025-10-10T18:30:00.000Z)
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "12db3841d095bf5f3c6c239b0da7a47ba9b1570f43b7cbdd8e81d263dcb9b2bf",
                            title: "Talk1",
                            eventID: "b1bf3292fb54ccb18ee3b28114e0a4bda6a83092bd1140e5af8bd411cd30917e"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                              name: "Johny Appleseed",
                              socials: Speaker.Socials(
                                linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                                github: "https://github.com/johny-appleseed",
                                portfolio: "https://johny-appleseed.github.io",
                                twitter: nil
                              ),
                              about: "Apple Engineer",
                              image: "johnyappleseed.jpeg"
                            )
                          ]
                        )
                      ],
                      eventInfo: EventInfo(
                        id: "02e736efadf843bf33129c630906f915bb05c1831953a9f844de7d4b190ac593",
                        eventID: "b1bf3292fb54ccb18ee3b28114e0a4bda6a83092bd1140e5af8bd411cd30917e",
                        date: Date(2025-10-10T18:30:00.000Z),
                        about: "Swift Ahmedabad October\'25 MeetUp",
                        location: EventInfo.Location(
                          name: "CricHeroes Pvt. Ltd",
                          map: URL(https://www.google.com/maps/search/?api=1&query=CricHeroes%20Pvt.%20Ltd.&query_place_id=ChIJWbxyziaFXjkRedJ8Zxm-gEk),
                          address: "TF1 (3rd Floor, off Sindhu Bhavan Marg, near Avalon Hotel, Bodakdev, Ahmedabad, Gujarat 380059",
                          coordinates: EventInfo.Location.Coordinates(
                            latitude: 23.0453052,
                            longitude: 72.5080271,
                            zoom: 17.0
                          )
                        ),
                        sponsors: Sponsors(
                          vanue: "CricHeroes Pvt. Ltd",
                          food: "CricHeroes Pvt. Ltd"
                        ),
                        photoURL: URL(https://photos.app.goo.gl/owW6Ef9U45Aj68Ha9)
                      )
                    )
                  ],
                  speakers: [
                    [0]: Speaker(
                      id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                      name: "Johny Appleseed",
                      socials: Speaker.Socials(
                        linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                        github: "https://github.com/johny-appleseed",
                        portfolio: "https://johny-appleseed.github.io",
                        twitter: nil
                      ),
                      about: "Apple Engineer",
                      image: "johnyappleseed.jpeg"
                    )
                  ],
                  talksWithSpeakers: [
                    [0]: TalkWithSpeakers(
                      talk: Talk(
                        id: "12db3841d095bf5f3c6c239b0da7a47ba9b1570f43b7cbdd8e81d263dcb9b2bf",
                        title: "Talk1",
                        eventID: "b1bf3292fb54ccb18ee3b28114e0a4bda6a83092bd1140e5af8bd411cd30917e"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                          name: "Johny Appleseed",
                          socials: Speaker.Socials(
                            linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                            github: "https://github.com/johny-appleseed",
                            portfolio: "https://johny-appleseed.github.io",
                            twitter: nil
                          ),
                          about: "Apple Engineer",
                          image: "johnyappleseed.jpeg"
                        )
                      ]
                    )
                  ],
                  talks: [
                    [0]: Talk(
                      id: "12db3841d095bf5f3c6c239b0da7a47ba9b1570f43b7cbdd8e81d263dcb9b2bf",
                      title: "Talk1",
                      eventID: "b1bf3292fb54ccb18ee3b28114e0a4bda6a83092bd1140e5af8bd411cd30917e"
                    )
                  ],
                  talkSpeakers: [
                    [0]: TalkSpeaker(
                      id: "b583b9a696ee93f2122f402aac49778fda5d41ae9e5ceeabf708e303c1082d15",
                      talkID: "12db3841d095bf5f3c6c239b0da7a47ba9b1570f43b7cbdd8e81d263dcb9b2bf",
                      speakerID: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173"
                    )
                  ],
                  eventInfos: [
                    [0]: EventInfo(
                      id: "02e736efadf843bf33129c630906f915bb05c1831953a9f844de7d4b190ac593",
                      eventID: "b1bf3292fb54ccb18ee3b28114e0a4bda6a83092bd1140e5af8bd411cd30917e",
                      date: Date(2025-10-10T18:30:00.000Z),
                      about: "Swift Ahmedabad October\'25 MeetUp",
                      location: EventInfo.Location(
                        name: "CricHeroes Pvt. Ltd",
                        map: URL(https://www.google.com/maps/search/?api=1&query=CricHeroes%20Pvt.%20Ltd.&query_place_id=ChIJWbxyziaFXjkRedJ8Zxm-gEk),
                        address: "TF1 (3rd Floor, off Sindhu Bhavan Marg, near Avalon Hotel, Bodakdev, Ahmedabad, Gujarat 380059",
                        coordinates: EventInfo.Location.Coordinates(
                          latitude: 23.0453052,
                          longitude: 72.5080271,
                          zoom: 17.0
                        )
                      ),
                      sponsors: Sponsors(
                        vanue: "CricHeroes Pvt. Ltd",
                        food: "CricHeroes Pvt. Ltd"
                      ),
                      photoURL: URL(https://photos.app.goo.gl/owW6Ef9U45Aj68Ha9)
                    )
                  ],
                  agendas: [
                    [0]: Agenda(
                      id: "6cdc33ff72be104bb5f7cfd3d3f9cc02d1d819aa8c558abcd9ceb69d931ba7a7",
                      eventID: "b1bf3292fb54ccb18ee3b28114e0a4bda6a83092bd1140e5af8bd411cd30917e",
                      time: Date(2025-10-11T04:30:00.000Z),
                      title: "Welcome & Registration",
                      speakers: nil,
                      type: .registration
                    ),
                    [1]: Agenda(
                      id: "c8f22ecd8d3f1bba32ca6c228c272374ab49b058c2b22906d4f390820c0e8133",
                      eventID: "b1bf3292fb54ccb18ee3b28114e0a4bda6a83092bd1140e5af8bd411cd30917e",
                      time: Date(2025-10-11T04:45:00.000Z),
                      title: "Talk 1",
                      speakers: nil,
                      type: .talk
                    ),
                    [2]: Agenda(
                      id: "628dbe0410aad225eb6de8a80865c840d4fb0740f0c7f74cac111b0d458d8548",
                      eventID: "b1bf3292fb54ccb18ee3b28114e0a4bda6a83092bd1140e5af8bd411cd30917e",
                      time: Date(2025-10-11T06:30:00.000Z),
                      title: "Networking & Refreshments",
                      speakers: nil,
                      type: .networking
                    )
                  ],
                  sponsors: [
                    [0]: Sponsors(
                      vanue: "CricHeroes Pvt. Ltd",
                      food: "CricHeroes Pvt. Ltd"
                    )
                  ],
                  agendaSpeakerIDs: []
                )
                """#
            }
        }
    }

}
