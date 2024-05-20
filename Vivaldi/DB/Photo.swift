//
//  Photo.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/19.
//
//

import Foundation
import SwiftData


@Model public class Photo {
    var date: Date = Date()
    var name: String = "No name"
    var star: Bool = false
    var pin: Bool = false
    var dir: UUID?
    var relativePath: String = ""
    var thumbRelativePath: String?
    
    public init(date: Date = Date(), name: String, relativePath: String, star: Bool = false, pin: Bool = false) {
        self.date = date
        self.name = name
        self.star = star
        self.pin = pin
        self.relativePath = relativePath
    }
    
}
