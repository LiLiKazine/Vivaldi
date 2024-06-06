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
    var star: Bool
    var pin: Bool
    var dir: UUID?
    var relativePath: String
    var thumbRelativePath: String?
    
    init(date: Date = Date(), name: String = "untitled", relativePath: String, star: Bool = false, pin: Bool = false) {
        self.date = date
        self.name = name
        self.star = star
        self.pin = pin
        self.relativePath = relativePath
    }
    
}
