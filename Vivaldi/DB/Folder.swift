//
//  Album.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/12.
//

import Foundation
import SwiftData

@Model
final class Folder {
    
    var date: Date
    var name: String
    var star: Bool = false
    @Relationship(deleteRule: .noAction, inverse: \Document.folders)
    var documents: [Document] = []
    
    init(date: Date = Date(), name: String = "untitled") {
        self.date = date
        self.name = name
    }
    
}
