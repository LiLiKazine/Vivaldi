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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Photo.self]) { result in
            switch result {
            case .success(let success):
                print("container setup success: \(success)")
            case .failure(let failure):
                print("container setup failed: \(failure.localizedDescription) \(failure)")
            }
        }
        .environmentObject(LockState())
    }
}
