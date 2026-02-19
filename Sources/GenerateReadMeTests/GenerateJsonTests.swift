//
//  Test.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation
import Dependencies
@testable import GenerateReadMe
import InlineSnapshotTesting
import Models
import SnapshotTestingCustomDump
@preconcurrency import SnapshotTesting
import Testing

@Suite(.snapshots(record: .failed))
struct GenerateJsonTests {
    
    @Test func generateSpeakersJson() throws {
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
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
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
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
                    "eventID" : "a3cea0c3a4c47fe312396afb2556cdbc0cb9d81d7bea98c1a86e6506d6cca731",
                    "id" : "fb555b18bf8cddaf152e893eb73865a583e141b7c2aa276a7fa2bacb0440a0b6",
                    "title" : "Talk1"
                  },
                  {
                    "eventID" : "a3cea0c3a4c47fe312396afb2556cdbc0cb9d81d7bea98c1a86e6506d6cca731",
                    "id" : "8ee3d10b590ae835579bbe56fc9dea5e97095b843e56bdf40dfea0b546c1e59c",
                    "title" : "Talk2"
                  },
                  {
                    "eventID" : "a3cea0c3a4c47fe312396afb2556cdbc0cb9d81d7bea98c1a86e6506d6cca731",
                    "id" : "0038931d01012a67efe9ab5ae7cb1c4cd97d811bd0b8a25d43eec2ee712d3f98",
                    "title" : "Talk3"
                  },
                  {
                    "eventID" : "4c4675df7f5a4965c0a68da6a0b0d26f18fc1d3fa434573482fd6a326e739c26",
                    "id" : "4f141532d5297eb3e49f5da219c9bfb2e6e0821f4951b0feb1a9a3bf56d233a0",
                    "title" : "Talk1"
                  },
                  {
                    "eventID" : "4c4675df7f5a4965c0a68da6a0b0d26f18fc1d3fa434573482fd6a326e739c26",
                    "id" : "9653f38cdb493a3eba82c8f69d202be1e67ab0fa25782b018b0012ef55405a97",
                    "title" : "Talk2"
                  },
                  {
                    "eventID" : "4c4675df7f5a4965c0a68da6a0b0d26f18fc1d3fa434573482fd6a326e739c26",
                    "id" : "c3532ae9eac3e28a9959496a8c9f61b12d2662d4d34828a62ad39700e5e304b4",
                    "title" : "Talk3"
                  },
                  {
                    "eventID" : "a5cc45431b27e8582387eed4734f4a84e416b435d8298fcf62dd913d429b8417",
                    "id" : "60bf4f7686264eeb2c20ac78ec8b505e6d082807f136dd6782ee171773133e22",
                    "title" : "Talk1"
                  },
                  {
                    "eventID" : "a5cc45431b27e8582387eed4734f4a84e416b435d8298fcf62dd913d429b8417",
                    "id" : "3704ef5497f84d27b2811ed66f9ab3e2ea3df46d89029739b1a300112dcadc2e",
                    "title" : "Talk2"
                  },
                  {
                    "eventID" : "a5cc45431b27e8582387eed4734f4a84e416b435d8298fcf62dd913d429b8417",
                    "id" : "cf9624bf5159c1ed7f1cf4d2d123c1d615bbe463fc6fad8635bb1e81d1ceaef4",
                    "title" : "Talk3"
                  }
                ]
                """
            }
        }
    }
    
    @Test func generateEventJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
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
                    "communityID" : "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                    "date" : 781036200,
                    "id" : "a3cea0c3a4c47fe312396afb2556cdbc0cb9d81d7bea98c1a86e6506d6cca731",
                    "title" : "2. Oct 2 2025"
                  },
                  {
                    "communityID" : "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                    "date" : 780949800,
                    "id" : "4c4675df7f5a4965c0a68da6a0b0d26f18fc1d3fa434573482fd6a326e739c26",
                    "title" : "1. Oct 1 2025"
                  },
                  {
                    "communityID" : "298dd7c15c671332526dcc22c0d64d73aa377cb75ff0034ec6efd854b7404239",
                    "date" : 781122600,
                    "id" : "a5cc45431b27e8582387eed4734f4a84e416b435d8298fcf62dd913d429b8417",
                    "title" : "3. Oct 3 2025"
                  }
                ]
                """
            }
        }
    }
    
    @Test func generateTalkSpeakerJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
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
                    "id" : "ad0b9d72f1bd62f0110f63c0d13859e75d7505c58ee10ebf2e0f9c928268bb4a",
                    "speakerID" : "2e69dac55eedc33f8eaf01f1b592c1acecf7798f400f7f1771c18a430258876d",
                    "talkID" : "fb555b18bf8cddaf152e893eb73865a583e141b7c2aa276a7fa2bacb0440a0b6"
                  },
                  {
                    "id" : "8b685cbb7297bd745c6dc1b09a545813265cab751f9e266ad06e8bcd7e2a3373",
                    "speakerID" : "54756dba2fffffd2a967cfed5f73424859dd772e089ebe52560f87eef5aeca52",
                    "talkID" : "8ee3d10b590ae835579bbe56fc9dea5e97095b843e56bdf40dfea0b546c1e59c"
                  },
                  {
                    "id" : "eb5fe0bc5fe46071aab312fb7279aaafb516addb1546325a947aeb858929fcdb",
                    "speakerID" : "10b030d02583beb3b6da9f3c5f782c2c04624f30a17c3d95966403814a22333f",
                    "talkID" : "4f141532d5297eb3e49f5da219c9bfb2e6e0821f4951b0feb1a9a3bf56d233a0"
                  },
                  {
                    "id" : "6fd3f57cf5174b352e0ad1088fda8a0fc7e58b4f469795f2c1626290bac2319b",
                    "speakerID" : "c6052a7af0fe75697260d9e133e03d3e6b1c551f3c1893204fd74747697ce3e3",
                    "talkID" : "9653f38cdb493a3eba82c8f69d202be1e67ab0fa25782b018b0012ef55405a97"
                  }
                ]
                """
            }
        }
    }
    
    @Test func generateEventInfoJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
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
                    "eventID" : "7cc91fdbd6f15b4fc352ab9829520b1acba1ec7816d3cc0577f9adca62223428",
                    "id" : "240e59983169d9d0881353201be0018f92540f3e78ba642ccc805c479ef28b06",
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
                      "foodSponsorID" : "c7f1f50db329ea7bd00cf49711f6637dfc75f86fff344b425353319b561e0461",
                      "vanueSponsorID" : "c7f1f50db329ea7bd00cf49711f6637dfc75f86fff344b425353319b561e0461"
                    }
                  }
                ]
                """#
            }
        }
    }
    
    @Test func generateAgendaSpeakerIDsJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
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
              type: "registration"
            - time: "10:15 AM "
              title: "Talk 1"
              type: "talk" 
              speakers:
                - "Johny Appleseed"
            - time: "11:15 AM"
              title: "Talk 2"
              type: "talk"
              speakers: 
                - "Linus Torvalds"
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
        try infoYML.write(to: eventsURL.appending(path: "Info.yml"), atomically: true, encoding: .utf8)
        
        try withSnapshotTesting {
            let events = try Parser.events(from: fileURL.path(percentEncoded: false)).agendaSpeakerIDs
            let jsonURL = fileURL.appending(path: "agendaSpeakerIds.json")
            try Generator.generateJson(for: events, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                """
                [
                  {
                    "agendaID" : "1df48613e9eb39742e4b4524e8ec74520fafabe15cc978234914a2f16dc18e4a",
                    "id" : "ece899494971d9b2398c27fd62961e3573c9c4ef20a09d6561fb42d71fb0b555",
                    "speakerID" : "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173"
                  },
                  {
                    "agendaID" : "c1f71b40e9394006e96175a366f64982fe24926029f8ddfee5b4e2b31b0ed8b7",
                    "id" : "37f9d523de4e1ee84c7fd2fb2c92d0834ff3749a40b7769e953439fbe11d0813",
                    "speakerID" : "2ba4ec6ac4ff4c5b40da6d70c7d8053de6a2a7f07871fc59a489108de32486b2"
                  }
                ]
                """
            }
        }
    }
    
    @Test func generateAboutJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        let fileURL = testURL.appending(path: "Events")
        let aboutURL = fileURL.appending(path: ".about")
        try FileManager.default.createDirectory(at: aboutURL, withIntermediateDirectories: true)
        try """
        name: "Swift Ahmedabad"
        description: "A welcoming space where everyone who is interested in Swift or Apple Ecosystem can connect and grow together."
        logo: "swift-ahmedabad-logo.png"
        members:
            - name: "Devanshi Modha"
              about: "Software Engineer (iOS) | Women Techmakers Ambassador | Tech Evangelist"
              socials:
                linkedIn: "https://www.linkedin.com/in/devanshimodha/"
            - name: "Bhavin Vaghela"
              about: "Sr iOS DEVELOPER & Assistant project manager at Hyperlink Infosystem"
              socials:
                linkedIn: "https://www.linkedin.com/in/bhavin-vaghela/"
            - name: "Kajal Seth"
              about: "Software Engineer"
              socials:
                linkedIn: "https://www.linkedin.com/in/kajal-sheth/"
            - name: "Ratnesh Jain"
              about: "Sr. iOS Engineer"
              socials:
                linkedIn: "https://www.linkedin.com/in/ratnesh-jain-7a2270146/"
            - name: "Riya Kheskwani"
              about: "Software Engineer | iOS Developer"
              socials: 
                linkedIn: "https://www.linkedin.com/in/riya-kheskwani-21b168136/"
            - name: "Jinkal Hirani"
              about: "iOS Developer"
              socials: 
                linkedIn: "https://www.linkedin.com/in/jinkalhirani/"
            - name: "Priyanka Poojara"
              about: "Helping Startups & Entrepreneurs Build Innovative Mobile Apps | SwiftUI, Combine, AI & Web3 | Mobile App Consultant | Blockchain & NFT Innovator | Digital Marketing Strategist | Let’s Build the Future"
              socials:
                linkedIn: "https://www.linkedin.com/in/priyanka-poojara/"
        socialMedias:
            linkedIn: "https://www.linkedin.com/company/103221799/admin/dashboard/"
            luma: "https://luma.com/user/swiftahmedabad"
            twitter: "https://x.com/swift_ahmedabad"
            whatsApp: "https://chat.whatsapp.com/FlZuWzMf8ak8C8yAmfRRVf"
            instagram: "https://www.instagram.com/swift.ahmedabad/"
            arattai: "https://web.arattai.in/@swift_ahmedabad"
            discord: "https://discord.com/invite/pswxUQxEny"
        """
            .data(using: .utf8)!.write(to: aboutURL.appending(path: "About.yaml"))
        
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
                
        try withSnapshotTesting {
            let about = try Parser.events(from: fileURL.path(percentEncoded: false)).about
            let jsonURL = fileURL.appending(path: "agendaSpeakerIds.json")
            try Generator.generateJson(for: about, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                #"""
                {
                  "description" : "A welcoming space where everyone who is interested in Swift or Apple Ecosystem can connect and grow together.",
                  "id" : "af6eae965cda4357726fed771504a26fe6ceaed52bf0e3e81dffd409925bb735",
                  "logo" : "swift-ahmedabad-logo.png",
                  "members" : [
                    {
                      "about" : "Software Engineer (iOS) | Women Techmakers Ambassador | Tech Evangelist",
                      "name" : "Devanshi Modha",
                      "socials" : {
                        "linkedIn" : "https:\/\/www.linkedin.com\/in\/devanshimodha\/"
                      }
                    },
                    {
                      "about" : "Sr iOS DEVELOPER & Assistant project manager at Hyperlink Infosystem",
                      "name" : "Bhavin Vaghela",
                      "socials" : {
                        "linkedIn" : "https:\/\/www.linkedin.com\/in\/bhavin-vaghela\/"
                      }
                    },
                    {
                      "about" : "Software Engineer",
                      "name" : "Kajal Seth",
                      "socials" : {
                        "linkedIn" : "https:\/\/www.linkedin.com\/in\/kajal-sheth\/"
                      }
                    },
                    {
                      "about" : "Sr. iOS Engineer",
                      "name" : "Ratnesh Jain",
                      "socials" : {
                        "linkedIn" : "https:\/\/www.linkedin.com\/in\/ratnesh-jain-7a2270146\/"
                      }
                    },
                    {
                      "about" : "Software Engineer | iOS Developer",
                      "name" : "Riya Kheskwani",
                      "socials" : {
                        "linkedIn" : "https:\/\/www.linkedin.com\/in\/riya-kheskwani-21b168136\/"
                      }
                    },
                    {
                      "about" : "iOS Developer",
                      "name" : "Jinkal Hirani",
                      "socials" : {
                        "linkedIn" : "https:\/\/www.linkedin.com\/in\/jinkalhirani\/"
                      }
                    },
                    {
                      "about" : "Helping Startups & Entrepreneurs Build Innovative Mobile Apps | SwiftUI, Combine, AI & Web3 | Mobile App Consultant | Blockchain & NFT Innovator | Digital Marketing Strategist | Let’s Build the Future",
                      "name" : "Priyanka Poojara",
                      "socials" : {
                        "linkedIn" : "https:\/\/www.linkedin.com\/in\/priyanka-poojara\/"
                      }
                    }
                  ],
                  "name" : "Swift Ahmedabad",
                  "socialMedias" : {
                    "arattai" : "https:\/\/web.arattai.in\/@swift_ahmedabad",
                    "discord" : "https:\/\/discord.com\/invite\/pswxUQxEny",
                    "instagram" : "https:\/\/www.instagram.com\/swift.ahmedabad\/",
                    "linkedIn" : "https:\/\/www.linkedin.com\/company\/103221799\/admin\/dashboard\/",
                    "luma" : "https:\/\/luma.com\/user\/swiftahmedabad",
                    "twitter" : "https:\/\/x.com\/swift_ahmedabad",
                    "whatsApp" : "https:\/\/chat.whatsapp.com\/FlZuWzMf8ak8C8yAmfRRVf"
                  }
                }
                """#
            }
        }
    }
    
    @Test func generatePodcastSourceJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        let fileURL = testURL.appending(path: "Events")
        let aboutURL = fileURL.appending(path: ".podcastSource")
        try FileManager.default.createDirectory(at: aboutURL, withIntermediateDirectories: true)
        try """
        podcasts:
            - id: "281777685"
              name: "Core Intuition"
            - id: "1730260283"
              name: "Swift Academy The Podcast"
            - id: "1227872143"
              name: "AppStories"
            - id: "1331816080"
              name: "9to5Mac Daily"
        """
            .data(using: .utf8)!.write(to: aboutURL.appending(path: "PodcastSource.yml"))
        
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
                
        try withSnapshotTesting {
            let podcasts = try Parser.parseNewsItems(at: fileURL.path(percentEncoded: false)).podcasts
            let jsonURL = fileURL.appending(path: "podcastSource.json")
            try Generator.generateJson(for: podcasts, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                """
                [
                  {
                    "id" : "281777685",
                    "name" : "Core Intuition"
                  },
                  {
                    "id" : "1730260283",
                    "name" : "Swift Academy The Podcast"
                  },
                  {
                    "id" : "1227872143",
                    "name" : "AppStories"
                  },
                  {
                    "id" : "1331816080",
                    "name" : "9to5Mac Daily"
                  }
                ]
                """
            }
        }
    }
    
    @Test func generateUpdatedAtJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
        try FileManager.default.createDirectory(at: testURL, withIntermediateDirectories: true)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        try withDependencies {
            $0.date.now = Date(timeIntervalSince1970: 1234567890)
        } operation: {
            @Dependency(\.date) var date
            let updatedAt = UpdatedAt(date: date.now)
            let url = testURL.appending(path: "lastUpdatedAt.json")
            do {
                try Generator.generateJson(for: updatedAt, at: url)
            } catch {
                print(error)
                throw error
            }
            
            withSnapshotTesting {
                assertInlineSnapshot(of: url, as: .jsonURLContent) {
                    """
                    {
                      "date" : 256260690
                    }
                    """
                }
            }
        }
    }
    
    @Test func generateNewsSourceJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        let fileURL = testURL.appending(path: "Events")
        let newsSourceURL = fileURL.appending(path: ".newsSource")
        try FileManager.default.createDirectory(at: newsSourceURL, withIntermediateDirectories: true)
        let newsYMLURL = newsSourceURL.appending(path: "NewsSource.yml")
        try """
        - title: "The.Swift.Dev."
          url: "https://theswiftdev.com/rss.xml"
          
        - title: "OhMySwift"
          url: "https://ohmyswift.com/blog/feed.xml"
          
        - title: "Swift Tool Kit"
          url: "https://www.swifttoolkit.dev/feed.rss"
        """
        .data(using: .utf8)?.write(to: newsYMLURL)
        
        try withSnapshotTesting {
            let newsSources = try Parser.parseNewsItems(at: fileURL.path(percentEncoded: false)).newsSources
            let jsonURL = fileURL.appending(path: "newsSource.json")
            try Generator.generateJson(for: newsSources, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                #"""
                [
                  {
                    "id" : "3b806bee1754b7a2896a721ed9bc4f4ed6141b6eac46af244a7a0063c3b2c898",
                    "title" : "The.Swift.Dev.",
                    "url" : "https:\/\/theswiftdev.com\/rss.xml"
                  },
                  {
                    "id" : "83bb8ed52101a4a8bc1d5ac32b22b15d02854b25055a18da5a7fc6cf6736cdb7",
                    "title" : "OhMySwift",
                    "url" : "https:\/\/ohmyswift.com\/blog\/feed.xml"
                  },
                  {
                    "id" : "8c197ae58a41dabab034b5ea824cfa52dd32f6d9006991a9cdc7495b35f533a9",
                    "title" : "Swift Tool Kit",
                    "url" : "https:\/\/www.swifttoolkit.dev\/feed.rss"
                  }
                ]
                """#
            }
        }
    }
    
    @Test func generateCommunitiesJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }

        let fileURL = testURL.appending(path: "Events")
        let communityURL = fileURL.appending(path: "Swift-Ahmedabad")
        let aboutURL = communityURL.appending(path: ".about")
        try FileManager.default.createDirectory(at: aboutURL, withIntermediateDirectories: true)
        try """
        name: "Swift Ahmedabad"
        description: "A welcoming space where everyone who is interested in Swift or Apple Ecosystem can connect and grow together."
        logo: "swift-ahmedabad-logo.png"
        members:
            - name: "Devanshi Modha"
              about: "Software Engineer (iOS)"
              socials:
                linkedIn: "https://www.linkedin.com/in/devanshimodha/"
        socialMedias:
            linkedIn: "https://www.linkedin.com/company/swiftahmedabad/"
        """
            .data(using: .utf8)!.write(to: aboutURL.appending(path: "About.yaml"))

        let eventsURL = communityURL.appending(path: "1. Apr 20 2025")
        let event1URL = eventsURL.appending(path: "Talk1")
        try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
        let speakerYML =
        """
        - name: Johny Appleseed
          socials:
            linkedIn: https://www.linkedin.com/in/johny-appleseed/
          about: Apple Engineer
        """
        let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
        try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)

        try withSnapshotTesting {
            let eventInfos = try Parser.parse(at: fileURL.path(percentEncoded: false))
            let communities = eventInfos.communities
            let jsonURL = fileURL.appending(path: "communities.json")
            try Generator.generateJson(for: communities, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                #"""
                [
                  {
                    "id" : "af6eae965cda4357726fed771504a26fe6ceaed52bf0e3e81dffd409925bb735",
                    "logo" : "swift-ahmedabad-logo.png",
                    "name" : "Swift Ahmedabad",
                    "resourcePath" : "Swift Ahmedabad"
                  }
                ]
                """#
            }
        }
    }

    @Test func generateCommunityEventsJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function)
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }

        let fileURL = testURL.appending(path: "Events")
        let communityURL = fileURL.appending(path: "Swift-Ahmedabad")
        let aboutURL = communityURL.appending(path: ".about")
        try FileManager.default.createDirectory(at: aboutURL, withIntermediateDirectories: true)
        try """
        name: "Swift Ahmedabad"
        description: "A welcoming space where everyone who is interested in Swift or Apple Ecosystem can connect and grow together."
        logo: "swift-ahmedabad-logo.png"
        members:
            - name: "Devanshi Modha"
              about: "Software Engineer (iOS)"
              socials:
                linkedIn: "https://www.linkedin.com/in/devanshimodha/"
        socialMedias:
            linkedIn: "https://www.linkedin.com/company/swiftahmedabad/"
        """
            .data(using: .utf8)!.write(to: aboutURL.appending(path: "About.yaml"))

        for eventNum in 1...3 {
            let eventsURL = communityURL.appending(path: "\(eventNum). Apr \(eventNum) 2025")
            let event1URL = eventsURL.appending(path: "Talk1")
            try FileManager.default.createDirectory(at: event1URL, withIntermediateDirectories: true)
            let speakerYML =
            """
            - name: Speaker \(eventNum)
              socials:
                linkedIn: https://www.linkedin.com/in/speaker\(eventNum)/
              about: Speaker \(eventNum)
            """
            let speakerYMLURL = event1URL.appendingPathComponent("Speaker.yml")
            try speakerYML.write(to: speakerYMLURL, atomically: true, encoding: .utf8)
        }

        try withSnapshotTesting {
            let eventInfos = try Parser.parse(at: fileURL.path(percentEncoded: false))
            let communityEvents = eventInfos.communityEvents
            let jsonURL = fileURL.appending(path: "communityEvents.json")
            try Generator.generateJson(for: communityEvents, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                """
                [
                  {
                    "communityID" : "af6eae965cda4357726fed771504a26fe6ceaed52bf0e3e81dffd409925bb735",
                    "eventID" : "129a905b72e98ccf081ed1c9fdc89174c00876e1d242b134d51525062f240ca5",
                    "id" : "adae352db03167f6598775cfff6646756f5ebce08fe006c8b6fa616ad4210aea"
                  },
                  {
                    "communityID" : "af6eae965cda4357726fed771504a26fe6ceaed52bf0e3e81dffd409925bb735",
                    "eventID" : "8396af17bed201329c4db85697d8d0d598c533a2e61c0dff6c78ef1b76e4f4da",
                    "id" : "8466283a6d6cf505b7cb023048405de074367853e7afafbcbd99c458a2f27b0b"
                  },
                  {
                    "communityID" : "af6eae965cda4357726fed771504a26fe6ceaed52bf0e3e81dffd409925bb735",
                    "eventID" : "c04c73e5fdbc42066194c923efe4e4fd56777948474f88ccf379a15e2b221d9b",
                    "id" : "2b3ee7899f7779cfd54d16ba3b6a5c98bf37a6f6bd08c1c64d4b2850577dea3a"
                  }
                ]
                """
            }
        }
    }

    @Test func generateYearInReviewJSON() throws {
        let testURL = URL(filePath: ".").appending(path: #function).appending(path: "Swift-Ahmedabad")
        defer {
            try? FileManager.default.removeItem(at: testURL)
        }
        
        let fileURL = testURL.appending(path: "Events")
        let yearsInReviewURL = fileURL.appending(path: ".yearsInReview")
        try FileManager.default.createDirectory(at: yearsInReviewURL, withIntermediateDirectories: true)
        let year2024URL = yearsInReviewURL.appending(path: "year2024.yml")
        try """
        year: 2024
        org: Swift Ahmedabad

        eventStats:
            totalEvents: 4
            totalParticipants: 188
            averageParticipants: 47
            totalSpeakers: 10
            topicsCovered: 9
            totalVenues: 3
            totalSponsors: 3
        
        photos:
            - photo1
            - photo2
            - photo3
        """
        .data(using: .utf8)?.write(to: year2024URL)
        
        try withSnapshotTesting {
            let yearsInReview = try Parser.events(from: fileURL.path(percentEncoded: false)).yearsInReview
            let jsonURL = fileURL.appending(path: "yearsInReview.json")
            try Generator.generateJson(for: yearsInReview, at: jsonURL)
            assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
                """
                [
                  {
                    "eventStats" : {
                      "averageParticipants" : 47,
                      "topicsCovered" : 9,
                      "totalEvents" : 4,
                      "totalParticipants" : 188,
                      "totalSpeakers" : 10,
                      "totalSponsors" : 3,
                      "totalVenues" : 3
                    },
                    "id" : "0cdf61b8efe97ecd872ab84c3736a668da32d335fce2fe690be8a5b516e8b249",
                    "org" : "Swift Ahmedabad",
                    "photos" : [
                      "photo1",
                      "photo2",
                      "photo3"
                    ],
                    "year" : 2024
                  }
                ]
                """
            }
        }

    }
}
