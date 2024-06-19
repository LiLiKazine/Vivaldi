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
    var coverRelativePath: String
    
    init(relativePath: String, coverRelativePath: String) {
        self.relativePath = relativePath
        self.coverRelativePath = coverRelativePath
    }
}
