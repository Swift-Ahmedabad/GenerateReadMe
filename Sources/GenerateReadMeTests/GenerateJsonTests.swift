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

@Suite(.snapshots(record: .never))
struct GenerateJsonTests {
    
    @Test func generateSpeakersJson() throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        let fileURL = testURL.appending(path: "Events")
        let event1URL = fileURL.appending(path: "1. Apr 20 2025/Talk1")
        try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
        let speakerYML =
        """
        - name: Johny Appleseed
          socials:
            linkedIn: https://www.linkedin.com/in/johny-appleseed-0a0123456/
            github: https://github.com/johny-appleseed
            portfolio: https://johny-appleseed.github.io
          about: Apple Engineer
        - name: Linus Torvalds
          socials:
            linkedIn: https://www.linkedin.com/in/linus-torvalds-0a0123456/
          about: Git Inventor
        """
        let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
        try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
        
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false)).speakers
            let jsonURL = fileURL.appending(path: "speakers.json")
            try Generator.generateJson(for: events, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                #"""
                [
                  {
                    "about" : "Apple Engineer",
                    "id" : "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                    "name" : "Johny Appleseed",
                    "socials" : {
                      "github" : "https:\/\/github.com\/johny-appleseed",
                      "linkedIn" : "https:\/\/www.linkedin.com\/in\/johny-appleseed-0a0123456\/",
                      "portfolio" : "https:\/\/johny-appleseed.github.io"
                    }
                  },
                  {
                    "about" : "Git Inventor",
                    "id" : "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2",
                    "name" : "Linus Torvalds",
                    "socials" : {
                      "linkedIn" : "https:\/\/www.linkedin.com\/in\/linus-torvalds-0a0123456\/"
                    }
                  }
                ]
                """#
            }
        }
    }
    
    @Test func generateTalksJSON() throws {
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
                - name: Event\(e) Speaker \(t)
                  socials:
                    linkedIn: https://www.linkedin.com/in/speaker-0a012345\(t)/
                    github: https://github.com/speaker\(t)
                    portfolio: https://speaker-\(t).github.io
                  about: Talented Speaker-\(t)
                """
                let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
                try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
            }
        }

        try withSnapshotTesting {
            let talks = try Parser.events(from: fileURL.path(percentEncoded: false)).talks
            let jsonURL = fileURL.appending(path: "talks.json")
            try Generator.generateJson(for: talks, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                """
                [
                  {
                    "eventID" : "c1e44862c76a4a1490c26b256f6fb4baab46516a35819792dc0d3a165795f377",
                    "id" : "770d53c37b2149f72b72261dd2ae2cbdb538c7d5ff9b378b9e2ca501129b5bcd",
                    "title" : "Talk1"
                  },
                  {
                    "eventID" : "c1e44862c76a4a1490c26b256f6fb4baab46516a35819792dc0d3a165795f377",
                    "id" : "4cd4dcdb6f7af0f00b222d9206389bf415d5f223cd2bb825d4c64e2762367b51",
                    "title" : "Talk2"
                  },
                  {
                    "eventID" : "c1e44862c76a4a1490c26b256f6fb4baab46516a35819792dc0d3a165795f377",
                    "id" : "b3df59363c5c631665901aa31aeb5c0a17166de8a0b126f9d7606f8c42e69eaf",
                    "title" : "Talk3"
                  },
                  {
                    "eventID" : "3f30e30e06797c85666ed36360f4db9d819ee7b36b8ecc08891ad37d13258482",
                    "id" : "aebdbdd3ef3749e780369fef497fc11384f6a972d8e8dbe96acd2c3a66a5a849",
                    "title" : "Talk1"
                  },
                  {
                    "eventID" : "3f30e30e06797c85666ed36360f4db9d819ee7b36b8ecc08891ad37d13258482",
                    "id" : "f5423d20c986a21c919b637ed3893a3873f64c86ad942496d92b4bfeca83dc7f",
                    "title" : "Talk2"
                  },
                  {
                    "eventID" : "3f30e30e06797c85666ed36360f4db9d819ee7b36b8ecc08891ad37d13258482",
                    "id" : "25022258af4856c18556565d64851af9b76f1b7a1b11edc708ef925c6a612302",
                    "title" : "Talk3"
                  },
                  {
                    "eventID" : "839d93adee37a5de33c111b3f37ac479c5cc258aa2270220d0eda077f60b2152",
                    "id" : "2713425a8ba178ca616b8471ca72000e6ce1c83fca23e6fba4025c70427f57ac",
                    "title" : "Talk1"
                  },
                  {
                    "eventID" : "839d93adee37a5de33c111b3f37ac479c5cc258aa2270220d0eda077f60b2152",
                    "id" : "fcd6b1e0d119c486c75ca27ae9d144e6cf1486e1cfe1f66ee2f72bb56f6ca1a5",
                    "title" : "Talk2"
                  },
                  {
                    "eventID" : "839d93adee37a5de33c111b3f37ac479c5cc258aa2270220d0eda077f60b2152",
                    "id" : "e5232276be2aabf91f909d168ef5e83488c3c39ffa85665fad2391a9e0fdf3b3",
                    "title" : "Talk3"
                  }
                ]
                """
            }
        }
    }
    
    @Test func generateEventJSON() async throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }

        let fileURL = testURL.appending(path: "Events")
        for e in 1...3 {
            for t in 1...3 {
                let event1URL = fileURL.appending(path: "\(e). Oct \(e) 2025/Talk\(t)")
                try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
            }
        }
        
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false)).events
            let jsonURL = fileURL.appending(path: "events.json")
            try Generator.generateJson(for: events, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                """
                [
                  {
                    "date" : 781036200,
                    "id" : "c1e44862c76a4a1490c26b256f6fb4baab46516a35819792dc0d3a165795f377",
                    "title" : "2. Oct 2 2025"
                  },
                  {
                    "date" : 780949800,
                    "id" : "3f30e30e06797c85666ed36360f4db9d819ee7b36b8ecc08891ad37d13258482",
                    "title" : "1. Oct 1 2025"
                  },
                  {
                    "date" : 781122600,
                    "id" : "839d93adee37a5de33c111b3f37ac479c5cc258aa2270220d0eda077f60b2152",
                    "title" : "3. Oct 3 2025"
                  }
                ]
                """
            }
        }
    }
    
    @Test func generateTalkSpeakerJSON() async throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }

        let fileURL = testURL.appending(path: "Events")
        for e in 1...2 {
            for t in 1...2 {
                let event1URL = fileURL.appending(path: "\(e). Oct \(e) 2025/Talk\(t)")
                try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
                let speakerYML =
                """
                - name: Event\(e) Speaker \(t)
                  socials:
                    linkedIn: https://www.linkedin.com/in/speaker-0a012345\(t)/
                    github: https://github.com/speaker\(t)
                    portfolio: https://speaker-\(t).github.io
                  about: Talented Speaker-\(t)
                """
                let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
                try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
            }
        }
        
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false)).talkSpeakers
            let jsonURL = fileURL.appending(path: "talkspeaker.json")
            try Generator.generateJson(for: events, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                """
                [
                  {
                    "id" : "c1a446994b5dd8e6bd768bba8b9e31d4a5009661112944b61e03bd6ba1e11831",
                    "speakerID" : "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
                    "talkID" : "770d53c37b2149f72b72261dd2ae2cbdb538c7d5ff9b378b9e2ca501129b5bcd"
                  },
                  {
                    "id" : "3ddeefccf06d973252802a1a4add1b84bff45522e018fe2afc797f76ee22fa44",
                    "speakerID" : "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
                    "talkID" : "4cd4dcdb6f7af0f00b222d9206389bf415d5f223cd2bb825d4c64e2762367b51"
                  },
                  {
                    "id" : "8848df37e1a40bfd1a89598c831d1b1118f5c57a8aa2e5ca742ea955a5594c16",
                    "speakerID" : "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
                    "talkID" : "aebdbdd3ef3749e780369fef497fc11384f6a972d8e8dbe96acd2c3a66a5a849"
                  },
                  {
                    "id" : "56e25722239da72da3f433fde6d7ee7be169d24ca9c0871f8d3543d666225ffa",
                    "speakerID" : "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
                    "talkID" : "f5423d20c986a21c919b637ed3893a3873f64c86ad942496d92b4bfeca83dc7f"
                  }
                ]
                """
            }
        }
    }
    
    @Test func generateEventInfoJSON() async throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        let fileURL = testURL.appending(path: "Events")
        let eventsURL = fileURL.appending(path: "1. Apr 20 2025")
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
        - name: Linus Torvalds
          socials:
            linkedIn: https://www.linkedin.com/in/linus-torvalds-0a0123456/
          about: Git Inventor
        """
        let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
        try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
        
        let infoYML = """
        about: "Swift Ahmedabad October'25 MeetUp"
        date: "October 11, 2025"
        location:
            name: "CricHeroes Pvt. Ltd"
            map: "https://www.google.com/maps/search/?api=1&query=CricHeroes%20Pvt.%20Ltd.&query_place_id=ChIJWbxyziaFXjkRedJ8Zxm-gEk"
            address: "TF1, 3rd Floor, off Sindhu Bhavan Marg, near Avalon Hotel, Bodakdev, Ahmedabad, Gujarat 380059"
            coordinates:
                latitude: 23.0453052
                longitude: 72.5080271
                zoom: 17
        agenda:
            - time: "10:00 AM "
              title: "Welcome & Registration"
            - time: "10:15 AM "
              title: "Talk 1"
            - time: "12:00 PM "
              title: "Networking & Refreshments"
        sponsors:
            vanue: "CricHeroes Pvt. Ltd"
            food: "CricHeroes Pvt. Ltd"
        photoURL: "https://photos.app.goo.gl/owW6Ef9U45Aj68Ha9"
        """
        try infoYML.write(to: eventsURL.appending(path: "Info.yml"), atomically: true, encoding: .utf8)
        
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false)).eventInfos
            let jsonURL = fileURL.appending(path: "eventInfo.json")
            try Generator.generateJson(for: events, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                #"""
                [
                  {
                    "about" : "Swift Ahmedabad October'25 MeetUp",
                    "date" : 781813800,
                    "eventID" : "43d0662377505cff50f3294b95604f966f331fb96a2112d1b0e3985641928cf5",
                    "id" : "cb82a4aebd61ea6654c7ceca30c8a960b7d05e6788da5eb35d027f381b8d7ff4",
                    "location" : {
                      "address" : "TF1, 3rd Floor, off Sindhu Bhavan Marg, near Avalon Hotel, Bodakdev, Ahmedabad, Gujarat 380059",
                      "coordinates" : {
                        "latitude" : 23.045305200000001,
                        "longitude" : 72.508027100000007,
                        "zoom" : 17
                      },
                      "map" : "https:\/\/www.google.com\/maps\/search\/?api=1&query=CricHeroes%20Pvt.%20Ltd.&query_place_id=ChIJWbxyziaFXjkRedJ8Zxm-gEk",
                      "name" : "CricHeroes Pvt. Ltd"
                    },
                    "photoURL" : "https:\/\/photos.app.goo.gl\/owW6Ef9U45Aj68Ha9",
                    "sponsors" : {
                      "food" : "CricHeroes Pvt. Ltd",
                      "vanue" : "CricHeroes Pvt. Ltd"
                    }
                  }
                ]
                """#
            }
        }
    }
}
