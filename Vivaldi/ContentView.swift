//
//  ContentView.swift
//  Vivaldi
//
//  Created by LiLi on 2023/11/28.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject var lockState: LockState

    var body: some View {
        if lockState.isLocked {
            AuthView()
        } else {
            GalleryView()
        }
    }

   
}

#Preview {
    ContentView()
        .environmentObject(LockState())
}
