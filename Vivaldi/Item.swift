//
//  Item.swift
//  Vivaldi
//
//  Created by LiLi on 2023/11/28.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
