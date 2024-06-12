//
//  Photo.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/19.
//
//

import Foundation
import SwiftData


@Model 
final class Photo {
    var date: Date
    var name: String
    var star: Bool = false
    var pin: Bool = false
    var albums: [Album] = []
    var relativePath: String
    var thumbRelativePath: String?
    
    init(date: Date = Date(), name: String = "untitled", relativePath: String) {
        self.date = date
        self.name = name
        self.relativePath = relativePath
    }
    
}
