//
//  Album.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/12.
//

import Foundation
import SwiftData

@Model
final class Album {
    
    var date: Date
    var name: String
    var star: Bool = false
    @Relationship(deleteRule: .noAction, inverse: \Photo.albums)
    var photos: [Photo] = []
    
    init(date: Date = Date(), name: String = "untitled") {
        self.date = date
        self.name = name
    }
    
}
