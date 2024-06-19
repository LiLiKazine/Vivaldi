//
//  Document.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/19.
//

import Foundation
import SwiftData

@Model
final class Document {
    var date: Date = Date()
    var name: String
    var star: Bool = false
    var pin: Bool = false
    var folders: [Folder] = []
    var media: Media
    
    init(name: String, media: Media) {
        self.name = name
        self.media = media
    }
    
    convenience init(photoName: String, relativePath: String) {
        self.init(name: photoName, media: .photo(.init(relativePath: relativePath)))
    }
    
    convenience init(videoName: String, relativePath: String, coverRelativePath: String) {
        self.init(name: videoName, media: .video(.init(relativePath: relativePath, coverRelativePath: coverRelativePath)))
    }
}

extension Document {
    var relativePath: String {
        get {
            media.relativePath
        }
        set {
            media.relativePath = newValue
        }
    }
    
    var thumbRelativePath: String? {
        media.value(of: \.thumbRelativePath) ?? nil
    }
    
    var coverRelativePath: String? {
        media.value(of: \.coverRelativePath)
    }
}
