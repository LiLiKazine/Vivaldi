//
//  UIConfiguration.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/17.
//

import Foundation


@Observable
class UIConfiguration {
    var photoColumns: Int = 3
    var photoFrameSize: (width: CGFloat?, height: CGFloat?) = (nil, 100)
    
    static let shared = UIConfiguration()
}
