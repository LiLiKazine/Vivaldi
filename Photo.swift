//
//  Item.swift
//  Vivaldi
//
//  Created by LiLi on 2023/11/27.
//

import Foundation
import SwiftData

@Model
final class Photo {
    var name: String
    var timestamp: Date
    var path: String
    
    init(name: String, timestamp: Date, path: String) {
        self.name = name
        self.timestamp = timestamp
        self.path = path
    }
}
