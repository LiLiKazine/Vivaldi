//
//  VivaldiApp.swift
//  Vivaldi
//
//  Created by LiLi on 2023/11/28.
//

import SwiftUI
import SwiftData

@main
struct VivaldiApp: App {
    
    @State private var uiConfiguration = UIConfiguration.shared
    @State private var lockState = LockState.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(lockState)
        .environment(uiConfiguration)
    }
}
