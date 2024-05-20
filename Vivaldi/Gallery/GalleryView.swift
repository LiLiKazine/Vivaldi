//
//  GalleryView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/19.
//

import SwiftUI
import SwiftData

struct GalleryView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Photo.date) var photos: [Photo]
    
    var body: some View {
        if photos.isEmpty {
            WaitToImportView(inserter: AlbumItemInserterImp(modelContext: modelContext))
        } else {
            Text(String(photos.count))
        }
            
    }
}

#Preview {
    GalleryView()
}
