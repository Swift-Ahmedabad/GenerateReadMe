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
                      id: "7340f1054da69dcece7839d1a6daae301ffc9de4e6ff83421d4b556966b16adb",
                      communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                      title: "1. Jan 01 2025",
                      date: Date(2024-12-31T18:30:00.000Z),
                      endDate: nil
                    )
                  ],
                  eventsWithTalks: [
                    [0]: EventWithTalks(
                      event: Event(
                        id: "7340f1054da69dcece7839d1a6daae301ffc9de4e6ff83421d4b556966b16adb",
                        communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                        title: "1. Jan 01 2025",
                        date: Date(2024-12-31T18:30:00.000Z),
                        endDate: nil
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "616514d9eca6409c2cb174097b232d6253db4f211b998d52af8e48a68aa6b6a5",
                            title: "Talk1",
                            eventID: "7340f1054da69dcece7839d1a6daae301ffc9de4e6ff83421d4b556966b16adb"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                              name: "Johny Appleseed",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                                github: "https://github.com/johny-appleseed",
                                portfolio: "https://johny-appleseed.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
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
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                        github: "https://github.com/johny-appleseed",
                        portfolio: "https://johny-appleseed.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Apple Engineer",
                      image: "johnyappleseed.jpeg"
                    )
                  ],
                  talksWithSpeakers: [
                    [0]: TalkWithSpeakers(
                      talk: Talk(
                        id: "616514d9eca6409c2cb174097b232d6253db4f211b998d52af8e48a68aa6b6a5",
                        title: "Talk1",
                        eventID: "7340f1054da69dcece7839d1a6daae301ffc9de4e6ff83421d4b556966b16adb"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                          name: "Johny Appleseed",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                            github: "https://github.com/johny-appleseed",
                            portfolio: "https://johny-appleseed.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Apple Engineer",
                          image: "johnyappleseed.jpeg"
                        )
                      ]
                    )
                  ],
                  talks: [
                    [0]: Talk(
                      id: "616514d9eca6409c2cb174097b232d6253db4f211b998d52af8e48a68aa6b6a5",
                      title: "Talk1",
                      eventID: "7340f1054da69dcece7839d1a6daae301ffc9de4e6ff83421d4b556966b16adb"
                    )
                  ],
                  talkSpeakers: [
                    [0]: TalkSpeaker(
                      id: "2b33229f8c9bcfb7eafbd2ca734647e8ee04ed61af52d4018c39ae43f0c3b9ca",
                      talkID: "616514d9eca6409c2cb174097b232d6253db4f211b998d52af8e48a68aa6b6a5",
                      speakerID: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173"
                    )
                  ],
                  eventInfos: [],
                  agendas: [],
                  sponsors: [],
                  agendaSpeakerIDs: [],
                  about: nil,
                  yearsInReview: []
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
                      id: "7340f1054da69dcece7839d1a6daae301ffc9de4e6ff83421d4b556966b16adb",
                      communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                      title: "1. Jan 01 2025",
                      date: Date(2024-12-31T18:30:00.000Z),
                      endDate: nil
                    )
                  ],
                  eventsWithTalks: [
                    [0]: EventWithTalks(
                      event: Event(
                        id: "7340f1054da69dcece7839d1a6daae301ffc9de4e6ff83421d4b556966b16adb",
                        communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                        title: "1. Jan 01 2025",
                        date: Date(2024-12-31T18:30:00.000Z),
                        endDate: nil
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "616514d9eca6409c2cb174097b232d6253db4f211b998d52af8e48a68aa6b6a5",
                            title: "Talk1",
                            eventID: "7340f1054da69dcece7839d1a6daae301ffc9de4e6ff83421d4b556966b16adb"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                              name: "Johny Appleseed",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                                github: "https://github.com/johny-appleseed",
                                portfolio: "https://johny-appleseed.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
                              ),
                              about: "Apple Engineer",
                              image: "johnyappleseed.jpeg"
                            ),
                            [1]: Speaker(
                              id: "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2",
                              name: "Linus Torvalds",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/linus-torvalds-0a0123456/",
                                github: nil,
                                portfolio: nil,
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
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
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                        github: "https://github.com/johny-appleseed",
                        portfolio: "https://johny-appleseed.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Apple Engineer",
                      image: "johnyappleseed.jpeg"
                    ),
                    [1]: Speaker(
                      id: "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2",
                      name: "Linus Torvalds",
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/linus-torvalds-0a0123456/",
                        github: nil,
                        portfolio: nil,
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Git Inventor",
                      image: "linustorwards.jpeg"
                    )
                  ],
                  talksWithSpeakers: [
                    [0]: TalkWithSpeakers(
                      talk: Talk(
                        id: "616514d9eca6409c2cb174097b232d6253db4f211b998d52af8e48a68aa6b6a5",
                        title: "Talk1",
                        eventID: "7340f1054da69dcece7839d1a6daae301ffc9de4e6ff83421d4b556966b16adb"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                          name: "Johny Appleseed",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                            github: "https://github.com/johny-appleseed",
                            portfolio: "https://johny-appleseed.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Apple Engineer",
                          image: "johnyappleseed.jpeg"
                        ),
                        [1]: Speaker(
                          id: "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2",
                          name: "Linus Torvalds",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/linus-torvalds-0a0123456/",
                            github: nil,
                            portfolio: nil,
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Git Inventor",
                          image: "linustorwards.jpeg"
                        )
                      ]
                    )
                  ],
                  talks: [
                    [0]: Talk(
                      id: "616514d9eca6409c2cb174097b232d6253db4f211b998d52af8e48a68aa6b6a5",
                      title: "Talk1",
                      eventID: "7340f1054da69dcece7839d1a6daae301ffc9de4e6ff83421d4b556966b16adb"
                    )
                  ],
                  talkSpeakers: [
                    [0]: TalkSpeaker(
                      id: "2b33229f8c9bcfb7eafbd2ca734647e8ee04ed61af52d4018c39ae43f0c3b9ca",
                      talkID: "616514d9eca6409c2cb174097b232d6253db4f211b998d52af8e48a68aa6b6a5",
                      speakerID: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173"
                    ),
                    [1]: TalkSpeaker(
                      id: "92d1843ee729781ab1174d4bef9da432af1d421bf0425a5f4d14ed703526faa2",
                      talkID: "616514d9eca6409c2cb174097b232d6253db4f211b998d52af8e48a68aa6b6a5",
                      speakerID: "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2"
                    )
                  ],
                  eventInfos: [],
                  agendas: [],
                  sponsors: [],
                  agendaSpeakerIDs: [],
                  about: nil,
                  yearsInReview: []
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
                      id: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296",
                      communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                      title: "3. Jan 3 2025",
                      date: Date(2025-01-02T18:30:00.000Z),
                      endDate: nil
                    ),
                    [1]: Event(
                      id: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8",
                      communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                      title: "1. Jan 1 2025",
                      date: Date(2024-12-31T18:30:00.000Z),
                      endDate: nil
                    ),
                    [2]: Event(
                      id: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644",
                      communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                      title: "2. Jan 2 2025",
                      date: Date(2025-01-01T18:30:00.000Z),
                      endDate: nil
                    )
                  ],
                  eventsWithTalks: [
                    [0]: EventWithTalks(
                      event: Event(
                        id: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296",
                        communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                        title: "3. Jan 3 2025",
                        date: Date(2025-01-02T18:30:00.000Z),
                        endDate: nil
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "a29c82755866f266013640a0f33b6eb4f873baeca41366196d22676ef32ce70d",
                            title: "Talk1",
                            eventID: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "0efb512fe5ae1b65c754b900a68a440ce733b440f386c30fd40f302e5f7d07b6",
                              name: "Event3 Speaker 1",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                                github: "https://github.com/speaker1",
                                portfolio: "https://speaker-1.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
                              ),
                              about: "Talented Speaker-1",
                              image: "telentedspeaker1.png"
                            )
                          ]
                        ),
                        [1]: TalkWithSpeakers(
                          talk: Talk(
                            id: "841f3d6134b7c6f18ad911eb3c36087a5e2646a73252d56c66e412f66f0012eb",
                            title: "Talk2",
                            eventID: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497",
                              name: "Event3 Speaker 2",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                                github: "https://github.com/speaker2",
                                portfolio: "https://speaker-2.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
                              ),
                              about: "Talented Speaker-2",
                              image: "telentedspeaker2.png"
                            )
                          ]
                        ),
                        [2]: TalkWithSpeakers(
                          talk: Talk(
                            id: "d21febe8d0f7a182c0f3e55e6d9a81abb123ada1f8c93196a7c0272a76ac14dc",
                            title: "Talk3",
                            eventID: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079",
                              name: "Event3 Speaker 3",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                                github: "https://github.com/speaker3",
                                portfolio: "https://speaker-3.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
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
                        id: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8",
                        communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                        title: "1. Jan 1 2025",
                        date: Date(2024-12-31T18:30:00.000Z),
                        endDate: nil
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "34d7f590459254f4716e16e43fb555fa1faee7dafc8f382c49211ef331bfd5f1",
                            title: "Talk1",
                            eventID: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
                              name: "Event1 Speaker 1",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                                github: "https://github.com/speaker1",
                                portfolio: "https://speaker-1.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
                              ),
                              about: "Talented Speaker-1",
                              image: "telentedspeaker1.png"
                            )
                          ]
                        ),
                        [1]: TalkWithSpeakers(
                          talk: Talk(
                            id: "9ffa3ca9495ce9df6c75b9e753d1218a95f9de755a27e5fb7e1632c2fa250476",
                            title: "Talk2",
                            eventID: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
                              name: "Event1 Speaker 2",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                                github: "https://github.com/speaker2",
                                portfolio: "https://speaker-2.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
                              ),
                              about: "Talented Speaker-2",
                              image: "telentedspeaker2.png"
                            )
                          ]
                        ),
                        [2]: TalkWithSpeakers(
                          talk: Talk(
                            id: "9d2aa5e2e1ad76f7609fdaf6c45a18d67c96bca57f0801aad8545aeb8f0ec85f",
                            title: "Talk3",
                            eventID: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32",
                              name: "Event1 Speaker 3",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                                github: "https://github.com/speaker3",
                                portfolio: "https://speaker-3.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
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
                        id: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644",
                        communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                        title: "2. Jan 2 2025",
                        date: Date(2025-01-01T18:30:00.000Z),
                        endDate: nil
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "8aec8b0dd4ac968d9d0940bfa707e32975fe855fa30a0629d2557cc414165bf3",
                            title: "Talk1",
                            eventID: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
                              name: "Event2 Speaker 1",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                                github: "https://github.com/speaker1",
                                portfolio: "https://speaker-1.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
                              ),
                              about: "Talented Speaker-1",
                              image: "telentedspeaker1.png"
                            )
                          ]
                        ),
                        [1]: TalkWithSpeakers(
                          talk: Talk(
                            id: "496bff9960f15017a832eb2f309060e9a4f8b75613a0449854f405ccdfeec698",
                            title: "Talk2",
                            eventID: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
                              name: "Event2 Speaker 2",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                                github: "https://github.com/speaker2",
                                portfolio: "https://speaker-2.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
                              ),
                              about: "Talented Speaker-2",
                              image: "telentedspeaker2.png"
                            )
                          ]
                        ),
                        [2]: TalkWithSpeakers(
                          talk: Talk(
                            id: "e75131120406a0dc980c07dc425adba1e42069ac03c5f0f688cb48618ebc09a0",
                            title: "Talk3",
                            eventID: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c",
                              name: "Event2 Speaker 3",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                                github: "https://github.com/speaker3",
                                portfolio: "https://speaker-3.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
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
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                        github: "https://github.com/speaker1",
                        portfolio: "https://speaker-1.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Talented Speaker-1",
                      image: "telentedspeaker1.png"
                    ),
                    [1]: Speaker(
                      id: "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497",
                      name: "Event3 Speaker 2",
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                        github: "https://github.com/speaker2",
                        portfolio: "https://speaker-2.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Talented Speaker-2",
                      image: "telentedspeaker2.png"
                    ),
                    [2]: Speaker(
                      id: "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079",
                      name: "Event3 Speaker 3",
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                        github: "https://github.com/speaker3",
                        portfolio: "https://speaker-3.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Talented Speaker-3",
                      image: "telentedspeaker3.png"
                    ),
                    [3]: Speaker(
                      id: "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
                      name: "Event1 Speaker 1",
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                        github: "https://github.com/speaker1",
                        portfolio: "https://speaker-1.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Talented Speaker-1",
                      image: "telentedspeaker1.png"
                    ),
                    [4]: Speaker(
                      id: "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
                      name: "Event1 Speaker 2",
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                        github: "https://github.com/speaker2",
                        portfolio: "https://speaker-2.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Talented Speaker-2",
                      image: "telentedspeaker2.png"
                    ),
                    [5]: Speaker(
                      id: "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32",
                      name: "Event1 Speaker 3",
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                        github: "https://github.com/speaker3",
                        portfolio: "https://speaker-3.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Talented Speaker-3",
                      image: "telentedspeaker3.png"
                    ),
                    [6]: Speaker(
                      id: "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
                      name: "Event2 Speaker 1",
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                        github: "https://github.com/speaker1",
                        portfolio: "https://speaker-1.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Talented Speaker-1",
                      image: "telentedspeaker1.png"
                    ),
                    [7]: Speaker(
                      id: "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
                      name: "Event2 Speaker 2",
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                        github: "https://github.com/speaker2",
                        portfolio: "https://speaker-2.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Talented Speaker-2",
                      image: "telentedspeaker2.png"
                    ),
                    [8]: Speaker(
                      id: "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c",
                      name: "Event2 Speaker 3",
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                        github: "https://github.com/speaker3",
                        portfolio: "https://speaker-3.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Talented Speaker-3",
                      image: "telentedspeaker3.png"
                    )
                  ],
                  talksWithSpeakers: [
                    [0]: TalkWithSpeakers(
                      talk: Talk(
                        id: "a29c82755866f266013640a0f33b6eb4f873baeca41366196d22676ef32ce70d",
                        title: "Talk1",
                        eventID: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "0efb512fe5ae1b65c754b900a68a440ce733b440f386c30fd40f302e5f7d07b6",
                          name: "Event3 Speaker 1",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                            github: "https://github.com/speaker1",
                            portfolio: "https://speaker-1.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Talented Speaker-1",
                          image: "telentedspeaker1.png"
                        )
                      ]
                    ),
                    [1]: TalkWithSpeakers(
                      talk: Talk(
                        id: "841f3d6134b7c6f18ad911eb3c36087a5e2646a73252d56c66e412f66f0012eb",
                        title: "Talk2",
                        eventID: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497",
                          name: "Event3 Speaker 2",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                            github: "https://github.com/speaker2",
                            portfolio: "https://speaker-2.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Talented Speaker-2",
                          image: "telentedspeaker2.png"
                        )
                      ]
                    ),
                    [2]: TalkWithSpeakers(
                      talk: Talk(
                        id: "d21febe8d0f7a182c0f3e55e6d9a81abb123ada1f8c93196a7c0272a76ac14dc",
                        title: "Talk3",
                        eventID: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079",
                          name: "Event3 Speaker 3",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                            github: "https://github.com/speaker3",
                            portfolio: "https://speaker-3.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Talented Speaker-3",
                          image: "telentedspeaker3.png"
                        )
                      ]
                    ),
                    [3]: TalkWithSpeakers(
                      talk: Talk(
                        id: "34d7f590459254f4716e16e43fb555fa1faee7dafc8f382c49211ef331bfd5f1",
                        title: "Talk1",
                        eventID: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
                          name: "Event1 Speaker 1",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                            github: "https://github.com/speaker1",
                            portfolio: "https://speaker-1.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Talented Speaker-1",
                          image: "telentedspeaker1.png"
                        )
                      ]
                    ),
                    [4]: TalkWithSpeakers(
                      talk: Talk(
                        id: "9ffa3ca9495ce9df6c75b9e753d1218a95f9de755a27e5fb7e1632c2fa250476",
                        title: "Talk2",
                        eventID: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
                          name: "Event1 Speaker 2",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                            github: "https://github.com/speaker2",
                            portfolio: "https://speaker-2.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Talented Speaker-2",
                          image: "telentedspeaker2.png"
                        )
                      ]
                    ),
                    [5]: TalkWithSpeakers(
                      talk: Talk(
                        id: "9d2aa5e2e1ad76f7609fdaf6c45a18d67c96bca57f0801aad8545aeb8f0ec85f",
                        title: "Talk3",
                        eventID: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32",
                          name: "Event1 Speaker 3",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                            github: "https://github.com/speaker3",
                            portfolio: "https://speaker-3.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Talented Speaker-3",
                          image: "telentedspeaker3.png"
                        )
                      ]
                    ),
                    [6]: TalkWithSpeakers(
                      talk: Talk(
                        id: "8aec8b0dd4ac968d9d0940bfa707e32975fe855fa30a0629d2557cc414165bf3",
                        title: "Talk1",
                        eventID: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
                          name: "Event2 Speaker 1",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123451/",
                            github: "https://github.com/speaker1",
                            portfolio: "https://speaker-1.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Talented Speaker-1",
                          image: "telentedspeaker1.png"
                        )
                      ]
                    ),
                    [7]: TalkWithSpeakers(
                      talk: Talk(
                        id: "496bff9960f15017a832eb2f309060e9a4f8b75613a0449854f405ccdfeec698",
                        title: "Talk2",
                        eventID: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
                          name: "Event2 Speaker 2",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123452/",
                            github: "https://github.com/speaker2",
                            portfolio: "https://speaker-2.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Talented Speaker-2",
                          image: "telentedspeaker2.png"
                        )
                      ]
                    ),
                    [8]: TalkWithSpeakers(
                      talk: Talk(
                        id: "e75131120406a0dc980c07dc425adba1e42069ac03c5f0f688cb48618ebc09a0",
                        title: "Talk3",
                        eventID: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c",
                          name: "Event2 Speaker 3",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/speaker-0a0123453/",
                            github: "https://github.com/speaker3",
                            portfolio: "https://speaker-3.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Talented Speaker-3",
                          image: "telentedspeaker3.png"
                        )
                      ]
                    )
                  ],
                  talks: [
                    [0]: Talk(
                      id: "a29c82755866f266013640a0f33b6eb4f873baeca41366196d22676ef32ce70d",
                      title: "Talk1",
                      eventID: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296"
                    ),
                    [1]: Talk(
                      id: "841f3d6134b7c6f18ad911eb3c36087a5e2646a73252d56c66e412f66f0012eb",
                      title: "Talk2",
                      eventID: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296"
                    ),
                    [2]: Talk(
                      id: "d21febe8d0f7a182c0f3e55e6d9a81abb123ada1f8c93196a7c0272a76ac14dc",
                      title: "Talk3",
                      eventID: "902e186af620b70860184149a7ec703eb2781b12351f2caa8e259d7092d3e296"
                    ),
                    [3]: Talk(
                      id: "34d7f590459254f4716e16e43fb555fa1faee7dafc8f382c49211ef331bfd5f1",
                      title: "Talk1",
                      eventID: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8"
                    ),
                    [4]: Talk(
                      id: "9ffa3ca9495ce9df6c75b9e753d1218a95f9de755a27e5fb7e1632c2fa250476",
                      title: "Talk2",
                      eventID: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8"
                    ),
                    [5]: Talk(
                      id: "9d2aa5e2e1ad76f7609fdaf6c45a18d67c96bca57f0801aad8545aeb8f0ec85f",
                      title: "Talk3",
                      eventID: "c0745690e6dfd4b35ae29565e18cf8a51ba76eb4849834fdaceb994200818bd8"
                    ),
                    [6]: Talk(
                      id: "8aec8b0dd4ac968d9d0940bfa707e32975fe855fa30a0629d2557cc414165bf3",
                      title: "Talk1",
                      eventID: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644"
                    ),
                    [7]: Talk(
                      id: "496bff9960f15017a832eb2f309060e9a4f8b75613a0449854f405ccdfeec698",
                      title: "Talk2",
                      eventID: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644"
                    ),
                    [8]: Talk(
                      id: "e75131120406a0dc980c07dc425adba1e42069ac03c5f0f688cb48618ebc09a0",
                      title: "Talk3",
                      eventID: "c80a6177af039821af50a83804afa7ecceed7425912b043b62c3048a93443644"
                    )
                  ],
                  talkSpeakers: [
                    [0]: TalkSpeaker(
                      id: "754a57ee493805460f31cdeeab2da05d38d720a865c4972dcd23726dd00a512e",
                      talkID: "a29c82755866f266013640a0f33b6eb4f873baeca41366196d22676ef32ce70d",
                      speakerID: "0efb512fe5ae1b65c754b900a68a440ce733b440f386c30fd40f302e5f7d07b6"
                    ),
                    [1]: TalkSpeaker(
                      id: "27a1eb21cd4cab8c1a6feff5accf266406d20aa849620ebfff209e64e6394384",
                      talkID: "841f3d6134b7c6f18ad911eb3c36087a5e2646a73252d56c66e412f66f0012eb",
                      speakerID: "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497"
                    ),
                    [2]: TalkSpeaker(
                      id: "3f9a91ba67b1b08ca8cd6032b62d80691a1d547cef8f12c15f90bfed236f87c9",
                      talkID: "d21febe8d0f7a182c0f3e55e6d9a81abb123ada1f8c93196a7c0272a76ac14dc",
                      speakerID: "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079"
                    ),
                    [3]: TalkSpeaker(
                      id: "9cdfd5a27a49c32ab91ca7c7ca7d7b4efbbb994c9d590afacda207534f05bc84",
                      talkID: "34d7f590459254f4716e16e43fb555fa1faee7dafc8f382c49211ef331bfd5f1",
                      speakerID: "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f"
                    ),
                    [4]: TalkSpeaker(
                      id: "892783198b6f4c5cfdbbd36e6ccc290ef2fa610c87022cf55baf66afdc574884",
                      talkID: "9ffa3ca9495ce9df6c75b9e753d1218a95f9de755a27e5fb7e1632c2fa250476",
                      speakerID: "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3"
                    ),
                    [5]: TalkSpeaker(
                      id: "879c54a57f1b92792165c33849fb526a2135985d628b8538d2d702f7fc97d864",
                      talkID: "9d2aa5e2e1ad76f7609fdaf6c45a18d67c96bca57f0801aad8545aeb8f0ec85f",
                      speakerID: "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32"
                    ),
                    [6]: TalkSpeaker(
                      id: "5141d8268868ca29ad297b761126dbdca0b1447a40d0f11d88eded8819d1e992",
                      talkID: "8aec8b0dd4ac968d9d0940bfa707e32975fe855fa30a0629d2557cc414165bf3",
                      speakerID: "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d"
                    ),
                    [7]: TalkSpeaker(
                      id: "8b1e944ccd9a0c5c9b5f8c9aee349ce2e109006fff05ef03a5f5b79f966db64d",
                      talkID: "496bff9960f15017a832eb2f309060e9a4f8b75613a0449854f405ccdfeec698",
                      speakerID: "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52"
                    ),
                    [8]: TalkSpeaker(
                      id: "f0fe9a58e505b5d29bbc86006ebc44c56569405a9e914f67cf722b693d4c8ca1",
                      talkID: "e75131120406a0dc980c07dc425adba1e42069ac03c5f0f688cb48618ebc09a0",
                      speakerID: "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c"
                    )
                  ],
                  eventInfos: [],
                  agendas: [],
                  sponsors: [],
                  agendaSpeakerIDs: [],
                  about: nil,
                  yearsInReview: []
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
            vanue:
                name: "CricHeroes Pvt. Ltd"
                website: "https://cricheroes.com"
                image: "cricheros.jpeg"
            food:
                name: "CricHeroes Pvt. Ltd"
                website: "https://cricheroes.com"
                image: "cricheros.jpeg"
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
                      id: "093283eeb7991c0865e81450de61e0b25858d62dc21bbf32b23aa7d56fc143fa",
                      communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                      title: "1. Oct 11 2025",
                      date: Date(2025-10-10T18:30:00.000Z),
                      endDate: Date(2025-10-11T07:00:00.000Z)
                    )
                  ],
                  eventsWithTalks: [
                    [0]: EventWithTalks(
                      event: Event(
                        id: "093283eeb7991c0865e81450de61e0b25858d62dc21bbf32b23aa7d56fc143fa",
                        communityID: "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                        title: "1. Oct 11 2025",
                        date: Date(2025-10-10T18:30:00.000Z),
                        endDate: Date(2025-10-11T07:00:00.000Z)
                      ),
                      talks: [
                        [0]: TalkWithSpeakers(
                          talk: Talk(
                            id: "4d96680d0395a7d04644a4a509cc6d2d4ac093f3c8514263bbc11ebd489f1a3b",
                            title: "Talk1",
                            eventID: "093283eeb7991c0865e81450de61e0b25858d62dc21bbf32b23aa7d56fc143fa"
                          ),
                          speakers: [
                            [0]: Speaker(
                              id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                              name: "Johny Appleseed",
                              socials: Socials(
                                linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                                github: "https://github.com/johny-appleseed",
                                portfolio: "https://johny-appleseed.github.io",
                                twitter: nil,
                                luma: nil,
                                whatsApp: nil,
                                instagram: nil,
                                arattai: nil,
                                discord: nil
                              ),
                              about: "Apple Engineer",
                              image: "johnyappleseed.jpeg"
                            )
                          ]
                        )
                      ],
                      eventInfo: EventInfo(
                        id: "06a9758bca6a7e50c0a18be631bdf9642f0ac47a01d4d217319a4df2325f0343",
                        eventID: "093283eeb7991c0865e81450de61e0b25858d62dc21bbf32b23aa7d56fc143fa",
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
                          vanue: Sponsor(
                            id: "c7f1f50db329ea7bd00cf49711f6637dfc75f86fff344b425353319b561e0461",
                            name: "CricHeroes Pvt. Ltd",
                            website: URL(https://cricheroes.com),
                            image: "cricheros.jpeg"
                          ),
                          food: Sponsor(
                            id: "c7f1f50db329ea7bd00cf49711f6637dfc75f86fff344b425353319b561e0461",
                            name: "CricHeroes Pvt. Ltd",
                            website: URL(https://cricheroes.com),
                            image: "cricheros.jpeg"
                          )
                        ),
                        photoURL: URL(https://photos.app.goo.gl/owW6Ef9U45Aj68Ha9)
                      )
                    )
                  ],
                  speakers: [
                    [0]: Speaker(
                      id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                      name: "Johny Appleseed",
                      socials: Socials(
                        linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                        github: "https://github.com/johny-appleseed",
                        portfolio: "https://johny-appleseed.github.io",
                        twitter: nil,
                        luma: nil,
                        whatsApp: nil,
                        instagram: nil,
                        arattai: nil,
                        discord: nil
                      ),
                      about: "Apple Engineer",
                      image: "johnyappleseed.jpeg"
                    )
                  ],
                  talksWithSpeakers: [
                    [0]: TalkWithSpeakers(
                      talk: Talk(
                        id: "4d96680d0395a7d04644a4a509cc6d2d4ac093f3c8514263bbc11ebd489f1a3b",
                        title: "Talk1",
                        eventID: "093283eeb7991c0865e81450de61e0b25858d62dc21bbf32b23aa7d56fc143fa"
                      ),
                      speakers: [
                        [0]: Speaker(
                          id: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                          name: "Johny Appleseed",
                          socials: Socials(
                            linkedIn: "https://www.linkedin.com/in/johny-appleseed-0a0123456/",
                            github: "https://github.com/johny-appleseed",
                            portfolio: "https://johny-appleseed.github.io",
                            twitter: nil,
                            luma: nil,
                            whatsApp: nil,
                            instagram: nil,
                            arattai: nil,
                            discord: nil
                          ),
                          about: "Apple Engineer",
                          image: "johnyappleseed.jpeg"
                        )
                      ]
                    )
                  ],
                  talks: [
                    [0]: Talk(
                      id: "4d96680d0395a7d04644a4a509cc6d2d4ac093f3c8514263bbc11ebd489f1a3b",
                      title: "Talk1",
                      eventID: "093283eeb7991c0865e81450de61e0b25858d62dc21bbf32b23aa7d56fc143fa"
                    )
                  ],
                  talkSpeakers: [
                    [0]: TalkSpeaker(
                      id: "b5eb91356b4559fc20ad868249830d0db940102a81b140c32a71b79b1baf10e2",
                      talkID: "4d96680d0395a7d04644a4a509cc6d2d4ac093f3c8514263bbc11ebd489f1a3b",
                      speakerID: "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173"
                    )
                  ],
                  eventInfos: [
                    [0]: EventInfo(
                      id: "06a9758bca6a7e50c0a18be631bdf9642f0ac47a01d4d217319a4df2325f0343",
                      eventID: "093283eeb7991c0865e81450de61e0b25858d62dc21bbf32b23aa7d56fc143fa",
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
                        vanue: Sponsor(
                          id: "c7f1f50db329ea7bd00cf49711f6637dfc75f86fff344b425353319b561e0461",
                          name: "CricHeroes Pvt. Ltd",
                          website: URL(https://cricheroes.com),
                          image: "cricheros.jpeg"
                        ),
                        food: Sponsor(
                          id: "c7f1f50db329ea7bd00cf49711f6637dfc75f86fff344b425353319b561e0461",
                          name: "CricHeroes Pvt. Ltd",
                          website: URL(https://cricheroes.com),
                          image: "cricheros.jpeg"
                        )
                      ),
                      photoURL: URL(https://photos.app.goo.gl/owW6Ef9U45Aj68Ha9)
                    )
                  ],
                  agendas: [
                    [0]: Agenda(
                      id: "42b524ad9d902431bb863f47c400dd3d562c3303e4341aa1018e90b496138e1a",
                      eventID: "093283eeb7991c0865e81450de61e0b25858d62dc21bbf32b23aa7d56fc143fa",
                      time: Date(2025-10-11T04:30:00.000Z),
                      title: "Welcome & Registration",
                      speakers: nil,
                      type: .registration
                    ),
                    [1]: Agenda(
                      id: "4f08b22a10acaba28e2d23a7cb9699189af962c794944498959ed6df09944168",
                      eventID: "093283eeb7991c0865e81450de61e0b25858d62dc21bbf32b23aa7d56fc143fa",
                      time: Date(2025-10-11T04:45:00.000Z),
                      title: "Talk 1",
                      speakers: nil,
                      type: .talk
                    ),
                    [2]: Agenda(
                      id: "cfe01f27bf95d759947ff4a038215a2ea1e8715d168178d0af7b715139233125",
                      eventID: "093283eeb7991c0865e81450de61e0b25858d62dc21bbf32b23aa7d56fc143fa",
                      time: Date(2025-10-11T06:30:00.000Z),
                      title: "Networking & Refreshments",
                      speakers: nil,
                      type: .networking
                    )
                  ],
                  sponsors: [
                    [0]: Sponsor(
                      id: "c7f1f50db329ea7bd00cf49711f6637dfc75f86fff344b425353319b561e0461",
                      name: "CricHeroes Pvt. Ltd",
                      website: URL(https://cricheroes.com),
                      image: "cricheros.jpeg"
                    )
                  ],
                  agendaSpeakerIDs: [],
                  about: nil,
                  yearsInReview: []
                )
                """#
            }
        }
    }

}
