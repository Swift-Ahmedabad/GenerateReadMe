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
struct Test {

    @Test
    func generateSpeakersJson() throws {
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
        - Speaker: Linus Torvalds
          Socials:
            LinkedIn: https://www.linkedin.com/in/linus-torvalds-0a0123456/
          About: Git Inventor
        """
        let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
        try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
        
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"]).speakers
            let jsonURL = fileURL.appending(path: "speakers.json")
            try Generator.generateJson(for: events, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                #"""
                [
                  {
                    "About" : "Apple Engineer",
                    "id" : "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                    "Socials" : {
                      "Github" : "https:\/\/github.com\/johny-appleseed",
                      "LinkedIn" : "https:\/\/www.linkedin.com\/in\/johny-appleseed-0a0123456\/",
                      "Portfolio" : "https:\/\/johny-appleseed.github.io"
                    },
                    "Speaker" : "Johny Appleseed"
                  },
                  {
                    "About" : "Git Inventor",
                    "id" : "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2",
                    "Socials" : {
                      "LinkedIn" : "https:\/\/www.linkedin.com\/in\/linus-torvalds-0a0123456\/"
                    },
                    "Speaker" : "Linus Torvalds"
                  }
                ]
                """#
            }
        }
    }
    
    @Test
    func generateTalksJSON() throws {
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
            let talks = try Parser.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"]).talks
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
    
    @Test
    func generateEventJSON() async throws {
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
            let events = try Parser.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"]).events
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
    
    @Test
    func generateTalkSpeakerJSON() async throws {
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
            let events = try Parser.events(from: fileURL.path(percentEncoded: false), skipFileWithExtensions: ["md", "json", "sh"]).talkSpeakers
            let jsonURL = fileURL.appending(path: "talkspeaker.json")
            try Generator.generateJson(for: events, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                """
                [
                  {
                    "id" : "c1a446994b5dd8e6bd768bba8b9e31d4a5009661112944b61e03bd6ba1e11831",
                    "speakerID" : "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
                    "talkId" : "770d53c37b2149f72b72261dd2ae2cbdb538c7d5ff9b378b9e2ca501129b5bcd"
                  },
                  {
                    "id" : "3ddeefccf06d973252802a1a4add1b84bff45522e018fe2afc797f76ee22fa44",
                    "speakerID" : "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
                    "talkId" : "4cd4dcdb6f7af0f00b222d9206389bf415d5f223cd2bb825d4c64e2762367b51"
                  },
                  {
                    "id" : "95b07990d8f8703383006a2b433d572146716d496be3badb60df65dea38e15c0",
                    "speakerID" : "5cb349f252548f6229855ad913f6d51060c43e52fc66e12c1eabb4b83737182c",
                    "talkId" : "b3df59363c5c631665901aa31aeb5c0a17166de8a0b126f9d7606f8c42e69eaf"
                  },
                  {
                    "id" : "8848df37e1a40bfd1a89598c831d1b1118f5c57a8aa2e5ca742ea955a5594c16",
                    "speakerID" : "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
                    "talkId" : "aebdbdd3ef3749e780369fef497fc11384f6a972d8e8dbe96acd2c3a66a5a849"
                  },
                  {
                    "id" : "56e25722239da72da3f433fde6d7ee7be169d24ca9c0871f8d3543d666225ffa",
                    "speakerID" : "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
                    "talkId" : "f5423d20c986a21c919b637ed3893a3873f64c86ad942496d92b4bfeca83dc7f"
                  },
                  {
                    "id" : "e3480c9616bac4da30c12116c45a8952b731c784b77c53ea05361fb7e6d4e08b",
                    "speakerID" : "992f1e3c743cbb83854592acf4b0b60529e2b8adab842ab01ad2c94be34c5d32",
                    "talkId" : "25022258af4856c18556565d64851af9b76f1b7a1b11edc708ef925c6a612302"
                  },
                  {
                    "id" : "9b02fa496a18f4b204260fa8d770bb31c597c8c47707392c9d1feb29f5c540cd",
                    "speakerID" : "0efb512fe5ae1b65c754b900a68a440ce733b440f386c30fd40f302e5f7d07b6",
                    "talkId" : "2713425a8ba178ca616b8471ca72000e6ce1c83fca23e6fba4025c70427f57ac"
                  },
                  {
                    "id" : "a2c4a44fa4db80d7fe98180323d963759fb6836457d8d8a813fd2ab30992784f",
                    "speakerID" : "dbdd5e35ea6abcf1af549739f16b1fdcdfd984ef867a14009e085cf23913c497",
                    "talkId" : "fcd6b1e0d119c486c75ca27ae9d144e6cf1486e1cfe1f66ee2f72bb56f6ca1a5"
                  },
                  {
                    "id" : "a2e35adf026bffd33d2f8836c186e27c7a010e1688ed7f51d1cba0abadeb83e8",
                    "speakerID" : "a286a248e3551b27be8d0f302f48223aedebe26279f5d4610ab695495fa1f079",
                    "talkId" : "e5232276be2aabf91f909d168ef5e83488c3c39ffa85665fad2391a9e0fdf3b3"
                  }
                ]
                """
            }
        }
    }
}
