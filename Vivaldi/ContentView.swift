//
//  ContentView.swift
//  Vivaldi
//
//  Created by LiLi on 2023/11/28.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(LockState.self) var lockState

    var body: some View {
        NavigationStack {
            GalleryView()
                .modelContainer(LocalContainer.sharedContainer)
                .environment(\.photoInteractor, LocalContainer.sharedPhotoInteractor)
        }
        .overlay {
            if lockState.isLocked {
                AuthView()
            }
        }
    }

   
}

#Preview {
    ContentView()
        .environment(LockState.shared)
}
