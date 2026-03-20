//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 16/03/26.
//

import Foundation

public struct Recording: Equatable, Identifiable, Codable {
    public var talkID: Talk.ID
    public var recording: URL
    
    public init(talkID: Talk.ID, recording: URL) {
        self.talkID = talkID
        self.recording = recording
    }
    
    public var id: Talk.ID { talkID }
}
