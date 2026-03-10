//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 17/02/26.
//

import Foundation

public struct NewsItems {
    public var newsSources: [NewsSource]
    public var podcasts: [PodcastSource]
    
    public init(newsSources: [NewsSource] = [], podcasts: [PodcastSource] = []) {
        self.newsSources = newsSources
        self.podcasts = podcasts
    }
}
