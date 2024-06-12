//
//  GalleryView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/19.
//

import SwiftUI
import SwiftData

struct GalleryView: View {
    
    @Query(sort: \Photo.date) var photos: [Photo]
    
    var body: some View {
        
         content()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    importView(hint: "Import")
                }
            }
    }
    
    @ViewBuilder func content() -> some View {
        if photos.isEmpty {
            importView(hint: "Import assets from album")
        } else {
            ShowcaseView(photos: photos)
        }
    }
    
    func importView(hint: String) -> some View {
        WaitToImportView(hint: hint)
    }
}

#Preview {
    GalleryView()
}
