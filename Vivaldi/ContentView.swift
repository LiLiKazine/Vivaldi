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
            NavigationStack {
                GalleryView()        
                    .modelContainer(LocalContainer.sharedContainer)
                    .environment(\.photoInteractor, LocalContainer.sharedPhotoInteractor)
            }
        }
    }

   
}

#Preview {
    ContentView()
        .environmentObject(LockState())
}
