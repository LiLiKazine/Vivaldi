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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(LockState())
        .environment(uiConfiguration)
    }
}
