//
//  Photo.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/19.
//
//

import Foundation
import SwiftData

struct Photo: Codable {
    var relativePath: String
    var thumbRelativePath: String?
    
    init(relativePath: String, thumbRelativePath: String? = nil) {
        self.relativePath = relativePath
        self.thumbRelativePath = thumbRelativePath
    }
    
}
