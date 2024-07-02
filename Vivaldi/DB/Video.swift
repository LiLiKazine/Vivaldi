//
//  Video.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/19.
//

import Foundation
import SwiftData

struct Video: Codable {
    
    var relativePath: String
    var coverRelativePath: String?
    var duration: TimeInterval
    
    init(relativePath: String, coverRelativePath: String? = nil, duration: TimeInterval = 0) {
        self.relativePath = relativePath
        self.coverRelativePath = coverRelativePath
        self.duration = duration
    }
}
