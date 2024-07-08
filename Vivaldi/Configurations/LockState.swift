//
//  LockState.swift
//  Vivaldi
//
//  Created by LiLi on 2023/11/28.
//

import Foundation

@Observable
class LockState {
    var isLocked: Bool = true
    
    static let shared = LockState()
}
